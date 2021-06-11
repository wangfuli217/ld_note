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

/*
 * This file is private to libuv. It provides common functionality to both
 * Windows and Unix backends.
 */

#ifndef UV_COMMON_H_
#define UV_COMMON_H_

#include <assert.h>
#include <stdarg.h>
#include <stddef.h>

#if defined(_MSC_VER) && _MSC_VER < 1600
# include "uv/stdint-msvc2008.h"
#else
# include <stdint.h>
#endif

#include "uv.h"
#include "uv/tree.h"
#include "queue.h"

#if EDOM > 0
# define UV__ERR(x) (-(x))
#else
# define UV__ERR(x) (x)
#endif

#if !defined(snprintf) && defined(_MSC_VER) && _MSC_VER < 1900
extern int snprintf(char*, size_t, const char*, ...);
#endif

#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))

#define container_of(ptr, type, member) \
  ((type *) ((char *) (ptr) - offsetof(type, member)))

#define STATIC_ASSERT(expr)                                                   \
  void uv__static_assert(int static_assert_failed[1 - 2 * !(expr)])

/* Handle flags. Some flags are specific to Windows or UNIX. */
// 所有 handle 都具备 UV_HANDLE_ACTIVE UV_HANDLE_CLOSED 等几个公共状态，还有一些特地 handle 特定的状态。

enum {
  /* Used by all handles. */
  UV_HANDLE_CLOSING                     = 0x00000001,
  UV_HANDLE_CLOSED                      = 0x00000002,
  UV_HANDLE_ACTIVE                      = 0x00000004,
  UV_HANDLE_REF                         = 0x00000008,
  UV_HANDLE_INTERNAL                    = 0x00000010,
  UV_HANDLE_ENDGAME_QUEUED              = 0x00000020,

  /* Used by streams. */
  UV_HANDLE_LISTENING                   = 0x00000040,
  UV_HANDLE_CONNECTION                  = 0x00000080,
  UV_HANDLE_SHUTTING                    = 0x00000100,
  UV_HANDLE_SHUT                        = 0x00000200,
  UV_HANDLE_READ_PARTIAL                = 0x00000400,
  UV_HANDLE_READ_EOF                    = 0x00000800,

  /* Used by streams and UDP handles. */
  UV_HANDLE_READING                     = 0x00001000,
  UV_HANDLE_BOUND                       = 0x00002000,
  UV_HANDLE_READABLE                    = 0x00004000,
  UV_HANDLE_WRITABLE                    = 0x00008000,
  UV_HANDLE_READ_PENDING                = 0x00010000,
  UV_HANDLE_SYNC_BYPASS_IOCP            = 0x00020000,
  UV_HANDLE_ZERO_READ                   = 0x00040000,
  UV_HANDLE_EMULATE_IOCP                = 0x00080000,
  UV_HANDLE_BLOCKING_WRITES             = 0x00100000,
  UV_HANDLE_CANCELLATION_PENDING        = 0x00200000,

  /* Used by uv_tcp_t and uv_udp_t handles */
  UV_HANDLE_IPV6                        = 0x00400000,

  /* Only used by uv_tcp_t handles. */
  UV_HANDLE_TCP_NODELAY                 = 0x01000000,
  UV_HANDLE_TCP_KEEPALIVE               = 0x02000000,
  UV_HANDLE_TCP_SINGLE_ACCEPT           = 0x04000000,
  UV_HANDLE_TCP_ACCEPT_STATE_CHANGING   = 0x08000000,
  UV_HANDLE_TCP_SOCKET_CLOSED           = 0x10000000,
  UV_HANDLE_SHARED_TCP_SOCKET           = 0x20000000,

  /* Only used by uv_udp_t handles. */
  UV_HANDLE_UDP_PROCESSING              = 0x01000000,

  /* Only used by uv_pipe_t handles. */
  UV_HANDLE_NON_OVERLAPPED_PIPE         = 0x01000000,
  UV_HANDLE_PIPESERVER                  = 0x02000000,

  /* Only used by uv_tty_t handles. */
  UV_HANDLE_TTY_READABLE                = 0x01000000,
  UV_HANDLE_TTY_RAW                     = 0x02000000,
  UV_HANDLE_TTY_SAVED_POSITION          = 0x04000000,
  UV_HANDLE_TTY_SAVED_ATTRIBUTES        = 0x08000000,

  /* Only used by uv_signal_t handles. */
  UV_SIGNAL_ONE_SHOT_DISPATCHED         = 0x01000000,
  UV_SIGNAL_ONE_SHOT                    = 0x02000000,

  /* Only used by uv_poll_t handles. */
  UV_HANDLE_POLL_SLOW                   = 0x01000000
};

int uv__loop_configure(uv_loop_t* loop, uv_loop_option option, va_list ap);

