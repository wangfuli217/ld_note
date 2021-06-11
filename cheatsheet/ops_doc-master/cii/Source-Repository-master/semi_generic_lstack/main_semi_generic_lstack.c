#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"semi_generic_lstack.h"
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

typedef struct{
	int n;
	char c;
	char arr[10];
}info_t;

int myEqual(void*x,void* y){
	return ((info_t*)x)->n==((info_t*)y)->n&&((info_t*)x)->c==((info_t*)y)->c&&!strcmp(((info_t*)x)->arr,((info_t*)y)->arr);
}
int myFree(PtNode_t node){
	free(node);
	return 0;
}

int myShow(PtNode_t node){
	int i;
	printf ("____%d__%c__%s___\n",(((info_t*)(node->dataAddr))->n),(((info_t*)(node->dataAddr))->c), (((info_t*)(node->dataAddr))->arr));
	return 0;
}

int main(int argc, const char *argv[])
{
	int i=0;
	info_t s1={1,'a',"123"};
	info_t s2={2,'d',"456"};
	info_t s3={3,'h',"780"};
	info_t s4={4,'w',"fge"};
	info_t s5={5,'j',"wedc"};
	info_t s6={6,'q',"vre"};
	PtLStack_t S=create_lstack(sizeof(info_t),myFree,myShow);

	puts("-----------------push_lstack--------------");
	push_lstack(S,&s1);
	push_lstack(S,&s2);
	push_lstack(S,&s3);
	push_lstack(S,&s4);

	push_lstack(S,&s2);
	push_lstack(S,&s3);
	push_lstack(S,&s4);
	push_lstack(S,&s5);
	push_lstack(S,&s6);
	show_lstack(S);
	putchar(10);
	puts("-----------------is_empty_lstack--------------");
	printf("%d\n",is_empty_lstack(S));
	puts("-----------------pop_lstack--------------");
	info_t tmp;
	pop_lstack(S,&tmp);
	pop_lstack(S,&tmp);
	pop_lstack(S,&tmp);
	show_lstack(S);
	putchar(10);

	puts("--------------destroy_lstack-----------------");
#if 0
	destroy_lstack(S);
	show_lstack(S);
#endif
	puts("--------------save_lstack_to_file-----------------");
	save_lstack_to_file(S,"./database");
	show_lstack(S);
	printf("sizeof data:%d\n",sizeof(info_t));

	puts("--------------load_lstack_from_file-----------------");
	load_lstack_from_file(S,"./database");
	show_lstack(S);
	return 0;
}
















