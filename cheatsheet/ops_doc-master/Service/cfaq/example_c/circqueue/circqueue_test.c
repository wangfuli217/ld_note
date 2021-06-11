#include "circqueue.h"
#include <stdio.h>
#include <stdlib.h>

#define pnode(n) printf("data: %d\n", *(int*)(n->data));

int
main(int argc, char* argv[])
{
	queue_root_t root;
	
	queue_init(&root, 10);
	
	void* p = malloc(sizeof(int));
	*(int*)p = 10;
	printf("result: %d\n", queue_push(&root, p));
	queue_node_t* node = queue_pop(&root);
	pnode(node);
	
	void* pp = malloc(sizeof(int));
	*(int*)pp = 100;
	printf("result: %d\n", queue_push(&root, pp));
	node = queue_pop(&root);
	pnode(node);
	
	free(p);
	free(pp);
	
	for (int i = 0; i < 10; i++) {
		void* ppp = malloc(sizeof(int));
		
		*(int*)ppp = i;
		printf("result: %d\n", queue_push(&root, ppp));
		printf("size: %u\n", queue_count(&root));
	}
	
	for (int i = 0; i < 10; i++) {
		queue_node_t* node = queue_pop(&root);
		pnode(node);
		free(node->data);
	}
	
	/* 验证循环插入的正确性 */
	for (int i = 0; i < 10; i++) {
		void* ppp = malloc(sizeof(int));
		
		*(int*)ppp = i;
		printf("result: %d\n", queue_push(&root, ppp));
		printf("size: %u\n", queue_count(&root));
	}	
	
	for (int i = 0; i < 5; i++) {
		queue_node_t* node = queue_pop(&root);
		pnode(node);
		free(node->data);
	}
	
	for (int i = 10; i < 15; i++) {
		void* ppp = malloc(sizeof(int));
		*(int*)ppp = i;
		printf("result: %d\n", queue_push(&root, ppp));
		printf("size: %u\n", queue_count(&root));
	}

	system("pause");
	
	return 0;
}