void uv__loop_close(uv_loop_t* loop);

int uv__tcp_bind(uv_tcp_t* tcp,
                 const struct sockaddr* addr,
                 unsigned int addrlen,
                 unsigned int flags);

int uv__tcp_connect(uv_connect_t* req,
                   uv_tcp_t* handle,
                   const struct sockaddr* addr,
                   unsigned int addrlen,
                   uv_connect_cb cb);

int uv__udp_bind(uv_udp_t* handle,
                 const struct sockaddr* addr,
                 unsigned int  addrlen,
                 unsigned int flags);

int uv__udp_send(uv_udp_send_t* req,
                 uv_udp_t* handle,
                 const uv_buf_t bufs[],
                 unsigned int nbufs,
                 const struct sockaddr* addr,
                 unsigned int addrlen,
                 uv_udp_send_cb send_cb);

int uv__udp_try_send(uv_udp_t* handle,
                     const uv_buf_t bufs[],
                     unsigned int nbufs,
                     const struct sockaddr* addr,
                     unsigned int addrlen);

int uv__udp_recv_start(uv_udp_t* handle, uv_alloc_cb alloccb,
                       uv_udp_recv_cb recv_cb);

int uv__udp_recv_stop(uv_udp_t* handle);

void uv__fs_poll_close(uv_fs_poll_t* handle);

int uv__getaddrinfo_translate_error(int sys_err);    /* EAI_* error. */

enum uv__work_kind {
  UV__WORK_CPU,
  UV__WORK_FAST_IO,
  UV__WORK_SLOW_IO
};

void uv__work_submit(uv_loop_t* loop,
                     struct uv__work *w,
                     enum uv__work_kind kind,
                     void (*work)(struct uv__work *w),
                     void (*done)(struct uv__work *w, int status));

void uv__work_done(uv_async_t* handle);

size_t uv__count_bufs(const uv_buf_t bufs[], unsigned int nbufs);

int uv__socket_sockopt(uv_handle_t* handle, int optname, int* value);

void uv__fs_scandir_cleanup(uv_fs_t* req);

int uv__next_timeout(const uv_loop_t* loop);
void uv__run_timers(uv_loop_t* loop);
void uv__timer_close(uv_timer_t* handle);

#define uv__has_active_reqs(loop)                                             \
  ((loop)->active_reqs.count > 0)

#define uv__req_register(loop, req)                                           \
  do {                                                                        \
    (loop)->active_reqs.count++;                                              \
  }                                                                           \
  while (0)

#define uv__req_unregister(loop, req)                                         \
  do {                                                                        \
    assert(uv__has_active_reqs(loop));                                        \
    (loop)->active_reqs.count--;                                              \
  }                                                                           \
  while (0)

#define uv__has_active_handles(loop)                                          \
  ((loop)->active_handles > 0)

#define uv__active_handle_add(h)                                              \
  do {                                                                        \
    (h)->loop->active_handles++;                                              \
  }                                                                           \
  while (0)

#define uv__active_handle_rm(h)                                               \
  do {                                                                        \
    (h)->loop->active_handles--;                                              \
  }                                                                           \
  while (0)

#define uv__is_active(h)                                                      \
  (((h)->flags & UV_HANDLE_ACTIVE) != 0)

#define uv__is_closing(h)                                                     \
  (((h)->flags & (UV_HANDLE_CLOSING | UV_HANDLE_CLOSED)) != 0)

// uv__handle_start 将 handle 设置为 UV_HANDLE_ACTIVE 状态，并通过 uv__active_handle_add 
//更新活动的 handle 引用计数。如果不存在 UV_HANDLE_REF 标志位，则不会增加引用计数。
/*
    虽然对 handle 进行了 Start 操作，但是实际仅仅是设置了个标志位和增加了一个引用计数而已，
看不到任何的 Start，实际上是告诉 libuv 该 handle 准备好了，可以 Go 了。因为更新引用计数间接影响了事件循环的活动状态。
uv_run 才是真正的启动操作，向 libuv 表明 Ready 了之后，uv_run 的时候才会处理这个 handle。
*/
#define uv__handle_start(h)                                                   \
  do {                                                                        \
    if (((h)->flags & UV_HANDLE_ACTIVE) != 0) break;                          \
    (h)->flags |= UV_HANDLE_ACTIVE;                                           \
    if (((h)->flags & UV_HANDLE_REF) != 0) uv__active_handle_add(h);          \
  }                                                                           \
  while (0)

