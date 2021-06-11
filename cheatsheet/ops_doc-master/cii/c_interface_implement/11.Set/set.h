#ifndef _SET_H_
#define _SET_H_

//һ������ 
typedef struct member
{
	struct bind *link;
	const  void *member;
}*Member;

//��Ķ��� 
typedef struct set
{
	int size; //hash��С 
	int (*cmp)(const void *x, const void *y);
	unsigned int (*hash)(const void *key);
	int length;//�������Ŀ 
	unsigned int timestamp;//ֻ��put��remove�Ż�ı� 
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

//map,�����ڵ�ʩѹapply���� 
extern void  Set_map(Set set, void (*apply)(const void *member));

//toArray 
extern void **Set_toArray(Set set, void *end);

//union�� 
extern Set Set_union(Set s, Set t);

//inter��
extern Set Set_inter(Set s, Set t);

//minus��ڼ���S�����ڼ���t��Ԫ�ؼ��� 
extern Set Set_minus(Set s, Set t);

//diff�ԳƲ����һ������ 
extern Set Set_diff (Set s, Set t);

#endif

