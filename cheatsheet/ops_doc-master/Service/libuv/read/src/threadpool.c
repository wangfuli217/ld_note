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
线程池在程序设计中是常用的提升并发计算能力、提升吞吐量的常用手段，在 libnv 也不例外，并且结合事件循环，实现了异步支持。
libuv 提供可用于执行用户代码的线程池，并且能够在任务完成时，向事件循环线程发送消息通知主线程完成收尾工作。
默认情况下，线程池的大小是 4，但是可以在启动阶段通过设置 UV_THREADPOOL_SIZE 环境变量进行修改，最大为 128
*/

/* 线程池在 libuv 内部用于完成所有文件系统操作（requests），也用于实现 getaddrinfo 
和 getnameinfo 等 DNS 相关的操作（requests）。搜索 uv_queue_work 可找到相关使用位置。
可以这些内部实现作为使用示例，在内部，并不通过 uv_queue_work 提交任务，而是直接调用
 uv__work_submit，因为它们都有各自不同的 uv__x_work 和 uv__x_done 实现。
 */
#include "uv-common.h"

#if !defined(_WIN32)
# include "unix/internal.h"
#endif

#include <stdlib.h>

#define MAX_THREADPOOL_SIZE 128

static uv_once_t once = UV_ONCE_INIT;
static uv_cond_t cond;
static uv_mutex_t mutex;
static unsigned int idle_threads;
static unsigned int slow_io_work_running;
static unsigned int nthreads;
static uv_thread_t* threads;
static uv_thread_t default_threads[4];
static QUEUE exit_message;
static QUEUE wq;
static QUEUE run_slow_work_message;
static QUEUE slow_io_pending_wq;

static unsigned int slow_work_thread_threshold(void) {
  return (nthreads + 1) / 2;
}

static void uv__cancelled(struct uv__work* w) {
  abort();
}


/* To avoid deadlock with uv_cancel() it's crucial that the worker
 * never holds the global mutex and the loop-local mutex at the same time.
 */
