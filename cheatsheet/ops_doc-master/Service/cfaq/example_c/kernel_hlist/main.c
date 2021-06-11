#include <stdio.h>
#include <stdlib.h>
#include "list.h"

struct ST {
    unsigned char ch;
    int         this_data;
    
    struct list_head  i_list;
    
    int         more_data;
    
    struct hlist_node i_hash;
    
    char        str_data[32];
    //.......
    int        end_data;
} *st;

struct list_head list1;  
struct hlist_head hlist[1024];

#define LISTSIZE 1024

unsigned int gethash(int c)
{
    return (c & 0xff);
}

main()
{
int i;
unsigned int hash;
struct list_head *list;
struct list_head *n, *p;
struct ST *pst;
struct hlist_node *hp;

    INIT_LIST_HEAD(&list1);
    for(hash = 0; hash < LISTSIZE; hash++)
        INIT_HLIST_HEAD(&hlist[hash]);

    for(i = 0; i < LISTSIZE; i++) {
        struct ST *p = malloc(sizeof(*p));
        if(!p) {
            printf("malloc.\n");
            break;
        }
        
        p->ch = 'a' + i;

                //串入长串
                list_add(&p->i_list, &list1);
        
        
                //串入HASH短串
        hash = gethash(p->ch);
        printf("ALLOC %x %d %p %u\n", p->ch, i, p, hash);
        hlist_add_head(&p->i_hash, &hlist[hash]);

    }
    
            
    //通过长铁丝遍历
    i = 0; 
    list_for_each(list, &list1) {
        struct ST *p = list_entry(list, struct ST, i_list);
        printf("%p  value %d = %c\n", p, i, p->ch);
        i++;
    }
    printf("total %d \n", i);

    //----------------------
    //通过hash串查找内容'C'的箱子
    hash = gethash('c');
    hlist_for_each(hp, &hlist[hash]) {
        struct ST *p = hlist_entry(hp, struct ST, i_hash);
        printf("hlist: %c\n", p->ch);

    }
	
	system("pause");
}
