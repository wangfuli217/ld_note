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

#include "uv.h"
#include "uv-common.h"
#include "heap-inl.h"

#include <assert.h>
#include <limits.h>

// 取出loop中的计时器堆指针
static struct heap *timer_heap(const uv_loop_t* loop) {
#ifdef _WIN32
  return (struct heap*) loop->timer_heap;
#else
  return (struct heap*) &loop->timer_heap;
#endif
}


static int timer_less_than(const struct heap_node* ha,
                           const struct heap_node* hb) {
  const uv_timer_t* a;
  const uv_timer_t* b;
  // 通过结构体成员找到结构体首地址
  a = container_of(ha, uv_timer_t, heap_node);
  b = container_of(hb, uv_timer_t, heap_node);
  // 比较两个结构体中的超时时间
  if (a->timeout < b->timeout)
    return 1;
  if (b->timeout < a->timeout)
    return 0;

  /* Compare start_id when both have the same timeout. start_id is
   * allocated with loop->timer_counter in uv_timer_start().
   */
  // 超时时间一样的话，看谁先创建
  if (a->start_id < b->start_id)
    return 1;
  if (b->start_id < a->start_id)
    return 0;

  return 0;
}

// 初始化uv_timer_t结构体
// uv_timer_t 的初始化函数 uv_timer_init，它直接引用了 uv__handle_init 初始化 uv_handle_t，其他派生类型也是如此。
int uv_timer_init(uv_loop_t* loop, uv_timer_t* handle) {
  uv__handle_init(loop, (uv_handle_t*)handle, UV_TIMER);
  handle->timer_cb = NULL;
  handle->repeat = 0;
  return 0;
}

// 启动一个计时器
int uv_timer_start(uv_timer_t* handle,
                   uv_timer_cb cb,
                   uint64_t timeout,
                   uint64_t repeat) {
  uint64_t clamped_timeout;

  if (cb == NULL)
    return UV_EINVAL;
  // 重新执行start的时候先把之前的停掉
  if (uv__is_active(handle))
    uv_timer_stop(handle);
  // 超时时间，为绝对值
  clamped_timeout = handle->loop->time + timeout;
  if (clamped_timeout < timeout)
    clamped_timeout = (uint64_t) -1;
  // 初始化回调，超时时间，是否重复计时，赋予一个独立无二的id
  handle->timer_cb = cb;
  handle->timeout = clamped_timeout;
  handle->repeat = repeat;
  /* start_id is the second index to be compared in uv__timer_cmp() */
  handle->start_id = handle->loop->timer_counter++;
  // 插入最小堆
  heap_insert(timer_heap(handle->loop),
              (struct heap_node*) &handle->heap_node,
              timer_less_than);
  // 激活该handle
  uv__handle_start(handle);

  return 0;
}

// 停止一个计时器
int uv_timer_stop(uv_timer_t* handle) {
  if (!uv__is_active(handle))
    return 0;
  // 从最小堆中移除该计时器节点
  heap_remove(timer_heap(handle->loop),
              (struct heap_node*) &handle->heap_node,
              timer_less_than);
  // 清除激活状态和handle的active数减一
  uv__handle_stop(handle);

  return 0;
}

// 重新启动一个计时器，需要设置repeat标记 
int uv_timer_again(uv_timer_t* handle) {
  if (handle->timer_cb == NULL)
    return UV_EINVAL;
  // 如果设置了repeat标记说明计时器是需要重复触发的
  if (handle->repeat) {
    // 先把旧的计时器节点从最小堆中移除，然后再重新开启一个计时器
    uv_timer_stop(handle);
    uv_timer_start(handle, handle->timer_cb, handle->repeat, handle->repeat);
  }

  return 0;
}


void uv_timer_set_repeat(uv_timer_t* handle, uint64_t repeat) {
  handle->repeat = repeat;
}


uint64_t uv_timer_get_repeat(const uv_timer_t* handle) {
  return handle->repeat;
}

// 计算最小堆中最小节点的超时时间，即最小的超时时间
// uv__next_timeout 有两种 情况：
//    堆为空，返回 -1
//    堆非空，返回 堆顶定时器 和 当前时间的差值，但是差值不能越界。
// 综合在一起，uv_backend_timeout 有可能返回 -1 0 正整数。
int uv__next_timeout(const uv_loop_t* loop) {
  const struct heap_node* heap_node;
  const uv_timer_t* handle;
  uint64_t diff;
  // 取出堆的根节点，即超时时间最小的
  heap_node = heap_min(timer_heap(loop));
  if (heap_node == NULL)
    return -1; /* block indefinitely */
  
  handle = container_of(heap_node, uv_timer_t, heap_node);
  // 如果最小的超时时间小于当前时间，则返回0，说明已经超时
  if (handle->timeout <= loop->time)
    return 0;
  // 否则计算还有多久超时，返回给epoll，epoll的timeout不能大于diff
  diff = handle->timeout - loop->time;
  if (diff > INT_MAX)
    diff = INT_MAX;

  return diff;
}

// 找出已经超时的节点，并且执行里面的回调
/*
    在 libuv 中，timer是按超时时间 timeout 存放在最小堆中的，这样，最小的的堆顶就是 timeout 
最小的那个 timer，也就是最先到达超时时间的那个定时任务。

所以，在检查到期的定时任务时，只需要不断的获取堆顶的元素，并与当前时间比对：
    如果没有堆顶元素，则没有任何定时器存在，函数将直接返回。
    如果当前时间小于定时任务的超时间，那么堆顶timer未到到超时时间，非堆顶的timer更没有达到超时时间，
整个uv__run_timers也就会退出。
    如果当前时间等于或大于定时任务的超时间，这个timer就是一定达到或超过执行时间的。
这时，就可以从timer堆中将其取出，然后调用其回调函数handle->timer_cb(handle)处理定时任务，
然后再次重复获取下一个出现在堆顶的timer，直到情况1或2成立。

以下有两个主要注意的点：
    大于或等于实际上包含两种情形，这两种情形对于实际应用程序逻辑来说可能会出现天壤之别。
        如果当前时间等于定时任务的超时间，就是最理想的状态了，因为定时任务会在定时器到来的时候准时被执行，与预期相符合。
        如果当前时间大于定时任务的超时间，则是非理想的状态了，然而这种情形缺是最出现的，因为很难保证当timer
的超时时间到来时，程序搞好执行到此。
    如果定时任务的回调函数handle->timer_cb执行时间过长，将会导致整个循环阻塞在此处，从而影响其他定时器的处理，
进而也影响到整个时间循环的其他逻辑的处理，因为只有一个线程在处理各类型的回调任务。
*/
void uv__run_timers(uv_loop_t* loop) {
  struct heap_node* heap_node;
  uv_timer_t* handle;

  for (;;) {
    heap_node = heap_min(timer_heap(loop));
    if (heap_node == NULL)
      break;

    handle = container_of(heap_node, uv_timer_t, heap_node);
    // 如果当前节点的时间大于当前时间则返回，说明后面的节点也没有超时
    if (handle->timeout > loop->time)
      break;
    // 移除该计时器节点，重新插入最小堆，如果设置了repeat的话
    uv_timer_stop(handle);
    uv_timer_again(handle);
    // 执行超时回调
    handle->timer_cb(handle);
  }
}


void uv__timer_close(uv_timer_t* handle) {
  uv_timer_stop(handle);
}