static void worker(void* arg) {
  struct uv__work* w;
  QUEUE* q;
  int is_slow_work;

  uv_sem_post((uv_sem_t*) arg);
  arg = NULL;
    /*
加锁 mutex 
因为只有一个线程能抢占锁，所以多个线程也只能一个接一个的进入循环 
因为整个线程池中线程创建过程中不会出现其他线程在其他位置抢占并锁定 mutex 的情形出现，
所以只有该位置会抢占加锁，而后很快释放锁，所以线程池中的线程之后短暂的阻塞在这里。 
工作线程需要不断的等待处理任务，所以需要进入死循环
    */
  uv_mutex_lock(&mutex);
  for (;;) {
    /* `mutex` should always be locked at this point. */

    /* Keep waiting while either no work is present or only slow I/O
       and we're at the threshold for that. */
    /*
条件满足时，没有任务需要处理，线程进入挂起等待状态，等待被唤醒。
    */
    while (
    // 任务队列为空
    QUEUE_EMPTY(&wq) ||
    // 任务队列非空，但是队列头部被标记为慢速IO任务，且该队列中只有run_slow_work_message一个数据节点 
    // 且正在处理的慢IO任务超过阈值（默认2） 该一个条件避免太多线程同时都在处理慢IO操作 
    // 达到阈值后空闲的线程不再接慢IO任务而是挂起，等待非慢IO操作任务 能有机会尽快得到处理 
    // 正在进行的慢IO任务完成后，阈值限制解除，可以接慢IO任务 
    // 最终，保证了最多只有 `(nthreads + 1) / 2` 个线程处理慢IO 
    // 区分了快车道和慢车道后，能有效避免慢车堵快车，提升性能
           (QUEUE_HEAD(&wq) == &run_slow_work_message &&
            QUEUE_NEXT(&run_slow_work_message) == &wq &&
            slow_io_work_running >= slow_work_thread_threshold())) {
// 进入休息区，注意某线程在执行 while 循环时该线程一定抢占了 mutex，不论是首次还是后续执行 
// 线程挂起，等待唤醒 
// uv_cond_wait 会使线程挂起等待cond上的信号，为防止多线程同时调用 uv_cond_wait，必须提前加锁 
// uv_cond_wait 在挂起前会释放 mutex，其他阻塞在 mutex 上的线程会在 mutex 释放时被唤醒，并在唤醒时重新抢占 mutex，即只能唤醒一个 
// 所以，阻塞在for循环外的多个线程中的某一个会重新抢占 mutex 执行到达此处挂起，又继续唤醒其他线程 
// 也可能唤醒 阻塞在 uv__work_submit -> post 函数提交任务的抢占锁的位置的线程（通常为主事件循环线程） 
// 挂起的线程都是空闲的线程，被唤醒后为非空闲的线程，所以需要更新空闲线程计数
      idle_threads += 1;
      // 阻塞，等待唤醒
      uv_cond_wait(&cond, &mutex);
      idle_threads -= 1;
      // 挂起的线程在被唤醒后，一定不满足再次进入循环的条件，会继续向下执行
    }
    // 进入工作区，一共有三个区间，前后两个区间都有锁，中间的区间执行用户代码无锁
    // 线程被唤醒，开始干活
    
    // 以下操作因线程被唤醒时会自动对mutex上锁
    // 所以以下解锁前的区域对共享变量的操作都是安全的
    // 锁定区间代码同一时段只能有一个线程在执行
    // 因并无耗时任务，所以不会影响性能
    
    // 获取任务
    q = QUEUE_HEAD(&wq);
    // 如果收到线程退出消息，跳出循环，线程声明周期结束
    // 在外部发送消息通知线程主动退出，也可在外部kill线程
    if (q == &exit_message) {
      uv_cond_signal(&cond);
      uv_mutex_unlock(&mutex);
      break;
    }
    
    // 将任务摘出来
    QUEUE_REMOVE(q);
    QUEUE_INIT(q);  /* Signal uv_cancel() that the work req is executing. */

    is_slow_work = 0;
    // 初始化慢IO操作标记为0，即非慢IO操作
    if (q == &run_slow_work_message) {
      // 该任务为慢IO任务
      // 通常情况下，while 的第二个条件成立才能进入此段代码
      // 此时 q 只是一个慢IO任务标记，真正的任务在 slow_io_pending_wq 中
      // 所以需要特殊处理，获取真正的任务 q
      
      // 如果当前运行的慢IO操作的线程数达到阈值（2个线程）
      // 则将这些操作插入到 wq 队列末尾，延迟处理
      // 避免多个线程同时处理慢IO
      // 临界状态：已经有达到阈值限制个数的线程进入工作区处理慢IO任务，但是还没执行更新慢IO线程计数器代码，
      //         后续被慢IO任务唤醒的线程线程可能因为慢IO线程计数器未更新而满足进入条件。
      //         但是，因为该区间锁定了 mutex，阻塞在 uv_cond_wait 处的代码无法抢占锁无法执行，也就是无法跳出 while 循环，
      //         到 mutex 释放时，被唤醒的线程能够抢占锁时，计数器已经被更新了，前面所说的进入条件不再满足了。
      //    所以，条件满足时不能动，能动了条件又不满足了，本质上，两次判断在同一段锁定区间，所以以下情形应该难以出现，难道还有其他情况？
      if (slow_io_work_running >= slow_work_thread_threshold()) {
        QUEUE_INSERT_TAIL(&wq, q);
        continue;
      }

      /* If we encountered a request to run slow I/O work but there is none
         to run, that means it's cancelled => Start over. */
      // 如果慢IO队列为空，可能任务被取消
      if (QUEUE_EMPTY(&slow_io_pending_wq))
        continue;
      // 处理慢IO任务
      is_slow_work = 1;
      // 正在处理慢IO任务的个数累加，用于其他线程判断慢IO任务个数是否达到阈值
      slow_io_work_running++;
      // 从慢IO队列中重新获取任务
      q = QUEUE_HEAD(&slow_io_pending_wq);
      QUEUE_REMOVE(q);
      QUEUE_INIT(q);

      /* If there is more slow I/O work, schedule it to be run as well. */
      // 如果还有更多的慢IO操作，则将这些任务插入到 wq 队列末尾，本次只能处理 q 这一个任务
      if (!QUEUE_EMPTY(&slow_io_pending_wq)) {
        QUEUE_INSERT_TAIL(&wq, &run_slow_work_message);
        // 如果有空闲线程，唤醒
        if (idle_threads > 0)
          uv_cond_signal(&cond);
      }
    }

    // 解锁 mutex
    uv_mutex_unlock(&mutex);
    // 只有以下两行不涉及竞态资源读写，不需要加锁，实际也不能锁
    // 慢IO任务还是非慢IO任务，指的是w->work
    w = QUEUE_DATA(q, struct uv__work, wq);
    w->work(w);

    // 因为 loop 在多线程中共享，所以访问 loop 需要加锁
    uv_mutex_lock(&w->loop->wq_mutex);
    w->work = NULL;  /* Signal uv_cancel() that the work req is done
                        executing. */
    // 执行完任务,插入到loop的wq队列,在uv__work_done的时候会执行该队列的节点
    QUEUE_INSERT_TAIL(&w->loop->wq, &w->wq);
    // 发送完成信号，唤醒事件询线程并处理
    uv_async_send(&w->loop->wq_async); // 向事件循环线程发送消息唤醒事件循环线程
    uv_mutex_unlock(&w->loop->wq_mutex);

    /* Lock `mutex` since that is expected at the start of the next
     * iteration. */
    uv_mutex_lock(&mutex);
    // 执行完满IO任务，记录正在执行的慢IO个数变量减1
    if (is_slow_work) {
      /* `slow_io_work_running` is protected by `mutex`. */
      slow_io_work_running--;
    }
  }
}

