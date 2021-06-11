#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#include <event3/util.h>
#include <event3/event.h>
#include "mm-internal.h" //此头本应是libvent内部使用 在这是测试下
#include "log-internal.h" //此头本应是libvent内部使用 在这是测试下
#include "event-internal.h"

#define ARR_SZIE 10


//evmap.c:
struct evmap_io {
    struct event_list events;
    ev_uint16_t nread;
    ev_uint16_t nwrite;
};

struct event_map_entry {
     HT_ENTRY(event_map_entry) map_node;
     evutil_socket_t fd;
     union {
         struct evmap_io evmap_io;
     } ent;
};

static inline unsigned hashsocket(struct event_map_entry *e){
    unsigned h = (unsigned) e->fd;
    h += (h >> 2) | (h << 30);
    return h;
}

unsigned my_hashsocket(int fd){
    unsigned h = (unsigned) fd;
    h += (h >> 2) | (h << 30);
    return h;
}

static inline int
eqsocket(struct event_map_entry *e1, struct event_map_entry *e2){
    return e1->fd == e2->fd;
}

//因为HT_PROTOTYPE里展开的函数都是static的所以需要再次引用
HT_PROTOTYPE(event_io_map, event_map_entry, map_node, hashsocket, eqsocket)

////HT_GENERATE里展开的函数变量都不是static所以用原来的就行
//HT_GENERATE(event_io_map, event_map_entry, map_node, hashsocket, eqsocket,
//            0.5, mm_malloc, mm_realloc, mm_free)

//返回值:等于0是打印
int print_fun(struct event_map_entry*p1, void *p2){
	printf("address:%x, fd:%d\n", p1, p1->fd);
	return 0;
}

//返回值:不等于0是删除元素
int remove_fun(struct event_map_entry*p1, void *p2){
	mm_free(p1);
	return 1;
}

//和HT_REPLACE一样, 手写了一个出问题方便调试
//static inline struct event_map_entry*
//MY_HT_REPLACE(struct event_io_map *head, struct event_map_entry *elm)
//{
//  struct event_map_entry **p, *r;
//  if (!head->hth_table || head->hth_n_entries >= head->hth_load_limit)
//    event_io_map_HT_GROW(head, head->hth_n_entries+1);
//  _HT_SET_HASH(elm, map_node, hashsocket);
//  p = _event_io_map_HT_FIND_P(head, elm);
//  r = *p;
//  *p = elm;
//  if (r && (r!=elm)) {
//    elm->map_node.hte_next = r->map_node.hte_next;
//    r->map_node.hte_next = NULL;
//    return r;
//  } else {
//    ++head->hth_n_entries;
//    return NULL;
//  }
//}

