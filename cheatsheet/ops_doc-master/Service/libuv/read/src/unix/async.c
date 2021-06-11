/* Copyright Joyent, Inc. and other Node contributors. All rights reserved.
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

/* This file contains both the uv__async internal infrastructure and the
 * user-facing uv_async_t functions.
 */

#include "uv.h"
#include "internal.h"
#include "atomic-ops.h"

#include <errno.h>
#include <stdio.h>  /* snprintf() */
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static void uv__async_send(uv_loop_t* loop);
static int uv__async_start(uv_loop_t* loop);
static int uv__async_eventfd(void);

// 注意：该初始化函数不同于其他初始化函数，该函数会立即启动 Handle，所以没有 Start。
/*
uv__async_start 初始化并启动了 loop->async_io_watcher，使事件循环能够通过 loop->async_io_watcher 接收到其他线程发送的唤醒消息。
在进行简单的初始化后，直接启动了 handle，并不需要像其他 handle 一样提供 uv_async_start 这样的方法。
我们继续看一下 uv__async_start 如何工作：
*/
int uv_async_init(uv_loop_t* loop, uv_async_t* handle, uv_async_cb async_cb) {
  int err;

  err = uv__async_start(loop);
  if (err)
    return err;

  uv__handle_init(loop, (uv_handle_t*)handle, UV_ASYNC);
  handle->async_cb = async_cb;
  handle->pending = 0;

  QUEUE_INSERT_TAIL(&loop->async_handles, &handle->queue);
  uv__handle_start(handle);

  return 0;
}


int uv_async_send(uv_async_t* handle) {
  /* Do a cheap read first. */
  if (ACCESS_ONCE(int, handle->pending) != 0)
    return 0;

  if (cmpxchgi(&handle->pending, 0, 1) == 0)
    uv__async_send(handle->loop);

  return 0;
}


void uv__async_close(uv_async_t* handle) {
  QUEUE_REMOVE(&handle->queue);
  uv__handle_stop(handle);
}

// loop->async_io_watcher 上的I/O事件，由 uv__async_io 处理，它的实现如下：
/*
逻辑如下：
    不断的读取 w->fd 上的数据到 buf 中直到为空，buf 中的数据无实际用途；
    遍历 loop->async_handles 队列，调用所有 h->pending 值为 1 的 handle 的 async_cb 函数如果存在的话。
h->pending 是在 uv_async_send 中被设置为 1。因为 h->pending 会在多线程中被访问到，
所以存在资源争抢的临界状态，cmpxchgi 是原子操作，在这段代码中，
    如果 h->pending == 1 会被原子的 修改成 0，其他线程中对 h->pending 的读写也通过 cmpxchgi 
进行原子操作，防止同时读写程序异常。
如上文所述，uv__async_io 并不知道是哪个 Async Handle 上调用的，uv__async_io 实际上调用了所有的 h->pending 
值为 1 也就是发送过唤醒信号的 handle。实际上，Async 的设计的目的是能够唤醒主事件循环线程，所以 libuv 
并需要关心是哪个 Async Handle 发送的信号，有可能同时发送。
*/
static void uv__async_io(uv_loop_t* loop, uv__io_t* w, unsigned int events) {
  char buf[1024];
  ssize_t r;
  QUEUE queue;
  QUEUE* q;
  uv_async_t* h;

  assert(w == &loop->async_io_watcher);

  for (;;) {
    r = read(w->fd, buf, sizeof(buf));

    if (r == sizeof(buf))
      continue;

    if (r != -1)
      break;

    if (errno == EAGAIN || errno == EWOULDBLOCK)
      break;

    if (errno == EINTR)
      continue;

    abort();
  }

  QUEUE_MOVE(&loop->async_handles, &queue);
  while (!QUEUE_EMPTY(&queue)) {
    q = QUEUE_HEAD(&queue);
    h = QUEUE_DATA(q, uv_async_t, queue);

    QUEUE_REMOVE(q);
    QUEUE_INSERT_TAIL(&loop->async_handles, q);
    /*
      将第一个参数和第二个参数进行比较，如果相等，
      则将第三参数写入第一个参数，返回第二个参数的值，
      如果不相等，则返回第一个参数的值。
    */
    // pending在uv_async_send里设置成1，如果pending等于1，则清0，返回1.如果pending等于0，则返回0
    if (cmpxchgi(&h->pending, 1, 0) == 0)
      continue;

    if (h->async_cb == NULL)
      continue;

    h->async_cb(h);
  }
}


