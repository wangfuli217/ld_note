#ifndef __CIRC_QUEUE_H_
#define __CIRC_QUEUE_H_

#ifdef __cplusplus
extern "C" {
#endif

typedef struct queue_node_s queue_node_t;
struct queue_node_s {
	void* data; 
};

typedef struct queue_root_s queue_root_t;
struct queue_root_s {
	queue_node_t *head;
	queue_node_t *tail;
	queue_node_t *queues; 	// 数据队列
	unsigned int nums;		// 队列容量
};

extern int
queue_init(queue_root_t* r, unsigned int nums);

extern int
queue_push(queue_root_t* r, void* d);

extern queue_node_t*
queue_pop(queue_root_t* r);

extern unsigned int
queue_count(queue_root_t* r);

#ifdef __cplusplus 
}
#endif

#endif

