/* Copyright Joyent, Inc. and other Node contributors. All rights reserved.
 *
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

#include "uv.h"
#include "internal.h"

#include <unistd.h>
#include <assert.h>
#include <errno.h>

/*
uv_poll_t 用于监控文件描述符的 可读/可写 状态，和 poll 系统调用的用途类型，
不过 uv_poll_t 是异步非阻塞，而操作系统的原生 poll 函数是同步阻塞的。

uv_poll_t 是I/O观察者的简单封装后的应用程序接口，它只关心状态变化并调用用户层代码，
I/O事件之后将由外部库处理。相比之下，uv_stream_t 则复杂的多，uv_stream_t 更进一步
封装了数据读写操作等方面的能力，并将数据派发给不同类型的派生 handle 处理。

*/

//如果有I/O事件产生，uv__poll_io 会被 libuv 调用。
/*
uv__poll_io I/O事件的时候会被调用，工作逻辑如下：
    首先通过 container_of 获取 handle；
    如果是一些异常的I/O事件，则会进入 Stop 流程并调用 handle->poll_cb；
    将事件记录到 pevents；
    调用 handle->poll_cb。
    handle->poll_cb 是在 Start 阶段设置的，所以 uv__poll_io 一定是在 uv_poll_start 
调用后才能调用的，因为I/O事件在 uv_poll_start 后的下一次事件循环才能被处理。
    uv__poll_io 比较简单，可以说就是直接调用用户层提供的回调函数，正如 uv_poll_t 的用途一样，
负责监控文件描述符状态变化，但是不负责处理。

    除了 uv__poll_io 外，还有多个同样功能的 uv__io_cb 类型的函数存在，他们用于不同的功能，
通过全局搜索 uv__io_init 函数即可找到 uv__io_init 调用传递的不同 uv__io_cb 函数，如下：
    uv__signal_event，用于处理 loop->signal_io_watcher 上的I/O事件；
    uv__async_io，用于处理 loop->async_io_watcher 上的I/O事件；
    uv__stream_io，用于处理 stream_handle->io_watcher 上的I/O事件；
    uv__udp_io，用于处理 udp_handle->io_watcher 上的I/O事件。
以上这些 uv__io_cb 函数就没有 uv__poll_io 的实现简单了，它们都有更复杂的处理逻辑，如在 uv__stream_io 中，开始对文件描述符进行数据读写。
*/
static void uv__poll_io(uv_loop_t* loop, uv__io_t* w, unsigned int events) {
  uv_poll_t* handle;
  int pevents;

  handle = container_of(w, uv_poll_t, io_watcher);

  /*
   * As documented in the kernel source fs/kernfs/file.c #780
   * poll will return POLLERR|POLLPRI in case of sysfs
   * polling. This does not happen in case of out-of-band
   * TCP messages.
   *
   * The above is the case on (at least) FreeBSD and Linux.
   *
   * So to properly determine a POLLPRI or a POLLERR we need
   * to check for both.
   */
  if ((events & POLLERR) && !(events & UV__POLLPRI)) {
    uv__io_stop(loop, w, POLLIN | POLLOUT | UV__POLLRDHUP | UV__POLLPRI);
    uv__handle_stop(handle);
    handle->poll_cb(handle, UV_EBADF, 0);
    return;
  }

  pevents = 0;
  if (events & POLLIN)
    pevents |= UV_READABLE;
  if (events & UV__POLLPRI)
    pevents |= UV_PRIORITIZED;
  if (events & POLLOUT)
    pevents |= UV_WRITABLE;
  if (events & UV__POLLRDHUP)
    pevents |= UV_DISCONNECT;

  handle->poll_cb(handle, 0, pevents);
}

// 使用文件描述符初始化 poll。
/*
    以上代代码先是检查了文件描述符是否存在、文件描述符是否已经纳入监控等，然后调用 
uv__handle_init 和 uv__io_init 进行基类初始化，uv__io_init 是I/O观察者的初始化函数。
*/
int uv_poll_init(uv_loop_t* loop, uv_poll_t* handle, int fd) {
  int err;

  if (uv__fd_exists(loop, fd))
    return UV_EEXIST;

  err = uv__io_check_fd(loop, fd);
  if (err)
    return err;

  /* If ioctl(FIONBIO) reports ENOTTY, try fcntl(F_GETFL) + fcntl(F_SETFL).
   * Workaround for e.g. kqueue fds not supporting ioctls.
   */
  err = uv__nonblock(fd, 1);
  if (err == UV_ENOTTY)
    if (uv__nonblock == uv__nonblock_ioctl)
      err = uv__nonblock_fcntl(fd, 1);

  if (err)
    return err;

  uv__handle_init(loop, (uv_handle_t*) handle, UV_POLL);
  uv__io_init(&handle->io_watcher, uv__poll_io, fd);
  handle->poll_cb = NULL;
  return 0;
}


int uv_poll_init_socket(uv_loop_t* loop, uv_poll_t* handle,
    uv_os_sock_t socket) {
  return uv_poll_init(loop, handle, socket);
}


static void uv__poll_stop(uv_poll_t* handle) {
  uv__io_stop(handle->loop,
              &handle->io_watcher,
              POLLIN | POLLOUT | UV__POLLRDHUP | UV__POLLPRI);
  uv__handle_stop(handle);
  uv__platform_invalidate_fd(handle->loop, handle->io_watcher.fd);
}


int uv_poll_stop(uv_poll_t* handle) {
  assert(!uv__is_closing(handle));
  uv__poll_stop(handle);
  return 0;
}


int uv_poll_start(uv_poll_t* handle, int pevents, uv_poll_cb poll_cb) {
  int events;

  assert((pevents & ~(UV_READABLE | UV_WRITABLE | UV_DISCONNECT |
                      UV_PRIORITIZED)) == 0);
  assert(!uv__is_closing(handle));

  uv__poll_stop(handle);

  if (pevents == 0)
    return 0;

  events = 0;
  if (pevents & UV_READABLE)
    events |= POLLIN;
  if (pevents & UV_PRIORITIZED)
    events |= UV__POLLPRI;
  if (pevents & UV_WRITABLE)
    events |= POLLOUT;
  if (pevents & UV_DISCONNECT)
    events |= UV__POLLRDHUP;

  uv__io_start(handle->loop, &handle->io_watcher, events);
  uv__handle_start(handle);
  handle->poll_cb = poll_cb;

  return 0;
}


void uv__poll_close(uv_poll_t* handle) {
  uv__poll_stop(handle);
}
