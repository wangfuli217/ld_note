#include <limits.h>
#include <stddef.h>
#include <assert.h>
#include "set.h"
#include "mem.h"

//�궨���в�Ҫ���ע�� //for(int i;;)only supported by C99 or C11 �� 
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

	//��������
	assert(hint >= 0);
	//ѡ����ʵ�����
	for (; primes[i] < hint; i++)
		;
	//�������ϣ����趨���ϵ�����ֶ�
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

	//��������
	assert(set);
	assert(member);
	//�����ϣֵ
	i = (set->hash)(member) % set->size;
	//������ͬ��ϣֵ������
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

	//��������
	assert(set);
	assert(member);

	//�����ϣֵ
	i = (set->hash)(member) % set->size;

	//������ͬ��ϣֵ������
	for (p = set->buckets[i]; p; p = p->link)
	{
		if ((set->cmp)(member, p->member) == 0)
			break;
	}
	//δ�ҵ�
	if (p == NULL)
	{
		//����һ������
		NEW(p);
		p->member = member;
		//�������
		p->link = set->buckets[i];
		set->buckets[i] = p;
		set->length++;
	}
	else
	{
		//�ҵ�����ֵ
		p->member = member;
	}
	set->timestamp++;
}

//����ĸ���
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

//�Ƴ�һ���������ɾ����Աָ��
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


//ת��Ϊ��end��β������
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

//�ͷű���
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


//copy����һ�����ϣ����ü��ϵ�Ԫ�ؿ�������һ��������
static Set Set_copy(Set t, int hint)
{
	Set set;
	Member q;
	int i;

	assert(t);
	set = Set_new(hint,t->cmp,t->hash);

	for (i = 0; i < t->size; i++)
	{

		for (q = t->buckets[i]; q; q = q->link) //��ʵhash����һ�£����������ϵ�hashֵһ��
		{
			Member p;
			int i= (set->hash)(q->member)% set->size;

			//����һ����
			NEW(p);
			p->member = q->member;
			p->link = set->buckets[i];
			//����
			set->buckets[i] = p;
			set->length++;
		}
	}
	return set;

}

//union��
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
	else //�������Ͼ���Ϊ��
	{
		Set set = Set_copy(s,max(s->size, t->size)); //����һ������
		assert(s->cmp == t->cmp && s->hash == t->hash);
		for(i = 0; i < t->size; i++)
		{
			for(q = t->buckets[i]; q; q = q->link)
				Set_put(set,q->member);
		}
		return set;
	}
}

//inter��,ͬʱ������s��t��
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
	else if (s->length < t->length) //���ý�С��һ�������µļ���
	{
		Set temp = s;
		s = t;
		t = temp;
	}
	else //�������Ͼ���Ϊ��
	{
		Set set = Set_new(min(s->size, t->size),s->cmp,s->hash); //����һ����С�ļ���
		assert(s->cmp == t->cmp && s->hash == t->hash);
		for(i = 0; i < t->size; i++)
		{
			for(q = t->buckets[i]; q; q = q->link)
			{
				if (Set_member(s,q->member)) //�������������вŲ���
				{
					Member p;
					int i = (set->hash)(q->member) % set->size;

					//����һ����
					NEW(p);
					p->member = q->member;
					p->link = set->buckets[i];
					//����
					set->buckets[i] = p;
					set->length++;
				}
			}
		}
		return set;
	}
}

//minus��ڼ���S�����ڼ���t��Ԫ�ؼ���
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
	else //�������Ͼ���ΪNULL
	{
		Set set = Set_new(min(s->size, t->size),s->cmp,s->hash); //����һ����С�ļ���
		assert(s->cmp == t->cmp && s->hash == t->hash);
		for(i = 0; i < s->size; i++)
		{
			for(q = s->buckets[i]; q; q = q->link)
			{
				if (!Set_member(t,q->member)) //ֻ��һ�������вŲ���
				{
					Member p;
					int i = (set->hash)(q->member) % set->size;

					//����һ����
					NEW(p);
					p->member = q->member;
					p->link = set->buckets[i];
					//����
					set->buckets[i] = p;
					set->length++;
				}
			}
		}
		return set;
	}
}

//diff�ԳƲ����һ������
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
	else //�������Ͼ���Ϊ��
	{
		Set set = Set_new(min(s->size,t->size),s->cmp,s->hash); //����һ������
		assert(s->cmp == t->cmp && s->hash == t->hash);
		for(i = 0; i < t->size; i++)
		{
			for(q = t->buckets[i]; q; q = q->link)
			{
				if (!Set_member(s,q->member))  //ֻ��һ�������вŲ���
				{
					Member p;
					int i = (set->hash)(q->member) % set->size;

					//����һ����
					NEW(p);
					p->member = q->member;
					p->link = set->buckets[i];
					//����
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
				if (!Set_member(t,q->member))  //ֻ��һ�������вŲ���
				{
					Member p;
					int i = (set->hash)(q->member) % set->size;

					//����һ����
					NEW(p);
					p->member = q->member;
					p->link = set->buckets[i];
					//����
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

