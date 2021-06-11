#ifndef __TYPEDEF_H__
#define __TYPEDEF_H__

/* Define the address of data */
typedef void* DataAddr_t;

/* Encapsulate node */
struct Node;
typedef struct Node* PtNode_t;
//struct Node_t;
typedef struct Node{
	DataAddr_t dataAddr;
	PtNode_t next;
}Node_t;

/* User-defined fucntions */
/* User-defined Node-Compare function */
typedef int (*UdCmp_t)(DataAddr_t,DataAddr_t);
/* User-defined Node-Free function */
typedef int (*UdFreeNode_t)(PtNode_t);
/* User-defined Node-Show function */
typedef int (*UdShowNode_t)(PtNode_t);

/* Encapsulate a linked queue */
typedef struct lqueue{
	PtNode_t head;
	int dataSize;
	UdFreeNode_t free_node;
	UdShowNode_t show_node;
}LQu_t,*PtLQu_t;

#endif 	//__TYPEDEF_H__
