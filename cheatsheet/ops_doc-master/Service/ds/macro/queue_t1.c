#include <stdio.h>
#include "queue.h"

struct handle_t {
	int val;
	QUEUE node;
};

void handle_init(struct handle_t* handle_p, int val);
void data(void);

static QUEUE* q;
static QUEUE queue;
static QUEUE queue1;
static QUEUE queue2;

int main() {
	struct handle_t* handle_p;
	/*QUEUE_INIT(q) 初始化链表*/
	QUEUE_INIT(&queue);
	QUEUE_INIT(&queue1);
	QUEUE_INIT(&queue2);

	struct handle_t handle1;
	handle1.val = 1;
	handle_init(&handle1, 1);

	struct handle_t handle2;
	handle_init(&handle2, 2);

	struct handle_t handle3;
	handle_init(&handle3, 3);

	struct handle_t handle4;
	handle_init(&handle4, 4);

	struct handle_t handle5;
	handle_init(&handle5, 5);

	struct handle_t handle6;
	handle_init(&handle6, 6);

	//从尾部插入节点
	QUEUE_INSERT_TAIL(&queue, &handle1.node);
	QUEUE_INSERT_TAIL(&queue, &handle2.node);
	QUEUE_INSERT_TAIL(&queue, &handle3.node);
	//从头部插入节点
	QUEUE_INSERT_HEAD(&queue1, &handle4.node);
	QUEUE_INSERT_HEAD(&queue1, &handle5.node);
	QUEUE_INSERT_HEAD(&queue1, &handle6.node);


	/*
 	*  QUEUE_ADD(h, n) 链接 h和n 两个链表
 	* */
	QUEUE_ADD(&queue, &queue1);

	/*   QUEUE_FOREACH(q, h)用于遍历队列 打印结果为：
 	*   这里q初始值为QUEUE_HEAD(h) 通过QUEUE_NEXT(q) 遍历链表直到（q）== (h)停止
 	*
 	*   通过QUEUE_DATA取到我们真正需要的数据结构，取到val值 具体实现会在后面分析，打印结果为
 	*
 	*   1
 	*   2
 	*   3
 	*   6
 	*   5
 	*   4
 	*
 	* */
	QUEUE_FOREACH(q, &queue) {
    	handle_p = QUEUE_DATA(q, struct handle_t, node);
    	printf("%d\n", handle_p->val);
	};
	printf("################\n");



	/* QUEUE_HEAD(h)的内部实现就是调用QUEUE_NEXT(h)
 	*
 	* */
	q = QUEUE_HEAD(&queue);
	/* REMOVE q 的操作 其实就是链接 q的prev和q的next:
 	*
 	*   QUEUE_PREV_NEXT(q) = QUEUE_NEXT(q);                                       \
     QUEUE_NEXT_PREV(q) = QUEUE_PREV(q);
 	*
 	* */
	QUEUE_REMOVE(q);
	/*
 	*  打印：
 	*  2
 	*  3
 	*  6
 	*  5
 	*  4
 	*
 	* */
	QUEUE_FOREACH(q, &queue) {
   	handle_p = QUEUE_DATA(q, struct handle_t, node);
    	printf("%d\n", handle_p->val);
	};
	printf("################\n");


	/*  QUEUE_MOVE(h, n) 内部通过QUEUE_SPLIT实现，将链表h 移动到 n
 	*
 	*  QUEUE_MOVE(&queue, &queue2); 等于下面QUEUE_SPLIT的写法
 	*  QUEUE_SPLIT(&queue, QUEUE_HEAD(&queue), &queue2);
 	*
 	* */
	//QUEUE_MOVE(&queue, &queue2);

	/*   QUEUE_SPLIT(h, q, n) 以q将链表h分割为 h 和 n两部分
 	*
 	* */
	QUEUE_SPLIT(&queue, &handle5.node, &queue2);


	/*
 	*  5
 	*  4
 	* */
	QUEUE_FOREACH(q, &queue2) {
    	handle_p = QUEUE_DATA(q, struct handle_t, node);
    	printf("%d\n", handle_p->val);
	};
	printf("################\n");

	/*
 	*  2
 	*  3
 	*  6
 	* */
	QUEUE_FOREACH(q, &queue) {
    	handle_p = QUEUE_DATA(q, struct handle_t, node);
    	printf("%d\n", handle_p->val);
	};
	printf("################\n");
    
    data();
	return 0;
}

void handle_init(struct handle_t* handle_p, int val) {
	handle_p->val = val;
	QUEUE_INIT(&handle_p->node);
}
void data(void){
	struct handle_t handle;

	handle.val = 1;
	QUEUE_INIT(&handle.node);
	/*
		QUEUE_DATA找到了 通过成员&handle.node 找到了结构体数据handle的地址
		并将其转为 handle_t*
	*/
	struct handle_t* handle_p = QUEUE_DATA(&handle.node, struct handle_t, node);
	
	//1
	printf("%d\n", handle_p->val);
}

头文件 tree.h