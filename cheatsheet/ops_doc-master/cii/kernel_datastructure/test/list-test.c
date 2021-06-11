#include <stdio.h>
#include <stdlib.h>
#include "list.h"

#define MAX_NODES     100

struct kool_list {
    int val;
    struct list_head list;
};
static LIST_HEAD(mylist_head);

int main(int argc, char **argv){

    struct kool_list *tmp;
    struct list_head *pos, *q;
    unsigned int i;

    for(i = 0; i <= MAX_NODES - 1; i++){
        tmp= (struct kool_list *)malloc(sizeof(struct kool_list));
	tmp->val = i;
        list_add(&(tmp->list), &mylist_head);
    }
    printf("\n");

    printf("traversing the list using list_for_each()\n");
    i = MAX_NODES - 1;
    list_for_each(pos, &mylist_head){
        tmp = list_entry(pos, struct kool_list, list);
        if(tmp->val != i)
		printf("error \n");
	i--;

    }
    printf("\n");

    i = MAX_NODES - 1;
    printf("traversing the list using list_for_each_entry()\n");
    list_for_each_entry(tmp, &mylist_head, list){
        if(tmp->val != i)
		printf("error \n");
	i--;
    }
    printf("\n");

    printf("deleting the list using list_for_each_safe()\n");
    list_for_each_safe(pos, q, &mylist_head){
        tmp = list_entry(pos, struct kool_list, list);
        list_del(pos);
        free(tmp);
    }

    return 0;
}
