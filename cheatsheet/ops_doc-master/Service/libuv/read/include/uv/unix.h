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

#ifndef UV_UNIX_H
#define UV_UNIX_H

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>

#include <termios.h>
#include <pwd.h>

#if !defined(__MVS__)
#include <semaphore.h>
#endif
#include <pthread.h>
#include <signal.h>

#include "uv/threadpool.h"

#if defined(__linux__)
# include "uv/linux.h"
#elif defined (__MVS__)
# include "uv/os390.h"
#elif defined(__PASE__)
# include "uv/posix.h"
#elif defined(_AIX)
# include "uv/aix.h"
#elif defined(__sun)
# include "uv/sunos.h"
#elif defined(__APPLE__)
# include "uv/darwin.h"
#elif defined(__DragonFly__)       || \
      defined(__FreeBSD__)         || \
      defined(__FreeBSD_kernel__)  || \
      defined(__OpenBSD__)         || \
      defined(__NetBSD__)
# include "uv/bsd.h"
#elif defined(__CYGWIN__) || defined(__MSYS__)
# include "uv/posix.h"
#elif defined(__GNU__)
# include "uv/posix.h"
#endif

#ifndef NI_MAXHOST
# define NI_MAXHOST 1025
#endif

#ifndef NI_MAXSERV
# define NI_MAXSERV 32
#endif

#ifndef UV_IO_PRIVATE_PLATFORM_FIELDS
# define UV_IO_PRIVATE_PLATFORM_FIELDS /* empty */
#endif

struct uv__io_s;
struct uv_loop_s;

typedef void (*uv__io_cb)(struct uv_loop_s* loop,
                          struct uv__io_s* w,
                          unsigned int events);
typedef struct uv__io_s uv__io_t;


/*
主要字段用途介绍：
    fd：感兴趣的 文件描述符；
    cb：当文件描述符 fd 上有I/O事件发生时，调用该函数进行处理，注意，该函数的类型 uv__io_cb 是内部类型，并不对外暴露，所以 cb 自然也是内部提供的。libuv针对不同类型的IO观察者实现了多个不同的 cb 函数；
    watcher_queue：作为队列节点，插入到 loop->watcher_queue 队列中，所有的I/O观察者都会被插入到这个队列中；
    pending_queue：作为队列节点，插入到 loop->pending_queue 队列中，所有被挂起的I/O观察者都会被插入到这个队列中；
    pevents：下次事件循环使用的事件掩码；
    events：当前正在使用的事件掩码。events |= pevents。
    
在 uv_stream_t（包括 uv_tcp_t、uv_pipe_t、uv_tty_t）、uv_udp_t、uv_poll_t 类型结构体内部都内嵌了 uv__io_t：
  uv__io_t io_watcher;
另外，在 uv_loop_s 中，同样也内嵌了多个 uv__io_t 关联字段：
*/
struct uv__io_s {
  uv__io_cb cb;
  void* pending_queue[2];
  void* watcher_queue[2];
  unsigned int pevents; /* Pending event mask i.e. mask at next tick. */
  unsigned int events;  /* Current event mask. */
  int fd;
  UV_IO_PRIVATE_PLATFORM_FIELDS
};

#ifndef UV_PLATFORM_SEM_T
# define UV_PLATFORM_SEM_T sem_t
#endif

#ifndef UV_PLATFORM_LOOP_FIELDS
# define UV_PLATFORM_LOOP_FIELDS /* empty */
#endif

#ifndef UV_PLATFORM_FS_EVENT_FIELDS
# define UV_PLATFORM_FS_EVENT_FIELDS /* empty */
#endif

#ifndef UV_STREAM_PRIVATE_PLATFORM_FIELDS
# define UV_STREAM_PRIVATE_PLATFORM_FIELDS /* empty */
#endif

/* Note: May be cast to struct iovec. See writev(2). */
typedef struct uv_buf_t {
  char* base;
  size_t len;
} uv_buf_t;

typedef int uv_file;
typedef int uv_os_sock_t;
typedef int uv_os_fd_t;
typedef pid_t uv_pid_t;

#define UV_ONCE_INIT PTHREAD_ONCE_INIT

typedef pthread_once_t uv_once_t;
typedef pthread_t uv_thread_t;
typedef pthread_mutex_t uv_mutex_t;
typedef pthread_rwlock_t uv_rwlock_t;
typedef UV_PLATFORM_SEM_T uv_sem_t;
typedef pthread_cond_t uv_cond_t;
typedef pthread_key_t uv_key_t;

/* Note: guard clauses should match uv_barrier_init's in src/unix/thread.c. */
#if defined(_AIX) || !defined(PTHREAD_BARRIER_SERIAL_THREAD)
/* TODO(bnoordhuis) Merge into uv_barrier_t in v2. */
struct _uv_barrier {
  uv_mutex_t mutex;
  uv_cond_t cond;
  unsigned threshold;
  unsigned in;
  unsigned out;
};

