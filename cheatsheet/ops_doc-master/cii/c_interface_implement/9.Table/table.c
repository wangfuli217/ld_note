#include <limits.h>
#include <stddef.h>
#include <assert.h>
#include "table.h"
#include "mem.h"

static int cmpatom(const void *x, const void *y)
{
	return x != y;
}

static unsigned hashatom(const void *key) 
{
	return (unsigned long)key>>2;
}

//new
Table Table_new(int hint,
	int (*cmp)(const void *x, const void *y),
	unsigned (*hash)(const void *key)) 
{
	Table table;
	int i = 1;
	static int primes[] = { 509, 509, 1021, 2053, 4093,
						    8191, 16381, 32771, 65521, INT_MAX };
	
	//参数检验 
	assert(hint >= 0);
	//选择合适的质数 
	for (; primes[i] < hint; i++)
		;
	//创建表，并设定表的相关字段 
	table = ALLOC(sizeof (*table) +
		primes[i-1]*sizeof (table->buckets[0]));
	table->size = primes[i-1];
	table->cmp  = cmp  ?  cmp : cmpatom;
	table->hash = hash ? hash : hashatom;
	table->buckets = (struct bind **)(table + 1);
	for (i = 0; i < table->size; i++)
		table->buckets[i] = NULL;
	table->length = 0;
	table->timestamp = 0;
	return table;
}

//get
void *Table_get(Table table, const void *key) 
{
	int i;
	Bind p;
	
	//参数检验 
	assert(table);
	assert(key);
	//计算哈希值 
	i = (table->hash)(key) % table->size;
	//遍历相同哈希值的链表 
	for (p = table->buckets[i]; p; p = p->link)
	{
		if((table->cmp)(key,p->key) == 0)
			return p->value;	
	}
	return NULL; 
}

//put
void *Table_put(Table table, const void *key, void *value) 
{
	int i;
	Bind p;
	void *finded = NULL;
	
	//参数检验 
	assert(table);
	assert(key);
	//计算哈希值
	i = (table->hash)(key)%table->size;
	//遍历相同哈希值的链表 
	for (p = table->buckets[i]; p; p = p->link)
	{
		if ((table->cmp)(key, p->key) == 0)
			break;
	} 
	//未找到	
	if (p == NULL) 
	{
		//创建一个表项（键与值的绑定）， 
		NEW(p);
		p->key = key;
		//插入变相 
		p->link = table->buckets[i];
		table->buckets[i] = p;
		table->length++;
	} 
	else
	{ //找到了 
		finded = p->value;
	} 
	//找到更新值，未找到填写表项的value字段 
	p->value = value;
	table->timestamp++;
	return finded;
}

//表项的个数 
int Table_length(Table table) 
{
	assert(table);
	return table->length;
}

//map
void Table_map(Table table,
			   void (*apply)(const void *key, void **value)) 
{
	int i;
	unsigned int stamp;
	Bind p;
	
	assert(table);
	assert(apply);
	stamp = table->timestamp;
	for (i = 0; i < table->size; i++)
	{ 
		for (p = table->buckets[i]; p; p = p->link)
		{
			apply(p->key, &p->value);
			assert(table->timestamp == stamp);
		}
	} 
}

//移除一个表项 
void *Table_remove(Table table, const void *key) 
{
	int i;
	Bind *pp; 
	 
	assert(table);
	assert(key);
	
	table->timestamp++;
	i = (table->hash)(key)% table->size;
	for (pp = &table->buckets[i]; *pp; pp = &(*pp)->link)
	{ 
		if ((table->cmp)(key, (*pp)->key) == 0) 
		{
			Bind p = *pp;
			void *value = p->value;
			
			*pp = p->link;
			FREE(p);
			table->length--;
			return value;
		}
	} 
	return NULL;
}


//转换为以end结尾的数组 
void **Table_toArray(Table table, void *end) 
{
	int  i, j = 0;
	void **array;
	Bind p;
	 
	assert(table);
	array = ALLOC((2*table->length + 1) * sizeof(*array));
	for (i = 0; i < table->size; i++)
	{ 
		for (p = table->buckets[i]; p; p = p->link) 
		{
			array[j++] = (void *)p->key;
			array[j++] = p->value;
		}
	} 
	array[j] = end;
	return array;
}

//释放表项 
void Table_free(Table *table) 
{
	assert(table && *table);
	
	if ((*table)->length > 0) 
	{
		int i;
		Bind p, q;
		for (i = 0; i < (*table)->size; i++)
		{ 
			for (p = (*table)->buckets[i]; p; p = q) 
			{
				q = p->link;
				FREE(p);
			}
		} 
	}
	FREE(*table);
}
