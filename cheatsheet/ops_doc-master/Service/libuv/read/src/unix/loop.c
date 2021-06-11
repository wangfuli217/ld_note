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
#include "uv/tree.h"
#include "internal.h"
#include "heap-inl.h"
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/*
���߳��еĳ�ʼ�������������̳߳س�ʼ���ģ��ⲿ�ֳ�ʼ����������ڽ��� work �߳���Ϣ�� AsyncHandle �ĳ�ʼ��������

*/
int uv_loop_init(uv_loop_t* loop) {
  void* saved_data;
  int err;

  // ��������
  saved_data = loop->data;
  memset(loop, 0, sizeof(*loop));
  loop->data = saved_data;
  
  // ��ʱ�� uv_timer_t ��أ���ʼ����ʱ����
  heap_init((struct heap*) &loop->timer_heap);
  // ��ʼ�����ڽ����̳߳������������Ķ���
  QUEUE_INIT(&loop->wq);
  // ��ʼ�� uv_idle_t ����
  QUEUE_INIT(&loop->idle_handles);
  // ��ʼ�� uv_async_t ����
  QUEUE_INIT(&loop->async_handles);
  // ��ʼ�� uv_check_t ����
  QUEUE_INIT(&loop->check_handles);
  // ��ʼ�� uv_prepare_t ����
  QUEUE_INIT(&loop->prepare_handles);
  // ��ʼ�� uv_handle_t ���У����Գ�ʼ����� handle ����ŵ��˶�����
  QUEUE_INIT(&loop->handle_queue);

  // ��ʼ�� ��Ծ�� handle �� request ����
  loop->active_handles = 0;
  loop->active_reqs.count = 0;
  // ��ʼ��ʼ��I/O�۲�������ֶ�
  // �ļ�����������
  loop->nfds = 0;
  // I/O�۲��������׵�ַָ��
  loop->watchers = NULL;
  // I/O�۲����������������� `loop->watchers` ʵ�ʳ���Ϊ��nwatchers + 2
  loop->nwatchers = 0;
  // ��ʼ�� �����I/O�۲��߶��У������I/O�۲��߻ᱻ����˶����ӳٴ���
  QUEUE_INIT(&loop->pending_queue);
  // ��ʼ�� I/O�۲��߶��У����г�ʼ�����I/O�۲��߶��ᱻ����˶���
  QUEUE_INIT(&loop->watcher_queue);

  // �رյ� handle ���У���������
  loop->closing_handles = NULL;
  // ��ʼ����ʱ�� loop->time
  uv__update_time(loop);
  
  // uv_async_t 
  // ��ʼ�� async_io_watcher������һ��I/O�۲��ߣ����� uv_async_t �����¼�ѭ��
  loop->async_io_watcher.fd = -1;
  // ����д���ݸ� async_io_watcher
  loop->async_wfd = -1;
  
  // uv_signal_t
  loop->signal_pipefd[0] = -1;
  loop->signal_pipefd[1] = -1;
  // epoll_create()
  loop->backend_fd = -1;
   // EMFILE �������
  loop->emfile_fd = -1;

  // ��ʱ��������
  loop->timer_counter = 0;
  // �¼�ѭ���رձ�ʶ
  loop->stop_flag = 0;

  // ƽ̨�ض���ʼ����UV_LOOP_PRIVATE_FIELDS
  err = uv__platform_loop_init(loop);
  if (err)
    return err;

  // uv_signal_t
  // ��ʼ�������ź�
  uv__signal_global_once_init();
  // uv_proccess_t
  // ��ʼ���ӽ����źŹ۲���
  err = uv_signal_init(loop, &loop->child_watcher);
  if (err)
    goto fail_signal_init;

  // ������loop->child_watcher
  uv__handle_unref(&loop->child_watcher);
  loop->child_watcher.flags |= UV_HANDLE_INTERNAL;
  // ��ʼ���ӽ��� handle ����
  QUEUE_INIT(&loop->process_handles);

  // ��ʼ���̶߳�д��
  err = uv_rwlock_init(&loop->cloexec_lock);
  if (err)
    goto fail_rwlock_init;
 
  // ��ʼ���̻߳�������
  err = uv_mutex_init(&loop->wq_mutex);
  if (err)
    goto fail_mutex_init;

  // ��ʼ��loop->wq_async�����ڽ�����������źţ���ע�ᴦ����
  err = uv_async_init(loop, &loop->wq_async, uv__work_done);
  if (err)
    goto fail_async_init;

  // ������
  uv__handle_unref(&loop->wq_async);
  loop->wq_async.flags |= UV_HANDLE_INTERNAL;

  return 0;

fail_async_init:
  uv_mutex_destroy(&loop->wq_mutex);

fail_mutex_init:
  uv_rwlock_destroy(&loop->cloexec_lock);

fail_rwlock_init:
  uv__signal_loop_cleanup(loop);

fail_signal_init:
  uv__platform_loop_delete(loop);

  return err;
}


int uv_loop_fork(uv_loop_t* loop) {
  int err;
  unsigned int i;
  uv__io_t* w;

  err = uv__io_fork(loop);
  if (err)
    return err;

  err = uv__async_fork(loop);
  if (err)
    return err;

  err = uv__signal_loop_fork(loop);
  if (err)
    return err;

  /* Rearm all the watchers that aren't re-queued by the above. */
  for (i = 0; i < loop->nwatchers; i++) {
    w = loop->watchers[i];
    if (w == NULL)
      continue;

    if (w->pevents != 0 && QUEUE_EMPTY(&w->watcher_queue)) {
      w->events = 0; /* Force re-registration in uv__io_poll. */
      QUEUE_INSERT_TAIL(&loop->watcher_queue, &w->watcher_queue);
    }
  }

  return 0;
}


void uv__loop_close(uv_loop_t* loop) {
  uv__signal_loop_cleanup(loop);
  uv__platform_loop_delete(loop);
  uv__async_stop(loop);

  if (loop->emfile_fd != -1) {
    uv__close(loop->emfile_fd);
    loop->emfile_fd = -1;
  }

  if (loop->backend_fd != -1) {
    uv__close(loop->backend_fd);
    loop->backend_fd = -1;
  }

  uv_mutex_lock(&loop->wq_mutex);
  assert(QUEUE_EMPTY(&loop->wq) && "thread pool work queue not empty!");
  assert(!uv__has_active_reqs(loop));
  uv_mutex_unlock(&loop->wq_mutex);
  uv_mutex_destroy(&loop->wq_mutex);

  /*
   * Note that all thread pool stuff is finished at this point and
   * it is safe to just destroy rw lock
   */
  uv_rwlock_destroy(&loop->cloexec_lock);

#if 0
  assert(QUEUE_EMPTY(&loop->pending_queue));
  assert(QUEUE_EMPTY(&loop->watcher_queue));
  assert(loop->nfds == 0);
#endif

  uv__free(loop->watchers);
  loop->watchers = NULL;
  loop->nwatchers = 0;
}


int uv__loop_configure(uv_loop_t* loop, uv_loop_option option, va_list ap) {
  if (option != UV_LOOP_BLOCK_SIGNAL)
    return UV_ENOSYS;

  if (va_arg(ap, int) != SIGPROF)
    return UV_EINVAL;

  loop->flags |= UV_LOOP_BLOCK_SIGPROF;
  return 0;
}