typedef struct {
  struct _uv_barrier* b;
# if defined(PTHREAD_BARRIER_SERIAL_THREAD)
  /* TODO(bnoordhuis) Remove padding in v2. */
  char pad[sizeof(pthread_barrier_t) - sizeof(struct _uv_barrier*)];
# endif
} uv_barrier_t;
#else
typedef pthread_barrier_t uv_barrier_t;
#endif

/* Platform-specific definitions for uv_spawn support. */
typedef gid_t uv_gid_t;
typedef uid_t uv_uid_t;

typedef struct dirent uv__dirent_t;

#if defined(DT_UNKNOWN)
# define HAVE_DIRENT_TYPES
# if defined(DT_REG)
#  define UV__DT_FILE DT_REG
# else
#  define UV__DT_FILE -1
# endif
# if defined(DT_DIR)
#  define UV__DT_DIR DT_DIR
# else
#  define UV__DT_DIR -2
# endif
# if defined(DT_LNK)
#  define UV__DT_LINK DT_LNK
# else
#  define UV__DT_LINK -3
# endif
# if defined(DT_FIFO)
#  define UV__DT_FIFO DT_FIFO
# else
#  define UV__DT_FIFO -4
# endif
# if defined(DT_SOCK)
#  define UV__DT_SOCKET DT_SOCK
# else
#  define UV__DT_SOCKET -5
# endif
# if defined(DT_CHR)
#  define UV__DT_CHAR DT_CHR
# else
#  define UV__DT_CHAR -6
# endif
# if defined(DT_BLK)
#  define UV__DT_BLOCK DT_BLK
# else
#  define UV__DT_BLOCK -7
# endif
#endif

/* Platform-specific definitions for uv_dlopen support. */
#define UV_DYNAMIC /* empty */

typedef struct {
  void* handle;
  char* errmsg;
} uv_lib_t;

/*
uv_idle_t 还会被插入到 loop->idle_handles 队列头部，队列节点为 handle->queue；
uv_check_t 还会被插入到 loop->check_handles 队列头部，队列节点为 handle->queue；
uv_check_t 还会被插入到 loop->prepare_handles 队列头部，队列节点为 handle->queue
*/
/*
watchers：咋看是一个二级指针，实际上是当做数组来使用的，数组的每一项存储了 uv__io_t* 类型的指针，
使用示例：w = loop->watchers[i];，所有的I/O观察者都有以文件描述符 fd 作为数组下标保存在这个数组中，
可以通过 fd 快速找到对应的I/O观察者。请仔细理解C语言数组和指针的关系，这里不能当做二级指针理解； 注意：
    该指针指向的内存空间是动态分配的，以适应I/O观察者的变化，动态分配算法见函数 maybe_resize；
    注意：实际分别长度为 nwatchers + 2；
nwatchers：记录了能容纳的IO观察者的数量，len(watchers) == nwatchers + 2；
nfds：记录了 watchers 中文件描述符的数量，也是实际使用量；
async_io_watcher：loop 内嵌的I/O观察者，这个I/O观察者用于其他异步任务（运行在其他线程中）通过IO与主事件循环进行通讯；
signal_io_watcher：loop 内嵌的I/O观察者，这个I/O观察者用于接收信号IO事件的。在 libuv 中，信号也被异步化到事件循环中去处理了；
inotify_read_watcher：UV_PLATFORM_LOOP_FIELDS 宏在 linux 平台下展开之后会有一个 inotify_read_watcher，这个是用来在 linux 下支持 uv_fs_event_t的，在其他 uni* 平台上，有对应的 event_watcher。

*/
#define UV_LOOP_PRIVATE_FIELDS  \
  unsigned long flags;          \
  int backend_fd;               \
  void* pending_queue[2];       \ 所有的挂起IO观察者都会被插入到这个队列中。
  void* watcher_queue[2];       \ 所有的IO观察者都会被插入到这个队列中。
  uv__io_t** watchers;          \
  unsigned int nwatchers;       \
  unsigned int nfds;            \
  void* wq[2];                  \ uv__work 是 libuv 中任务的抽象，任务有线程池处理，任务在发起 uv_work_t request 时创建。
  uv_mutex_t wq_mutex;          \
  uv_async_t wq_async;          \ uv_async_t 还会被插入到 loop->async_handles 队列尾部，队列节点为 handle->queue
  uv_rwlock_t cloexec_lock;     \
  uv_handle_t* closing_handles  \
  void* process_handles[2];     \ uv_process_t 还会被插入到 loop->process_handles 队列尾部，队列节点为 handle->queue。
  void* prepare_handles[2];     \
  void* check_handles[2];       \
  void* idle_handles[2];        \
  void* async_handles[2];       \
  void (*async_unused)(void);   \
  uv__io_t async_io_watcher;    \
  int async_wfd;                \
  struct {                      \
    void* min;                  \
    unsigned int nelts;         \
  } timer_heap;                 \ uv_timer_t 还会被插入到 loop->timer_heap 堆（最小堆）中，堆节点为 handle->heap_node。
  uint64_t timer_counter;       \
  uint64_t time;                \
  int signal_pipefd[2];         \
  uv__io_t signal_io_watcher;   \
  uv_signal_t child_watcher;    \
  int emfile_fd;                \
  UV_PLATFORM_LOOP_FIELDS       \

