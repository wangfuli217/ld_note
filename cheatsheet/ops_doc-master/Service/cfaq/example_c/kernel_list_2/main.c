#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "list.h"

struct stu {
	int num;
	char name[20];
	struct list_head list;
};

int main(void)
{
	struct stu *list_node = NULL;
	struct list_head *pos = NULL,*n = NULL;
	struct stu *pnode = NULL;


	struct stu *head = (struct stu *)malloc(sizeof(struct stu));
	if (head == NULL) {
		printf("file,%s line,%d:malloc error!\n",__FILE__,__LINE__);
		exit(1);
	}
	
	INIT_LIST_HEAD(&head->list);

	list_node = (struct stu *)malloc(sizeof(struct stu));
	if (list_node == NULL) {
		printf("file,%s line,%d:malloc error!\n",__FILE__,__LINE__);
		exit(1);
	}

	list_node->num = 0;
	strcpy(list_node->name,"xiaoming");
	list_add_tail(&list_node->list,&head->list);

	list_node = (struct stu *)malloc(sizeof(struct stu));
	if (list_node == NULL) {
		printf("file,%s line,%d:malloc error!\n",__FILE__,__LINE__);
		exit(1);
	}

	list_node->num = 1;
	strcpy(list_node->name,"xiaohua");
	list_add_tail(&list_node->list,&head->list);
	
	if (list_empty(&head->list)) {
		printf("list is empty!\n");
	} else {	
		list_for_each(pos,&head->list) {
			pnode = list_entry(pos,struct stu,list);
			printf("num:%d,name %s\n",pnode->num,pnode->name);	
		}
	}

	list_for_each_safe(pos,n,&head->list) {
		list_del(pos);
		pnode = list_entry(pos,struct stu,list);
		printf("num %d has removed from the list!\n",pnode->num);
	}	free(pnode);

	free(head);
	
	system("pause");
	return 0;
}