//7.hashtable.c是需要特别指定makefile文件进行make
//make -f makefile_win32
//make -f makefile_win32 clean
int main(int argc, const char *argv[])
{
	int i, ret, tmp_int, hash_id;
	struct event_map_entry *elemp;
	struct event_map_entry **elempp;

	//1.evmap.c 定义结构体 struct event_map_entry

	

	//2.在event-internal.h 定义struct event_io_map
	//HT_HEAD(event_io_map, event_map_entry);
	//展开后就是这个
	//struct event_io_map  
	//{  
	//    //哈希表  
	//    struct event_map_entry **hth_table;  
	//    //哈希表的长度  
	//    unsigned hth_table_length;  
	//    //哈希的元素个数  
	//    unsigned hth_n_entries;  
	//    //resize 之前可以存多少个元素  
	//    //在event_io_map_HT_GROW函数中可以看到其值为hth_table_length的  
	//    //一半。但hth_n_entries>=hth_load_limit时，就会发生增长哈希表的长度  
	//    unsigned hth_load_limit;  
	//    //后面素数表中的下标值。主要是指明用到了哪个素数  
	//    int hth_prime_idx;  
	//};  

	//3.INIT
	struct event_io_map head;
	HT_INIT(event_io_map, &head);

	//4.INSERT
	struct event_map_entry* elem_arr[ARR_SZIE]={NULL, };
	for (i = 0; i < ARR_SZIE; i++) {
		elem_arr[i] = mm_malloc(sizeof(struct event_map_entry));
		elem_arr[i]->fd = i;
		HT_INSERT(event_io_map, &head, elem_arr[i]);
	}
	printf("hashtable 元素总个数:%d\n", HT_SIZE(&head));
	
	//5.查看hash分布情况
	printf("hashtable 总长度:%d\n", head.hth_table_length);
	for (i = 0; i < ARR_SZIE; i++) {
		tmp_int = _HT_ELT_HASH(elem_arr[i], map_node, hashsocket);
		hash_id = tmp_int % head.hth_table_length;
		printf("i:%d, hash_id:%d\n", i, hash_id);
	}
	//FOREACH_FN
	event_io_map_HT_FOREACH_FN(&head, print_fun, NULL);

	//6.FIND_P
	struct event_map_entry find_entry;
	find_entry.fd = 3;
	elempp = _event_io_map_HT_FIND_P(&head, &find_entry);
	if (*elempp) {
		printf("FIND_P 获取fd:%d\n", (*elempp)->fd);
	}

	//11.HT_NEXT
	printf("=======================================\n");
	struct event_map_entry **elempp1;
	elempp1 = HT_NEXT(event_io_map, &head, elempp);
	if (elempp1) {
		printf("fd:%d HT_NEXT is fd:%d\n",elem_arr[3]->fd , (*(elempp1))->fd);
	}else{
		printf("not have HT_NEXT");
	}

	//12.HT_NEXT_RMV
	printf("=======================================\n");
	elempp1 = NULL;
	elempp1 = HT_NEXT_RMV(event_io_map, &head, elempp);
	if (elempp1) {
		printf("fd:%d HT_NEXT_RMV is fd:%d\n",elem_arr[3]->fd , (*(elempp1))->fd);
		mm_free(elem_arr[3]);
	}else{
		printf("not have HT_NEXT");
	}
	event_io_map_HT_FOREACH_FN(&head, print_fun, NULL);

	//7.FIND
	printf("=======================================\n");
	elemp = HT_FIND(event_io_map, &head, elem_arr[9]);
	if (elemp) {
		printf("FIND 元素fd:%d\n", elemp->fd);
		printf("FIND 元素地址:%x\n", elemp);
	}

	//8.REPLACE 新元素不存在于hashtable则插入
	printf("=======================================\n");
	hash_id = my_hashsocket(300) % head.hth_table_length;
	printf("hash_id %d\n", hash_id);
	struct event_map_entry *new_elem_p1;
	new_elem_p1 = mm_malloc(sizeof(struct event_map_entry));
	if (new_elem_p1==NULL) {
		perror("malloc");
		exit(1);
	}
	new_elem_p1->fd = 300;
	elemp = NULL;
	elemp = HT_REPLACE(event_io_map, &head, new_elem_p1);
	if (elemp==NULL) {
		printf("REPLACE中插入成功 fd:%d\n", new_elem_p1->fd);
	}else{
		printf("error\n");
		exit(1);
	}
	printf("hashtable 元素总个数:%d\n", HT_SIZE(&head));
	event_io_map_HT_FOREACH_FN(&head, print_fun, NULL);
	//DEBUG
	ret = _event_io_map_HT_REP_IS_BAD(&head);
	if (ret) {
		printf("hashtable has error:%d\n", ret);
		exit(1);
	}

	//9.REPLACE存在和elem一样的则替换
	printf("=======================================\n");
	struct event_map_entry* new_elem_p2;
	new_elem_p2 = malloc(sizeof(struct event_map_entry));
	if (new_elem_p2 == NULL) {
		perror("malloc");
		exit(1);
	}
	new_elem_p2->fd = 5;
	elemp = NULL;
	elemp = HT_REPLACE(event_io_map, &head, new_elem_p2);
	if (elemp) {
		printf("REPLACE中替换成功\n");
		printf("获取被替换的元素 fd:%d\n", elemp->fd);
		printf("获取被替换的元素 address:%x\n", elemp);
		mm_free(elemp);
	}else{
		printf("error\n");
		exit(1);
	}
	printf("hashtable 元素总个数:%d\n", HT_SIZE(&head));
	event_io_map_HT_FOREACH_FN(&head, print_fun, NULL);
	//DEBUG
	ret = _event_io_map_HT_REP_IS_BAD(&head);
	if (ret) {
		printf("hashtable has error:%d\n", ret);
		exit(1);
	}

	//10.REMOVE
	printf("=======================================\n");
	struct event_map_entry *new_elem_p3;
	new_elem_p3 = malloc(sizeof(struct event_map_entry));
	if (new_elem_p3 == NULL) {
		perror("malloc");
		exit(1);
	}
	new_elem_p3->fd = 9;
	elemp = NULL;
	elemp = HT_REMOVE(event_io_map, &head, new_elem_p3);
	if (elemp) {
		printf("REMOVE成功\n");
		printf("REMOVE被删除的元素fd:%d\n", elemp->fd);
		mm_free(elemp);
	}else{
		printf("REMOVE失败\n");
		exit(1);
	}
	printf("hashtable 元素总个数:%d\n", HT_SIZE(&head));
	event_io_map_HT_FOREACH_FN(&head, print_fun, NULL);

	//10.获取第一条冲突链的第一个元素
	printf("=====================================================\n");
	struct event_map_entry **mapp;
	mapp = HT_START(event_io_map, &head);
	if (mapp == NULL) {
		printf("没能获取第一条冲突链的第一个元素\n");
		exit(1);
	}else{
		printf("获取第一条冲突链的第一个元素 fd:%d\n", (*(mapp))->fd);
	}

	//11.FOREACH_FN普通打印
	printf("==============11.FOREACH_FN普通打印==================\n");
	event_io_map_HT_FOREACH_FN(&head, print_fun, NULL);
	printf("=====================================================\n");
	event_io_map_HT_FOREACH_FN(&head, print_fun, NULL);

	//12.FOREACH_FN删除所有元素
	printf("=============12.FOREACH_FN删除元素 ==================\n");
	event_io_map_HT_FOREACH_FN(&head, remove_fun, NULL);
	event_io_map_HT_FOREACH_FN(&head, print_fun, NULL);//打印不出东西

	//13.HT_CLEAR
	HT_CLEAR(event_io_map, &head);

	//14.DEBUG
	ret = _event_io_map_HT_REP_IS_BAD(&head);
	if (ret) {
		printf("hashtable has error:%d\n", ret);
		exit(1);
	}
	return 0;
}