#define UV_REQ_TYPE_PRIVATE /* empty */

#define UV_REQ_PRIVATE_FIELDS  /* empty */

#define UV_PRIVATE_REQ_TYPES /* empty */

#define UV_WRITE_PRIVATE_FIELDS                                               \
  void* queue[2];                                                             \
  unsigned int write_index;                                                   \
  uv_buf_t* bufs;                                                             \
  unsigned int nbufs;                                                         \
  int error;                                                                  \
  uv_buf_t bufsml[4];                                                         \

#define UV_CONNECT_PRIVATE_FIELDS                                             \
  void* queue[2];                                                             \

#define UV_SHUTDOWN_PRIVATE_FIELDS /* empty */

#define UV_UDP_SEND_PRIVATE_FIELDS                                            \
  void* queue[2];                                                             \
  struct sockaddr_storage addr;                                               \
  unsigned int nbufs;                                                         \
  uv_buf_t* bufs;                                                             \
  ssize_t status;                                                             \
  uv_udp_send_cb send_cb;                                                     \
  uv_buf_t bufsml[4];                                                         \

#define UV_HANDLE_PRIVATE_FIELDS                                              \
  uv_handle_t* next_closing;                                                  \
  unsigned int flags;                                                         \

#define UV_STREAM_PRIVATE_FIELDS                                              \
  uv_connect_t *connect_req;                                                  \
  uv_shutdown_t *shutdown_req;                                                \
  uv__io_t io_watcher;                                                        \
  void* write_queue[2];                                                       \
  void* write_completed_queue[2];                                             \
  uv_connection_cb connection_cb;                                             \
  int delayed_error;                                                          \
  int accepted_fd;                                                            \
  void* queued_fds;                                                           \
  UV_STREAM_PRIVATE_PLATFORM_FIELDS                                           \

#define UV_TCP_PRIVATE_FIELDS /* empty */

#define UV_UDP_PRIVATE_FIELDS                                                 \
  uv_alloc_cb alloc_cb;                                                       \
  uv_udp_recv_cb recv_cb;                                                     \
  uv__io_t io_watcher;                                                        \
  void* write_queue[2];                                                       \
  void* write_completed_queue[2];                                             \

#define UV_PIPE_PRIVATE_FIELDS                                                \
  const char* pipe_fname; /* strdup'ed */

#define UV_POLL_PRIVATE_FIELDS                                                \
  uv__io_t io_watcher;

#define UV_PREPARE_PRIVATE_FIELDS                                             \
  uv_prepare_cb prepare_cb;                                                   \
  void* queue[2];                                                             \

#define UV_CHECK_PRIVATE_FIELDS                                               \
  uv_check_cb check_cb;                                                       \
  void* queue[2];                                                             \

#define UV_IDLE_PRIVATE_FIELDS                                                \
  uv_idle_cb idle_cb;                                                         \
  void* queue[2];                                                             \

#define UV_ASYNC_PRIVATE_FIELDS                                               \
  uv_async_cb async_cb;                                                       \
  void* queue[2];                                                             \
  int pending;                                                                \

#define UV_TIMER_PRIVATE_FIELDS                                               \
  uv_timer_cb timer_cb;                                                       \
  void* heap_node[3];                                                         \
  uint64_t timeout;                                                           \
  uint64_t repeat;                                                            \
  uint64_t start_id;

#define UV_GETADDRINFO_PRIVATE_FIELDS                                         \
  struct uv__work work_req;                                                   \
  uv_getaddrinfo_cb cb;                                                       \
  struct addrinfo* hints;                                                     \
  char* hostname;                                                             \
  char* service;                                                              \
  struct addrinfo* addrinfo;                                                  \
  int retcode;

#define UV_GETNAMEINFO_PRIVATE_FIELDS                                         \
  struct uv__work work_req;                                                   \
  uv_getnameinfo_cb getnameinfo_cb;                                           \
  struct sockaddr_storage storage;                                            \
  int flags;                                                                  \
  char host[NI_MAXHOST];                                                      \
  char service[NI_MAXSERV];                                                   \
  int retcode;

