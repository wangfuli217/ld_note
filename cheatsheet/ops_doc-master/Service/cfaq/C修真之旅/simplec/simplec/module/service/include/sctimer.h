﻿#ifndef _H_TIMER_SIMPLC
#define _H_TIMER_SIMPLC

#include "list.h"
#include "sctime.h"

//
// timer_del - 删除定时器事件
// id       : 定时器 id
// return   : void
//
extern void timer_del(int id);

//
// timer_add - 添加定时器事件
// tvl      : 执行间隔(毫秒), <= 0 表示立即执行
// ftimer   : 定时器行为
// arg      : 定时器参数
// return   : 返回定时器 id
//
#define timer_add(tvl, ftimer, arg)                         \
timer_add_(tvl, (node_f)ftimer, (void *)(intptr_t)arg)
extern int timer_add_(int tvl, node_f ftimer, void * arg);

#endif//_H_TIMER_SIMPLC
