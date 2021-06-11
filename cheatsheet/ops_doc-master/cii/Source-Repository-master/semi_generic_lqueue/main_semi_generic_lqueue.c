#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"semi_generic_lqueue.h"
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

typedef struct{
	int n;
	char c;
	char arr[10];
}S;

int myEqual(void*x,void* y){
	return ((S*)x)->n==((S*)y)->n&&((S*)x)->c==((S*)y)->c&&!strcmp(((S*)x)->arr,((S*)y)->arr);
}
int myFree(PtNode_t node){
	free(node);
	return 0;
}

int myShow(PtNode_t node){
	int i;
	printf ("____%d__%c__%s___\n",(((S*)(node->dataAddr))->n),(((S*)(node->dataAddr))->c), (((S*)(node->dataAddr))->arr));
	return 0;
}

int main(int argc, const char *argv[])
{
	int i=0;
	S s1={1,'a',"123"};
	S s2={2,'d',"456"};
	S s3={3,'h',"780"};
	S s4={4,'w',"fge"};
	S s5={5,'j',"wedc"};
	S s6={6,'q',"vre"};
	PtLQu_t Q=create_lqueue(sizeof(S),myFree,myShow);
	in_lqueue(Q,&s1);
	in_lqueue(Q,&s2);
	in_lqueue(Q,&s3);
	in_lqueue(Q,&s4);

	in_lqueue(Q,&s2);
	in_lqueue(Q,&s3);
	in_lqueue(Q,&s4);
	in_lqueue(Q,&s5);
	in_lqueue(Q,&s6);
	show_lqueue(Q);
	putchar(10);

	puts("------------is_empty_lqueue----------------");
	printf("%d\n",is_empty_lqueue(Q));
	puts("------------out_lqueue----------------");
	S tmp;
	out_lqueue(Q,&tmp);
	out_lqueue(Q,&tmp);
	out_lqueue(Q,&tmp);
	show_lqueue(Q);
	putchar(10);

	puts("--------------save_lqueue_to_file-----------------");
	save_lqueue_to_file(Q,"./database");
	show_lqueue(Q);
	printf("sizeof data:%d\n",sizeof(S));
	puts("--------------destroy_lqueue-----------------");
#if 0
	destroy_lqueue(Q);
	show_lqueue(Q);
#endif 
	puts("--------------load_lqueue_from_file-----------------");
	S* stmp=(S*)malloc(sizeof(stmp));
	load_lqueue_from_file(Q,"./database");
	show_lqueue(Q);
	return 0;
}
















