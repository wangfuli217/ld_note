/*
 * Copyright (c) 2007-2012 Niels Provos and Nick Mathewson
 *
 * Copyright (c) 2006 Maxim Yegorushkin <maxim.yegorushkin@gmail.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#ifndef MINHEAP_INTERNAL_H_INCLUDED_
#define MINHEAP_INTERNAL_H_INCLUDED_

#include "event2/event-config.h"
#include "evconfig-private.h"
#include "event2/event.h"
#include "event2/event_struct.h"
#include "event2/util.h"
#include "util-internal.h"
#include "mm-internal.h"

// min_heap，用来存放定时时间，它是一个最小堆构成的优先级队列，
// 这样能保证我们每次取得超时时间最小的事件，按顺序处理
typedef struct min_heap
{
    // 指向event*类型数组
    struct event** p;
    // n是元素个数，a表示堆的最大容量
    unsigned n, a;
} min_heap_t;

static inline void	     min_heap_ctor_(min_heap_t* s);
static inline void	     min_heap_dtor_(min_heap_t* s);
static inline void	     min_heap_elem_init_(struct event* e);
static inline int	     min_heap_elt_is_top_(const struct event *e);
static inline int	     min_heap_empty_(min_heap_t* s);
static inline unsigned	     min_heap_size_(min_heap_t* s);
static inline struct event*  min_heap_top_(min_heap_t* s);
static inline int	     min_heap_reserve_(min_heap_t* s, unsigned n);
static inline int	     min_heap_push_(min_heap_t* s, struct event* e);
static inline struct event*  min_heap_pop_(min_heap_t* s);
static inline int	     min_heap_adjust_(min_heap_t *s, struct event* e);
static inline int	     min_heap_erase_(min_heap_t* s, struct event* e);
static inline void	     min_heap_shift_up_(min_heap_t* s, unsigned hole_index, struct event* e);
static inline void	     min_heap_shift_up_unconditional_(min_heap_t* s, unsigned hole_index, struct event* e);
static inline void	     min_heap_shift_down_(min_heap_t* s, unsigned hole_index, struct event* e);

// 比较a、b event对应的绝对超时时间大小
#define min_heap_elem_greater(a, b) \
    (evutil_timercmp(&(a)->ev_timeout, &(b)->ev_timeout, >))

// 初始化超时时间优先级队列（最小堆）
void min_heap_ctor_(min_heap_t* s) { s->p = 0; s->n = 0; s->a = 0; }
void min_heap_dtor_(min_heap_t* s) { if (s->p) mm_free(s->p); }
void min_heap_elem_init_(struct event* e) { e->ev_timeout_pos.min_heap_idx = -1; }
int min_heap_empty_(min_heap_t* s) { return 0u == s->n; }
unsigned min_heap_size_(min_heap_t* s) { return s->n; }
// 返回最小堆的顶元素
struct event* min_heap_top_(min_heap_t* s) { return s->n ? *s->p : 0; }

// 把event插入最小堆
int min_heap_push_(min_heap_t* s, struct event* e)
{
    if (min_heap_reserve_(s, s->n + 1))
        return -1;
    // 注意这里，从n位置上浮，结束上浮即插入成功后个数n+1
    min_heap_shift_up_(s, s->n++, e);
    return 0;
}

// 删除并返回堆顶元素 event ，重新调整最小堆
struct event* min_heap_pop_(min_heap_t* s)
{
    if (s->n)
    {
        struct event* e = *s->p;
        // 将最小堆最后的堆元素放入到根结点的位置并进行下浮
        min_heap_shift_down_(s, 0u, s->p[--s->n]);
        e->ev_timeout_pos.min_heap_idx = -1;
        return e;
    }
    return 0;
}

// 判断该 event 是否位于堆顶
int min_heap_elt_is_top_(const struct event *e)
{
    return e->ev_timeout_pos.min_heap_idx == 0;
}

// 从最小堆中移除元素 e ,并用堆的最后一个元素进行替换和调整
int min_heap_erase_(min_heap_t* s, struct event* e)
{
    if (-1 != e->ev_timeout_pos.min_heap_idx)
    {
        struct event *last = s->p[--s->n];
        unsigned parent = (e->ev_timeout_pos.min_heap_idx - 1) / 2;
        /* we replace e with the last element in the heap.  We might need to
           shift it upward if it is less than its parent, or downward if it is
           greater than one or both its children. Since the children are known
           to be less than the parent, it can't need to shift both up and
           down. */
        /* 我们用堆中的最后一个元素替换e。 如果它小于其父级，我们可能需要将其向上移动，
         * 或者如果它大于其子级中的一个或两个，则向下移动它。
         * 由于已知孩子比父母少，所以不需要上下移动.*/
        if (e->ev_timeout_pos.min_heap_idx > 0 && min_heap_elem_greater(s->p[parent], last))
            min_heap_shift_up_unconditional_(s, e->ev_timeout_pos.min_heap_idx, last);
        else
            min_heap_shift_down_(s, e->ev_timeout_pos.min_heap_idx, last);
        e->ev_timeout_pos.min_heap_idx = -1;
        return 0;
    }
    return -1;
}