// 把任务插入队列等待线程处理
/*
在 post 中，慢IO任务被插入到 slow_io_pending_wq 队列中，如果 run_slow_work_message 
不在 wq 中，则需要将 run_slow_work_message 插入 wq 队列尾部，标识 slow_io_pending_wq 
中存在任务，当 run_slow_work_message 得到被处理机会时，处理慢任务队列中的任务。

在 uv_queue_work 中的 uv__work_submit 调用时，传递的是 UV__WORK_CPU 表示 CPU 密集型任务。

任务可能在任意一个线程中提交，通常是在事件循环线程中提交，但是也有可能在work线程中提交，
即，w->work 和 w->done 这两个函数中都有可能调用 uv__work_submit，这取决于实现。

至此，整个线程池的工作原理已经分析完成，整个工作流程大致可分为三个阶段：
    提交任务；
    work线程处理任务，完成后通知事件循环线程；
    事件循环线程收到通知后完成收尾工作。
*/
static void post(QUEUE* q, enum uv__work_kind kind) {
  uv_mutex_lock(&mutex);
  // 类型是慢IO
  if (kind == UV__WORK_SLOW_IO) {
    /* Insert into a separate queue. */
    // 插入慢IO对应的队列
    QUEUE_INSERT_TAIL(&slow_io_pending_wq, q);
    /*
      有慢IO任务的时候，需要给主队列wq插入一个消息节点run_slow_work_message,
      说明有慢IO任务，所以如果run_slow_work_message是空，说明还没有插入主队列。
      需要进行q = &run_slow_work_message;赋值，然后把run_slow_work_message插入
      主队列 
    */
    if (!QUEUE_EMPTY(&run_slow_work_message)) {
      /* Running slow I/O tasks is already scheduled => Nothing to do here.
         The worker that runs said other task will schedule this one as well. */
      uv_mutex_unlock(&mutex);
      return;
    }
    q = &run_slow_work_message;
  }
  // 把节点插入主队列，可能是慢IO消息节点或者一般任务
  QUEUE_INSERT_TAIL(&wq, q);
  // 有空闲线程则唤醒他
  if (idle_threads > 0)
    uv_cond_signal(&cond);
  uv_mutex_unlock(&mutex);
}


#ifndef _WIN32
UV_DESTRUCTOR(static void cleanup(void)) {
  unsigned int i;

  if (nthreads == 0)
    return;

  post(&exit_message, UV__WORK_CPU);

  for (i = 0; i < nthreads; i++)
    if (uv_thread_join(threads + i))
      abort();

  if (threads != default_threads)
    uv__free(threads);

  uv_mutex_destroy(&mutex);
  uv_cond_destroy(&cond);

  threads = NULL;
  nthreads = 0;
}
#endif