// handle 的 Stop： 操作 由 uv__handle_stop 宏实现：
/* 
    uv__handle_stop 将 handle 设置为 ~UV_HANDLE_ACTIVE 状态，并通过 uv__active_handle_rm 
更新活动的 handle 引用计数。如果不存在 UV_HANDLE_REF 标志位，则不会减少引用计数。
Stop 是 Start 的反向操作，将 handle 修改为非准备状态。 */
#define uv__handle_stop(h)                                                    \
  do {                                                                        \
    if (((h)->flags & UV_HANDLE_ACTIVE) == 0) break;                          \
    (h)->flags &= ~UV_HANDLE_ACTIVE;                                          \
    if (((h)->flags & UV_HANDLE_REF) != 0) uv__active_handle_rm(h);           \
  }                                                                           \
  while (0)

/*
handle 有个 UV_HANDLE_REF 标志位，这个状态用于控制 handle 是否计入 loop->active_handles 引用计数，
因为 handle 的引用计数影响 loop 活动状态，所以 UV_HANDLE_REF 状态会间接影响 loop 的状态。

存在引用计数标志 UV_HANDLE_REF，会计入引用计数，否则不会引用计数。
实现非常简单，在条件满足的情况下，更新 loop->active_handles 值。
在事件循环初始化函数 uv_loop_init 中，loop->child_watcher、loop->wq_async 都被 Unref 了，避免影响 loop 的存活状态。
*/
#define uv__handle_ref(h)                                                     \
  do {                                                                        \
    if (((h)->flags & UV_HANDLE_REF) != 0) break;                             \
    (h)->flags |= UV_HANDLE_REF;                                              \
    if (((h)->flags & UV_HANDLE_CLOSING) != 0) break;                         \
    if (((h)->flags & UV_HANDLE_ACTIVE) != 0) uv__active_handle_add(h);       \
  }                                                                           \
  while (0)

#define uv__handle_unref(h)                                                   \
  do {                                                                        \
    if (((h)->flags & UV_HANDLE_REF) == 0) break;                             \
    (h)->flags &= ~UV_HANDLE_REF;                                             \
    if (((h)->flags & UV_HANDLE_CLOSING) != 0) break;                         \
    if (((h)->flags & UV_HANDLE_ACTIVE) != 0) uv__active_handle_rm(h);        \
  }                                                                           \
  while (0)

#define uv__has_ref(h)                                                        \
  (((h)->flags & UV_HANDLE_REF) != 0)

#if defined(_WIN32)
# define uv__handle_platform_init(h) ((h)->u.fd = -1)
#else
# define uv__handle_platform_init(h) ((h)->next_closing = NULL)
#endif

// uv_handle_t 的初始化代码是用宏 uv__handle_init 定义的宏函数，实现如下：
/*
这段代码主要完成以下几个工作：
1. 关联 loop 到 handle，可以通过 handle 找到对应的 loop；
2. 设置 handle 类型；
3. 设置 handle 标识为 UV_HANDLE_REF，这个标识位决定了 handle 是否计入引用计数。后续 Start Stop 会看到其用途；
4. 将 handle 插入 loop->handle_queue 队列的尾部，所有初始化的 handle 就将被插入到这个队列中；
5. 通过 uv__handle_platform_init 平台特定初始化函数将 handle 的 next_closing 设置为 NULL，这是一个连接了所有关闭的 handle 的单链表。
*/
#define uv__handle_init(loop_, h, type_)                                      \
  do {                                                                        \
    (h)->loop = (loop_);                                                      \
    (h)->type = (type_);                                                      \
    (h)->flags = UV_HANDLE_REF;  /* Ref the loop when active. */              \
    QUEUE_INSERT_TAIL(&(loop_)->handle_queue, &(h)->handle_queue);            \
    uv__handle_platform_init(h);                                              \
  }                                                                           \
  while (0)

/* Note: uses an open-coded version of SET_REQ_SUCCESS() because of
 * a circular dependency between src/uv-common.h and src/win/internal.h.
 */
#if defined(_WIN32)
# define UV_REQ_INIT(req, typ)                                                \
  do {                                                                        \
    (req)->type = (typ);                                                      \
    (req)->u.io.overlapped.Internal = 0;  /* SET_REQ_SUCCESS() */             \
  }                                                                           \
  while (0)
#else
# define UV_REQ_INIT(req, typ)                                                \
  do {                                                                        \
    (req)->type = (typ);                                                      \
  }                                                                           \
  while (0)
#endif

#define uv__req_init(loop, req, typ)                                          \
  do {                                                                        \
    UV_REQ_INIT(req, typ);                                                    \
    uv__req_register(loop, req);                                              \
  }                                                                           \
  while (0)

/* Allocator prototypes */
void *uv__calloc(size_t count, size_t size);
char *uv__strdup(const char* s);
char *uv__strndup(const char* s, size_t n);
void* uv__malloc(size_t size);
void uv__free(void* ptr);
void* uv__realloc(void* ptr, size_t size);

#endif /* UV_COMMON_H_ */
