#include "typedef.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "debug.h"
#include "semi_generic_lqueue.h"

/* Initialize a linked queue */
PtLQu_t create_lqueue(int dataSize,UdFreeNode_t free_node,UdShowNode_t show_node){
	PtLQu_t Q=(PtLQu_t)malloc(sizeof(LQu_t));
	if(NULL==Q){
		deprint("malloc error\n");
		return NULL;
	}
	Q->head=(PtNode_t)malloc(sizeof(Node_t));
	if(NULL==Q){
		deprint("malloc error\n");
		return NULL;
	}
	Q->head->next=NULL;
	Q->dataSize=dataSize;
	Q->free_node=free_node;
	Q->show_node=show_node;
	return Q;
}
/* Return true if Q is empty */
int is_empty_lqueue(PtLQu_t Q){
	return NULL==Q->head->next;
}
/* Output a node in the queue, 
 * the space pointed by dataAddr must be enough to contain data*/
int out_lqueue(PtLQu_t Q,DataAddr_t dataAddr){
	if(is_empty_lqueue(Q)){
		deprint("queue is empty\n");
		return -1;
	}
	PtNode_t tmp=Q->head->next;
	Q->head->next=Q->head->next->next;
	memcpy(dataAddr,tmp->dataAddr,Q->dataSize);
	Q->free_node(tmp);
	return 0;
}

/* Return the address of the node at tail */
static PtNode_t find_tail_lqueue(PtLQu_t Q){
	PtNode_t tmp=Q->head;
	while(tmp){
		if(NULL==tmp->next){
			return tmp;
		}
		tmp=tmp->next;
	}
	return NULL;	//没找到
}

/* Insert a node at the tail */
int in_lqueue(PtLQu_t Q,DataAddr_t dataAddr){
	PtNode_t tmp=(PtNode_t)malloc(sizeof(Node_t));
	if(NULL==tmp){
		deprint("malloc error\n");
		return -1;
	}
	tmp->dataAddr=(DataAddr_t)malloc(Q->dataSize);
	if(NULL==dataAddr){
		deprint("malloc error\n");
		return -1;
	}
	memcpy(tmp->dataAddr,dataAddr,Q->dataSize);
	PtNode_t tail=find_tail_lqueue(Q);

	/* Relink */
	tmp->next=NULL;
	tail->next=tmp;
	return 0;
}
/* Show data in Q */
int show_lqueue(PtLQu_t Q){
	if(is_empty_lqueue(Q)){
		deprint("queue is empty\n");
		return -1;
	}
	PtNode_t tmp=Q->head->next;
	while(tmp){
		Q->show_node(tmp);
		tmp=tmp->next;
	}
	return 0;
}

/* Destroy Q */
int destroy_lqueue(PtLQu_t Q){
	if(is_empty_lqueue(Q)){
		deprint("queue is empty\n");
		return -1;
	}
	PtNode_t tmp=NULL;
	while(Q->head->next){
		tmp=Q->head->next;
		Q->head->next=Q->head->next->next;
		Q->free_node(tmp);
	}
	return 0;
}
/* Save Q to file */
int save_lqueue_to_file(PtLQu_t Q,const char* filepath){

	int fd=open(filepath,O_WRONLY|O_CREAT|O_TRUNC,0666);
	if(is_empty_lqueue(Q)){
		deprint("queue is empty\n");
		return -1;
	}
	DataAddr_t tmp=(DataAddr_t)malloc(Q->dataSize);
	if(NULL==tmp){
		deprint("malloc error\n");
		return -2;
	}
	while(!is_empty_lqueue(Q)){
		out_lqueue(Q,tmp);
		write(fd,tmp,Q->dataSize);
	}
	destroy_lqueue(Q);
	close(fd);
	Q->free_node(tmp);
	tmp=NULL;
	return 0;
}

/* Load Q from file */
int load_lqueue_from_file(PtLQu_t Q,const char* filepath){
	int fd=open(filepath,O_RDONLY|O_CREAT,0666);
	DataAddr_t tmpData=(DataAddr_t)malloc(Q->dataSize);
	if(NULL==tmpData){
		deprint("malloc error\n");
		return -1;
	}
	while(0<read(fd,tmpData,Q->dataSize)){
		in_lqueue(Q,tmpData);
	}
	free(tmpData);
	tmpData=NULL;
	ftruncate(fd,0);
	close(fd);
	return 0;
}