// 调整 e 在最小堆的位置，e可能是堆中原本的堆元素或不是堆元素
int min_heap_adjust_(min_heap_t *s, struct event *e)
{
    if (-1 == e->ev_timeout_pos.min_heap_idx) {
        // 如果 e 不是堆元素，则直接添加到堆中去
        return min_heap_push_(s, e);
    } else {
        // 否则就看 e 的情况，进行上浮或下浮操作
        unsigned parent = (e->ev_timeout_pos.min_heap_idx - 1) / 2;
        /* The position of e has changed; we shift it up or down
         * as needed.  We can't need to do both. */
        if (e->ev_timeout_pos.min_heap_idx > 0 && min_heap_elem_greater(s->p[parent], e))
            min_heap_shift_up_unconditional_(s, e->ev_timeout_pos.min_heap_idx, e);
        else
            min_heap_shift_down_(s, e->ev_timeout_pos.min_heap_idx, e);
        return 0;
    }
}

// 重新分配堆大小，确保堆中能容纳n个元素
int min_heap_reserve_(min_heap_t* s, unsigned n)
{
    // 如果容量不足，则分配空间
    if (s->a < n)
    {
        struct event** p;
        // 倍乘 或者 初始化为8
        unsigned a = s->a ? s->a * 2 : 8;
        if (a < n)
            a = n;
        if (!(p = (struct event**)mm_realloc(s->p, a * sizeof *p)))
            return -1;
        s->p = p;
        s->a = a;
    }
    return 0;
}

// 和min_heap_shift_up_类似，只是一次无条件上浮
void min_heap_shift_up_unconditional_(min_heap_t* s, unsigned hole_index, struct event* e)
{
    unsigned parent = (hole_index - 1) / 2;
    do
    {
        (s->p[hole_index] = s->p[parent])->ev_timeout_pos.min_heap_idx = hole_index;
        hole_index = parent;
        parent = (hole_index - 1) / 2;
    } while (hole_index && min_heap_elem_greater(s->p[parent], e));
    (s->p[hole_index] = e)->ev_timeout_pos.min_heap_idx = hole_index;
}

// 将元素 e 放到 hole_index 处开始上浮，直到找到合适位置插入 e
void min_heap_shift_up_(min_heap_t* s, unsigned hole_index, struct event* e)
{
    // 计算父节点下标
    unsigned parent = (hole_index - 1) / 2;
    // 父节点的时间大于要插入的 event，则需要调整父节点
    while (hole_index && min_heap_elem_greater(s->p[parent], e))
    {
        (s->p[hole_index] = s->p[parent])->ev_timeout_pos.min_heap_idx = hole_index;
        hole_index = parent;
        parent = (hole_index - 1) / 2;
    }
    // 插入 event
    (s->p[hole_index] = e)->ev_timeout_pos.min_heap_idx = hole_index;
}

// 将元素 e 放到 hole_index 处开始下沉，直到找到合适位置插入e
void min_heap_shift_down_(min_heap_t* s, unsigned hole_index, struct event* e)
{
    // 右孩子下标
    unsigned min_child = 2 * (hole_index + 1);
    while (min_child <= s->n)
    {
        // 找出最小的孩子下标：
        //   1. min_child == s->n (表示没有右孩子）则 min_child-1;
        //   2. 左孩子比右孩子小， min_child -1
        min_child -= min_child == s->n || min_heap_elem_greater(s->p[min_child], s->p[min_child - 1]);
        if (!(min_heap_elem_greater(e, s->p[min_child])))
            break;
        (s->p[hole_index] = s->p[min_child])->ev_timeout_pos.min_heap_idx = hole_index;
        hole_index = min_child;
        min_child = 2 * (hole_index + 1);
    }
    (s->p[hole_index] = e)->ev_timeout_pos.min_heap_idx = hole_index;
}

#endif /* MINHEAP_INTERNAL_H_INCLUDED_ */
