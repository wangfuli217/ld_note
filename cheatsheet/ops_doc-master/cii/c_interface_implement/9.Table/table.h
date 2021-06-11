#ifndef _TABLE_H_
#define _TABLE_H_

//һ������ 
typedef struct bind
{
	struct bind *link;
	const void 	   *key;
	void 		   *value;	
}*Bind;

//��Ķ��� 
typedef struct Table_t
{
	int size; //hash��С 
	int (*cmp)(const void *x, const void *y);
	unsigned int (*hash)(const void *key);
	int length;//�������Ŀ 
	unsigned int timestamp;//ֻ��put��remove�Ż�ı� 
	Bind *buckets;
}*Table;

//new
extern Table Table_new (int hint,
	int (*cmp)(const void *x, const void *y),
	unsigned (*hash)(const void *key));
	
//free
extern void  Table_free(Table *table);

//length
extern int   Table_length(Table table);

//add/put
extern void *Table_put(Table table, const void *key,void *value);

//get
extern void *Table_get(Table table, const void *key);

//delet/remove
extern void *Table_remove(Table table, const void *key);

//map,�����ڵ�ʩѹapply���� 
extern void  Table_map(Table table,
					  void (*apply)(const void *key, void **value));
//toArray 
extern void **Table_toArray(Table table, void *end);

#endif