/*
初始化逻辑如下：
1.线程池中线程数量，并分配用于存储线程信息的内存空间；
2.初始化静态全局的 线程锁 和 线程条件变量；
3.初始化静态全局 uv__work 队列；
  3.1 wq 待执行的任务队列，未执行完毕，loop->wq 同为任务队列，但是保持的是执行完毕的任务；
  3.2 slow_io_pending_wq 慢IO延迟任务队列；
  3.3 run_slow_work_message 慢IO延迟任务队列代表，当存在慢IO延迟任务队列时，run_slow_work_message 被插入到 wq 中代替所有慢IO任务排队；
4. 创建一定数量的线程；
5. 等待所以线程创建完成。
在创建线程的时候，线程执行的函数是 worker，该函数负责在线程中处理 wq 上的任务。
*/
static void init_threads(void) {
  unsigned int i;
  const char* val;
  uv_sem_t sem;

  nthreads = ARRAY_SIZE(default_threads);
  val = getenv("UV_THREADPOOL_SIZE");
  if (val != NULL)
    nthreads = atoi(val);
  if (nthreads == 0)
    nthreads = 1;
  if (nthreads > MAX_THREADPOOL_SIZE)
    nthreads = MAX_THREADPOOL_SIZE;

  threads = default_threads;
  if (nthreads > ARRAY_SIZE(default_threads)) {
    threads = uv__malloc(nthreads * sizeof(threads[0]));
    if (threads == NULL) {
      nthreads = ARRAY_SIZE(default_threads);
      threads = default_threads;
    }
  }
  // 初始化条件变量
  if (uv_cond_init(&cond))
    abort();
  // 初始化互斥变量
  if (uv_mutex_init(&mutex))
    abort();

  // 初始化三个队列
  QUEUE_INIT(&wq);
  QUEUE_INIT(&slow_io_pending_wq);
  QUEUE_INIT(&run_slow_work_message);

  // 初始化信号量变量，值为0
  if (uv_sem_init(&sem, 0))
    abort();
  // 创建多个线程
  for (i = 0; i < nthreads; i++)
    if (uv_thread_create(threads + i, worker, &sem))
      abort();
  // 等待sem信号量为非0的时候减去一，为0则阻塞
  for (i = 0; i < nthreads; i++)
    uv_sem_wait(&sem);

  uv_sem_destroy(&sem);
}


#ifndef _WIN32
static void reset_once(void) {
  uv_once_t child_once = UV_ONCE_INIT;
  memcpy(&once, &child_once, sizeof(child_once));
}
#endif


static void init_once(void) {
#ifndef _WIN32
  /* Re-initialize the threadpool after fork.
   * Note that this discards the global mutex and condition as well
   * as the work queue.
   */
  if (pthread_atfork(NULL, NULL, &reset_once))
    abort();
#endif
  init_threads();
}

/*
初始化 uv_once(&once, init_once);
线程池全局的并且跨所有事件循环共享，当特定的函数使用线程池时(例如，调用 uv_queue_work())，
libuv 通过 init_threads 函数预分配和初始化一定数量的线程，初始化函数只会被调用一次，
这会带来一定的内存开销，但是可以提升运行时性能。
*/
void uv__work_submit(uv_loop_t* loop,
                     struct uv__work* w,
                     enum uv__work_kind kind,
                     void (*work)(struct uv__work* w),
                     void (*done)(struct uv__work* w, int status)) {
  // 保证已经初始化线程，并只执行一次
  uv_once(&once, init_once);
  w->loop = loop;
  w->work = work;
  w->done = done;
  post(&w->wq, kind);
}


