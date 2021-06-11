#include <limits.h>
#include <stddef.h>
#include <assert.h>
#include "set.h"
#include "mem.h"

//宏定义中不要添加注释 //for(int i;;)only supported by C99 or C11 哎 
#define for_each_set(set,q) \
	for (int i = 0; i < set->size; i++) \
		for (q = set->buckets[i];q; q = q->link)
		
#define insert_set(set,m) do { \
		Member p;\
		int i= (set->hash)(m)% set->size;\
		NEW(p);\
		p->member = (m);\
		p->link = set->buckets[i];\
		set->buckets[i] = p;\
		set->length++;\
	}while(0)



static int cmpatom(const void *x, const void *y)
{
	return x != y;
}

static unsigned hashatom(const void *x)
{
	return (unsigned long)x>>2;
}

static int max(int a, int b)
{
	return a > b ? a : b;
}

static int min(int a, int b)
{
	return a < b ? a : b;
}

//new
Set Set_new (int hint,
             int (*cmp)(const void *x, const void *y),
             unsigned (*hash)(const void *x))
{
	Set set;
	int i = 1;
	static int primes[] = { 509, 509, 1021, 2053, 4093,
	                        8191, 16381, 32771, 65521, INT_MAX
	                      };

	//参数检验
	assert(hint >= 0);
	//选择合适的质数
	for (; primes[i] < hint; i++)
		;
	//创建集合，并设定集合的相关字段
	set = ALLOC(sizeof (*set) +
	            primes[i-1] * sizeof(set->buckets[0]));
	set->size = primes[i-1];
	set->cmp  = cmp  ?  cmp : cmpatom;
	set->hash = hash ? hash : hashatom;
	set->buckets = (struct member **)(set + 1);
	for (i = 0; i < set->size; i++)
		set->buckets[i] = NULL;
	set->length = 0;
	set->timestamp = 0;
	return set;
}

//check member y or n 1:yes 0:no
int Set_member(Set set, const void *member)
{
	int i;
	Member p;

	//参数检验
	assert(set);
	assert(member);
	//计算哈希值
	i = (set->hash)(member) % set->size;
	//遍历相同哈希值的链表
	for (p = set->buckets[i]; p; p = p->link)
	{
		if((set->cmp)(member,p->member) == 0)
			return 1;
	}
	return 0;
}

//put
void *Set_put(Set set, const void *member)
{
	int i;
	Member p;

	//参数检验
	assert(set);
	assert(member);

	//计算哈希值
	i = (set->hash)(member) % set->size;

	//遍历相同哈希值的链表
	for (p = set->buckets[i]; p; p = p->link)
	{
		if ((set->cmp)(member, p->member) == 0)
			break;
	}
	//未找到
	if (p == NULL)
	{
		//创建一个键，
		NEW(p);
		p->member = member;
		//插入变相
		p->link = set->buckets[i];
		set->buckets[i] = p;
		set->length++;
	}
	else
	{
		//找到更新值
		p->member = member;
	}
	set->timestamp++;
}

//表项的个数
int Set_length(Set set)
{
	assert(set);
	return set->length;
}

//map
void  Set_map(Set set, void (*apply)(const void *member))
{
	int i;
	unsigned int stamp;
	Member p;

	assert(set);
	assert(apply);
	stamp = set->timestamp;
	for (i = 0; i < set->size; i++)
	{
		for (p = set->buckets[i]; p; p = p->link)
		{
			apply(p->member);
			assert(set->timestamp == stamp);
		}
	}
}

//移除一个表项，返回删除成员指针
void *Set_remove(Set set, const void *member)
{
	int i;
	Member *pp;

	assert(set);
	assert(member);

	set->timestamp++;
	i = (set->hash)(member) % set->size;
	for (pp = &set->buckets[i]; *pp; pp = &(*pp)->link)
	{
		if ((set->cmp)(member, (*pp)->member) == 0)
		{
			Member p = *pp;

			member = p->member;
			*pp = p->link;
			FREE(p);
			set->length--;
			return (void *)member;
		}
	}
	return NULL;
}


//转换为以end结尾的数组
void **Set_toArray(Set set, void *end)
{
	int  i, j = 0;
	void **array;
	Member p;

	assert(set);
	array = ALLOC((set->length + 1) * sizeof(*array));
	for (i = 0; i < set->size; i++)
	{
		for (p = set->buckets[i]; p; p = p->link)
		{
			array[j++] = (void *)p->member;
		}
	}
	array[j] = end;
	return array;
}

//释放表项
void  Set_free(Set *set)
{
	assert(set && *set);

	if ((*set)->length > 0)
	{
		int i;
		Member p, q;
		for (i = 0; i < (*set)->size; i++)
		{
			for (p = (*set)->buckets[i]; p; p = q)
			{
				q = p->link;
				FREE(p);
			}
		}
	}
	FREE(*set);
}