#define UV_PROCESS_PRIVATE_FIELDS                                             \
  void* queue[2];                                                             \
  int status;                                                                 \

#define UV_FS_PRIVATE_FIELDS                                                  \
  const char *new_path;                                                       \
  uv_file file;                                                               \
  int flags;                                                                  \
  mode_t mode;                                                                \
  unsigned int nbufs;                                                         \
  uv_buf_t* bufs;                                                             \
  off_t off;                                                                  \
  uv_uid_t uid;                                                               \
  uv_gid_t gid;                                                               \
  double atime;                                                               \
  double mtime;                                                               \
  struct uv__work work_req;                                                   \
  uv_buf_t bufsml[4];                                                         \

#define UV_WORK_PRIVATE_FIELDS                                                \
  struct uv__work work_req;

#define UV_TTY_PRIVATE_FIELDS                                                 \
  struct termios orig_termios;                                                \
  int mode;

#define UV_SIGNAL_PRIVATE_FIELDS                                              \
  /* RB_ENTRY(uv_signal_s) tree_entry; */                                     \
  struct {                                                                    \
    struct uv_signal_s* rbe_left;                                             \
    struct uv_signal_s* rbe_right;                                            \
    struct uv_signal_s* rbe_parent;                                           \
    int rbe_color;                                                            \
  } tree_entry;                                                               \
  /* Use two counters here so we don have to fiddle with atomics. */          \
  unsigned int caught_signals;                                                \
  unsigned int dispatched_signals;

#define UV_FS_EVENT_PRIVATE_FIELDS                                            \
  uv_fs_event_cb cb;                                                          \
  UV_PLATFORM_FS_EVENT_FIELDS                                                 \

/* fs open() flags supported on this platform: */
#if defined(O_APPEND)
# define UV_FS_O_APPEND       O_APPEND
#else
# define UV_FS_O_APPEND       0
#endif
#if defined(O_CREAT)
# define UV_FS_O_CREAT        O_CREAT
#else
# define UV_FS_O_CREAT        0
#endif
#if defined(O_DIRECT)
# define UV_FS_O_DIRECT       O_DIRECT
#else
# define UV_FS_O_DIRECT       0
#endif
#if defined(O_DIRECTORY)
# define UV_FS_O_DIRECTORY    O_DIRECTORY
#else
# define UV_FS_O_DIRECTORY    0
#endif
#if defined(O_DSYNC)
# define UV_FS_O_DSYNC        O_DSYNC
#else
# define UV_FS_O_DSYNC        0
#endif
#if defined(O_EXCL)
# define UV_FS_O_EXCL         O_EXCL
#else
# define UV_FS_O_EXCL         0
#endif
#if defined(O_EXLOCK)
# define UV_FS_O_EXLOCK       O_EXLOCK
#else
# define UV_FS_O_EXLOCK       0
#endif
#if defined(O_NOATIME)
# define UV_FS_O_NOATIME      O_NOATIME
#else
# define UV_FS_O_NOATIME      0
#endif
#if defined(O_NOCTTY)
# define UV_FS_O_NOCTTY       O_NOCTTY
#else
# define UV_FS_O_NOCTTY       0
#endif
#if defined(O_NOFOLLOW)
# define UV_FS_O_NOFOLLOW     O_NOFOLLOW
#else
# define UV_FS_O_NOFOLLOW     0
#endif
#if defined(O_NONBLOCK)
# define UV_FS_O_NONBLOCK     O_NONBLOCK
#else
# define UV_FS_O_NONBLOCK     0
#endif
#if defined(O_RDONLY)
# define UV_FS_O_RDONLY       O_RDONLY
#else
# define UV_FS_O_RDONLY       0
#endif
#if defined(O_RDWR)
# define UV_FS_O_RDWR         O_RDWR
#else
# define UV_FS_O_RDWR         0
#endif
#if defined(O_SYMLINK)
# define UV_FS_O_SYMLINK      O_SYMLINK
#else
# define UV_FS_O_SYMLINK      0
#endif
#if defined(O_SYNC)
# define UV_FS_O_SYNC         O_SYNC
#else
# define UV_FS_O_SYNC         0
#endif
#if defined(O_TRUNC)
# define UV_FS_O_TRUNC        O_TRUNC
#else
# define UV_FS_O_TRUNC        0
#endif
#if defined(O_WRONLY)
# define UV_FS_O_WRONLY       O_WRONLY
#else
# define UV_FS_O_WRONLY       0
#endif

/* fs open() flags supported on other platforms: */
#define UV_FS_O_RANDOM        0
#define UV_FS_O_SHORT_LIVED   0
#define UV_FS_O_SEQUENTIAL    0
#define UV_FS_O_TEMPORARY     0

#endif /* UV_UNIX_H */