static int uv__work_cancel(uv_loop_t* loop, uv_req_t* req, struct uv__work* w) {
  int cancelled;
  // 加锁，为了把节点移出队列
  uv_mutex_lock(&mutex);
  // 加锁，为了判断w->wq是否为空
  uv_mutex_lock(&w->loop->wq_mutex);
  // w在一个队列中并work不为空，则可取消
  cancelled = !QUEUE_EMPTY(&w->wq) && w->work != NULL;
  // 删除该节点
  if (cancelled)
    QUEUE_REMOVE(&w->wq);

  uv_mutex_unlock(&w->loop->wq_mutex);
  uv_mutex_unlock(&mutex);

  if (!cancelled)
    return UV_EBUSY;
  // 重置回调函数
  w->work = uv__cancelled;
 
  uv_mutex_lock(&loop->wq_mutex);
   // 插入loop的wq队列
  QUEUE_INSERT_TAIL(&loop->wq, &w->wq);
  // 通知主线程执行任务回调
  uv_async_send(&loop->wq_async);
  uv_mutex_unlock(&loop->wq_mutex);

  return 0;
}


void uv__work_done(uv_async_t* handle) {
  struct uv__work* w;
  uv_loop_t* loop;
  QUEUE* q;
  QUEUE wq;
  int err;

    // 取出所有已完成的work，因与其他线程共享此变量，所以需要同步，因此此处可能会导致事件循环线程短暂阻塞
  loop = container_of(handle, uv_loop_t, wq_async);

  uv_mutex_lock(&loop->wq_mutex);
  // 把loop->wq队列的节点全部移到wp变量中，wq的队列在线程处理函数work里进行设置
  QUEUE_MOVE(&loop->wq, &wq);
  uv_mutex_unlock(&loop->wq_mutex);
    // 遍历所有已完成的work，调用 w->done，done 函数由用户提供
  while (!QUEUE_EMPTY(&wq)) {
    q = QUEUE_HEAD(&wq);
    QUEUE_REMOVE(q);

    w = container_of(q, struct uv__work, wq);
    err = (w->work == uv__cancelled) ? UV_ECANCELED : 0;
    // 执行回调
    w->done(w, err);
  }
}

/*
最后通过调用 uv__work_submit 向线程池中提交任务，uv__work_submit 的两个实参 
uv__queue_work 和 uv__queue_done 分别对 work_cb 和 after_work_cb 进行简单的封装。
*/
static void uv__queue_work(struct uv__work* w) {
  uv_work_t* req = container_of(w, uv_work_t, work_req);

  req->work_cb(req);
}


static void uv__queue_done(struct uv__work* w, int err) {
  uv_work_t* req;

  req = container_of(w, uv_work_t, work_req);
  uv__req_unregister(req->loop, req);

  if (req->after_work_cb == NULL)
    return;

  req->after_work_cb(req, err);
}

// 任务提交
/*
uv_queue_work 初始化了一个 uv_work_t 类型的 request，work_cb 为线程池中线程执行的函数，
after_work_cb 为 work_cb 执行完成之后在事件循环线程中执行的函数，req->work_req 是队列节点。
最后通过 uv__work_submit 向线程池中提交任务。
*/
int uv_queue_work(uv_loop_t* loop,
                  uv_work_t* req,
                  uv_work_cb work_cb,
                  uv_after_work_cb after_work_cb) {
  if (work_cb == NULL)
    return UV_EINVAL;

  uv__req_init(loop, req, UV_WORK);
  req->loop = loop;
  req->work_cb = work_cb;
  req->after_work_cb = after_work_cb;
  uv__work_submit(loop,
                  &req->work_req,
                  UV__WORK_CPU,
                  uv__queue_work,
                  uv__queue_done);
  return 0;
}


int uv_cancel(uv_req_t* req) {
  struct uv__work* wreq;
  uv_loop_t* loop;

  switch (req->type) {
  case UV_FS:
    loop =  ((uv_fs_t*) req)->loop;
    wreq = &((uv_fs_t*) req)->work_req;
    break;
  case UV_GETADDRINFO:
    loop =  ((uv_getaddrinfo_t*) req)->loop;
    wreq = &((uv_getaddrinfo_t*) req)->work_req;
    break;
  case UV_GETNAMEINFO:
    loop = ((uv_getnameinfo_t*) req)->loop;
    wreq = &((uv_getnameinfo_t*) req)->work_req;
    break;
  case UV_WORK:
    loop =  ((uv_work_t*) req)->loop;
    wreq = &((uv_work_t*) req)->work_req;
    break;
  default:
    return UV_EINVAL;
  }

  return uv__work_cancel(loop, req, wreq);
}