//copy拷贝一个集合，将该集合的元素拷贝到另一个集合中
static Set Set_copy(Set t, int hint)
{
	Set set;
	Member q;
	int i;

	assert(t);
	set = Set_new(hint,t->cmp,t->hash);

	for (i = 0; i < t->size; i++)
	{

		for (q = t->buckets[i]; q; q = q->link) //其实hash函数一致，所以链表上的hash值一致
		{
			Member p;
			int i= (set->hash)(q->member)% set->size;

			//创建一个键
			NEW(p);
			p->member = q->member;
			p->link = set->buckets[i];
			//插入
			set->buckets[i] = p;
			set->length++;
		}
	}
	return set;

}

//union并
Set Set_union(Set s, Set t)
{
	int i;
	Member q;

	if (s == NULL)
	{
		assert(t);
		return Set_copy(t,t->size);
	}
	else if (t == NULL)
	{
		return Set_copy(s,s->size);
	}
	else //两个集合均不为空
	{
		Set set = Set_copy(s,max(s->size, t->size)); //拷贝一个集合
		assert(s->cmp == t->cmp && s->hash == t->hash);
		for(i = 0; i < t->size; i++)
		{
			for(q = t->buckets[i]; q; q = q->link)
				Set_put(set,q->member);
		}
		return set;
	}
}

//inter交,同时出现在s和t中
Set Set_inter(Set s, Set t)
{
	int i;
	Member q;

	if (s == NULL)
	{
		assert(t);
		return Set_new(t->size,t->cmp,t->hash);
	}
	else if (t == NULL)
	{
		return Set_new(s->size,s->cmp,t->hash);
	}
	else if (s->length < t->length) //利用较小的一个创建新的集合
	{
		Set temp = s;
		s = t;
		t = temp;
	}
	else //两个集合均不为空
	{
		Set set = Set_new(min(s->size, t->size),s->cmp,s->hash); //创建一个较小的集合
		assert(s->cmp == t->cmp && s->hash == t->hash);
		for(i = 0; i < t->size; i++)
		{
			for(q = t->buckets[i]; q; q = q->link)
			{
				if (Set_member(s,q->member)) //聚在两个集合中才插入
				{
					Member p;
					int i = (set->hash)(q->member) % set->size;

					//创建一个键
					NEW(p);
					p->member = q->member;
					p->link = set->buckets[i];
					//插入
					set->buckets[i] = p;
					set->length++;
				}
			}
		}
		return set;
	}
}

//minus差，在集合S但不在集合t中元素集合
Set Set_minus(Set s, Set t)
{
	int i;
	Member q;

	if (s = NULL)
	{
		assert(s);
		return Set_new(s->size,s->cmp,s->hash);
	}
	else if (t == NULL)
	{
		return Set_copy(s,s->size);
	}
	else //两个集合均不为NULL
	{
		Set set = Set_new(min(s->size, t->size),s->cmp,s->hash); //创建一个较小的集合
		assert(s->cmp == t->cmp && s->hash == t->hash);
		for(i = 0; i < s->size; i++)
		{
			for(q = s->buckets[i]; q; q = q->link)
			{
				if (!Set_member(t,q->member)) //只在一个集合中才插入
				{
					Member p;
					int i = (set->hash)(q->member) % set->size;

					//创建一个键
					NEW(p);
					p->member = q->member;
					p->link = set->buckets[i];
					//插入
					set->buckets[i] = p;
					set->length++;
				}
			}
		}
		return set;
	}
}

//diff对称差，仅在一个集合
Set Set_diff (Set s, Set t)
{
	int i;
	Member q;

	if (s == NULL)
	{
		assert(t);
		return Set_copy(t,t->size);
	}
	else if (t == NULL)
	{
		return Set_copy(s,s->size);
	}
	else //两个集合均不为空
	{
		Set set = Set_new(min(s->size,t->size),s->cmp,s->hash); //拷贝一个集合
		assert(s->cmp == t->cmp && s->hash == t->hash);
		for(i = 0; i < t->size; i++)
		{
			for(q = t->buckets[i]; q; q = q->link)
			{
				if (!Set_member(s,q->member))  //只在一个集合中才插入
				{
					Member p;
					int i = (set->hash)(q->member) % set->size;

					//创建一个键
					NEW(p);
					p->member = q->member;
					p->link = set->buckets[i];
					//插入
					set->buckets[i] = p;
					set->length++;
				}
			}
		}
//		for_each_set(t,q){
//			if (!Set_member(s,q->member)) 
//			{
//				insert_set(set,q->member);
//			}
//				
//		}
		
		for(i = 0; i < s->size; i++)
		{
			for(q = s->buckets[i]; q; q = q->link)
			{
				if (!Set_member(t,q->member))  //只在一个集合中才插入
				{
					Member p;
					int i = (set->hash)(q->member) % set->size;

					//创建一个键
					NEW(p);
					p->member = q->member;
					p->link = set->buckets[i];
					//插入
					set->buckets[i] = p;
					set->length++;
				}
			}
		}
//		for_each_set(s,q){
//			if (!Set_member(t,q->member)) 
//			{
//				insert_set(set,q->member);
//			}		
//		}
		return set;
	}
}