static void uv__async_send(uv_loop_t* loop) {
  const void* buf;
  ssize_t len;
  int fd;
  int r;

  buf = "";
  len = 1;
  fd = loop->async_wfd;

#if defined(__linux__)
  // 说明用的是eventfd而不是管道
  if (fd == -1) {
    static const uint64_t val = 1;
    buf = &val;
    len = sizeof(val);
    // 见uv__async_start
    fd = loop->async_io_watcher.fd;  /* eventfd */
  }
#endif
  // 通知读端
  do
    r = write(fd, buf, len);
  while (r == -1 && errno == EINTR);

  if (r == len)
    return;

  if (r == -1)
    if (errno == EAGAIN || errno == EWOULDBLOCK)
      return;

  abort();
}


/*
函数中，初始化并启动了 loop->async_io_watcher，该函数中创建了管道，其本质是一个内核缓冲区（4k），
有两个文件描述符引用，用于有血缘关系的进程和线程间进行数据传递（通信），pipefd 保存了管道的两端
的文件描述符，pipefd[0] 用于读数据，pipefd[1] 用于写数据，pipefd[1] 被保存到了 loop->async_wfd，
通过I/O观察者监听 pipefd[0] 即可接收消息，通过向 loop->async_wfd 写数据，即可发送消息。uv__async_start 
在已经初始化 loop->async_io_watcher 的情况下，无需再次初始化。

*/
static int uv__async_start(uv_loop_t* loop) {
  int pipefd[2];
  int err;

  if (loop->async_io_watcher.fd != -1)
    return 0;
  // 获取一个用于进程间通信的fd
  err = uv__async_eventfd();
  // 成功则保存起来，不支持则使用管道通信作为进程间通信
  if (err >= 0) {
    pipefd[0] = err;
    pipefd[1] = -1;
  }
  else if (err == UV_ENOSYS) {
    err = uv__make_pipe(pipefd, UV__F_NONBLOCK);
#if defined(__linux__)
    /* Save a file descriptor by opening one of the pipe descriptors as
     * read/write through the procfs.  That file descriptor can then
     * function as both ends of the pipe.
     */
    if (err == 0) {
      char buf[32];
      int fd;

      snprintf(buf, sizeof(buf), "/proc/self/fd/%d", pipefd[0]);
      fd = uv__open_cloexec(buf, O_RDWR);
      if (fd >= 0) {
        uv__close(pipefd[0]);
        uv__close(pipefd[1]);
        pipefd[0] = fd;
        pipefd[1] = fd;
      }
    }
#endif
  }

  if (err < 0)
    return err;
  // 初始化io观察者async_io_watcher
  uv__io_init(&loop->async_io_watcher, uv__async_io, pipefd[0]);
  // 注册io观察者到loop里，并注册需要监听的事件POLLIN，读
  uv__io_start(loop, &loop->async_io_watcher, POLLIN);
  loop->async_wfd = pipefd[1];

  return 0;
}


int uv__async_fork(uv_loop_t* loop) {
  if (loop->async_io_watcher.fd == -1) /* never started */
    return 0;

  uv__async_stop(loop);

  return uv__async_start(loop);
}


void uv__async_stop(uv_loop_t* loop) {
  if (loop->async_io_watcher.fd == -1)
    return;

  if (loop->async_wfd != -1) {
    if (loop->async_wfd != loop->async_io_watcher.fd)
      uv__close(loop->async_wfd);
    loop->async_wfd = -1;
  }

  uv__io_stop(loop, &loop->async_io_watcher, POLLIN);
  uv__close(loop->async_io_watcher.fd);
  loop->async_io_watcher.fd = -1;
}


static int uv__async_eventfd(void) {
#if defined(__linux__)
  static int no_eventfd2;
  static int no_eventfd;
  int fd;

  if (no_eventfd2)
    goto skip_eventfd2;

  fd = uv__eventfd2(0, UV__EFD_CLOEXEC | UV__EFD_NONBLOCK);
  if (fd != -1)
    return fd;

  if (errno != ENOSYS)
    return UV__ERR(errno);

  no_eventfd2 = 1;

skip_eventfd2:

  if (no_eventfd)
    goto skip_eventfd;

  fd = uv__eventfd(0);
  if (fd != -1) {
    uv__cloexec(fd, 1);
    uv__nonblock(fd, 1);
    return fd;
  }

  if (errno != ENOSYS)
    return UV__ERR(errno);

  no_eventfd = 1;

skip_eventfd:

#endif

  return UV_ENOSYS;
}
