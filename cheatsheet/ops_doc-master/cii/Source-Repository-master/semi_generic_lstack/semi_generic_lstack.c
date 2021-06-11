#include "typedef.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semi_generic_lstack.h"
#include "debug.h"
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

/* Initialize a linked stack */
PtLStack_t create_lstack(int dataSize,UdFreeNode_t free_node,UdShowNode_t show_node){
	PtLStack_t S=(PtLStack_t)malloc(sizeof(LStack_t));
	if(NULL==S){
		debug("malloc error\n");
		return NULL;
	}
	S->head=(PtNode_t)malloc(sizeof(Node_t));
	if(NULL==S){
		debug("malloc error\n");
		return NULL;
	}
	S->head->next=NULL;
	S->dataSize=dataSize;
	S->free_node=free_node;
	S->show_node=show_node;
}
/* Return true if S is empty */
int is_empty_lstack(PtLStack_t S){
	return NULL==S->head->next;
}

/* push a node to stack */
int push_lstack(PtLStack_t S,DataAddr_t dataAddr){

	/* Encapsulate a node */
	PtNode_t tmp=(PtNode_t)malloc(sizeof(Node_t));
	if(NULL==tmp){
		debug("malloc error\n");
		return -1;
	}
	tmp->dataAddr=(DataAddr_t)malloc(S->dataSize);	
	if(NULL==tmp->dataAddr){
		debug("malloc error\n");
		return -1;
	}
	memcpy(tmp->dataAddr,dataAddr,S->dataSize);

	/* Relink */
	tmp->next=S->head->next;
	S->head->next=tmp;
	return 0;
}

/* Delete the node at the head, 
 * the space pointed by dataAddr must be enough to contain data*/
int pop_lstack(PtLStack_t S,DataAddr_t dataAddr){
	if(is_empty_lstack(S)){
		debug("stack is empty\n");
		return -1;
	}
	PtNode_t tmp=S->head->next;
	S->head->next=S->head->next->next;
	memcpy(dataAddr,tmp->dataAddr,S->dataSize);
	S->free_node(tmp);
	return 0;
}


/* Show data in S */
int show_lstack(PtLStack_t S){
	if(is_empty_lstack(S)){
		debug("stack is empty\n");
		return -1;
	}
	PtNode_t tmp=S->head->next;
	while(tmp){
		S->show_node(tmp);
		tmp=tmp->next;
	}
	return 0;
}

/* Destroy S */
int destroy_lstack(PtLStack_t S){
	if(is_empty_lstack(S)){
		debug("stack is empty\n");
		return -1;
	}
	PtNode_t tmp=NULL;
	while(S->head->next){
		tmp=S->head->next;
		S->head->next=S->head->next->next;
		S->free_node(tmp);
	}
	return 0;
}
/* Save S to file */
int save_lstack_to_file(PtLStack_t S,const char* filepath){

	int fd=open(filepath,O_WRONLY|O_CREAT|O_TRUNC,0666);
	if(is_empty_lstack(S)){
		debug("stack is empty\n");
		return -1;
	}
	DataAddr_t tmp=(DataAddr_t)malloc(S->dataSize);
	if(NULL==tmp){
		debug("malloc error\n");
		return -2;
	}
	while(!is_empty_lstack(S)){
		pop_lstack(S,tmp);
		write(fd,tmp,S->dataSize);
	}
	destroy_lstack(S);
	close(fd);
	free(tmp);
	tmp=NULL;
}

/* Return the address of the node at tail */
static PtNode_t find_tail_lstack(PtLStack_t S){
	PtNode_t tmp=S->head;
	while(tmp){
		if(NULL==tmp->next){
			return tmp;
		}
		tmp=tmp->next;
	}
	return NULL;	//没找到
}

/* Insert a node at the tail */
static int insert_tail_lstack(PtLStack_t S,DataAddr_t dataAddr){
	PtNode_t tmp=(PtNode_t)malloc(sizeof(Node_t));
	if(NULL==tmp){
		debug("malloc error\n");
		return -1;
	}
	tmp->dataAddr=(DataAddr_t)malloc(S->dataSize);
	if(NULL==dataAddr){
		debug("malloc error\n");
		return -1;
	}
	memcpy(tmp->dataAddr,dataAddr,S->dataSize);
	PtNode_t tail=find_tail_lstack(S);

	/* Relink */
	tmp->next=NULL;
	tail->next=tmp;
	return 0;
}

/* Soad S from file */
int load_lstack_from_file(PtLStack_t S,const char* filepath){
	int fd=open(filepath,O_RDONLY|O_CREAT,0666);
	DataAddr_t tmpData=(DataAddr_t)malloc(S->dataSize);
	if(NULL==tmpData){
		debug("malloc error\n");
		return -1;
	}
	int i=0;
	while(0<read(fd,tmpData,S->dataSize)){
		insert_tail_lstack(S,tmpData);
	}
	free(tmpData);
	tmpData=NULL;
	ftruncate(fd,0);
	close(fd);
}

