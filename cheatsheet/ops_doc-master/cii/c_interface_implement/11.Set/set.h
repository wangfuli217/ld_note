#ifndef _SET_H_
#define _SET_H_

//一个表项 
typedef struct member
{
	struct bind *link;
	const  void *member;
}*Member;

//表的定义 
typedef struct set
{
	int size; //hash大小 
	int (*cmp)(const void *x, const void *y);
	unsigned int (*hash)(const void *key);
	int length;//表项的数目 
	unsigned int timestamp;//只有put，remove才会改变 
	Member *buckets;
}*Set;

//new
extern Set Set_new (int hint,
	int (*cmp)(const void *x, const void *y),
	unsigned (*hash)(const void *x));
	
//free
extern void  Set_free(Set *set);

//length
extern int   Set_length(Set set);

//add/put
extern void *Set_put(Set set, const void *member);

//check member 
extern int   Set_member(Set set, const void *member);

//delet/remove
extern void *Set_remove(Set set, const void *member);

//map,遍历节点施压apply操作 
extern void  Set_map(Set set, void (*apply)(const void *member));

//toArray 
extern void **Set_toArray(Set set, void *end);

//union并 
extern Set Set_union(Set s, Set t);

//inter交
extern Set Set_inter(Set s, Set t);

//minus差，在集合S但不在集合t中元素集合 
extern Set Set_minus(Set s, Set t);

//diff对称差，仅在一个集合 
extern Set Set_diff (Set s, Set t);

#endif

