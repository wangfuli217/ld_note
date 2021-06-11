#TAILQ
author: 714480119@qq.com

[TOC]
## 1.TAILQ是什么
TAILQ是`<sys/queue.h>`中定义的一种名为尾队列的数据结构.

此外, 它还包含了如下的数据结构:

- 单向列表(single-linked lists)
- 单向尾队列(single-linked tail queue)
- 列表(lists)

TAILQ是FreeBSD/linux内核对双向队列操作的一种抽象, 它由宏来实现, 抽象程度不亚于C++, 能实现操作队列所需的各种操作.

一个数据不为空的队列结构如图所示:
![](./images/tailq_structure.png)

## 2.TAILQ的定义
首先来看一下这个尾队中节点元素的定义

```c
#define TAILQ_ENTRY(type) \
struct { \
	struct type *tqe_next;	/* next element */ \
	struct type **tqe_prev;	/* address of previous next element */ \
}
```

例如, 我们需要一个int型的队列时, 可以这样定义一个节点:

```c
struct int_queue {
	int value;
	TAILQ_ENTRY(int_queue) entry;
}
```

此时列表的节点元素结构如图所示: 

![](./images/entry.png)

## 3.队列的操作

- 初始化 
- 增 
- 删 
- 遍历 

## 4.reference

[深入理解TAILQ队列](http://blog.csdn.net/hunanchenxingyu/article/details/8648794)

[sys/queue.h分析](http://blog.csdn.net/astrotycoon/article/details/42917367)

[尾队列测试](http://blog.csdn.net/freeelinux/article/details/52781542)