#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>
#include "seq.h"
#include "array.h"
#include "mem.h"



struct Seq_t
{
	struct Array_t array; //һ����̬���� 
	int length;			  //ʹ�ó��� 
	int head;			  //��ʼͷλ�� 
};
/*
 array���߼��İ汾
 ������vector,�������ǿ�� 
 ����ӵ�ͷ��Ҳ������ӵ�β�������ͷ��������headλ��֮ǰ��ӣ�������head��
 ���headΪ0����ǰһ��λ�þ���array.length - 1��λ�ã�ѭ��ʹ�ã�length����ʹ����� 
	-----
	+++++ 
	-----
	+++++ 
	-----
	
	-----
	 head
	-----
	+++++ 
	-----
	+++++ 
	----- 
*/ 

//����vector������ 
static void expand(Seq seq) 
{
	int n = seq->array.length;
	
	Array_resize(&seq->array, 2*n);
	if (seq->head > 0)
	{
		void **old = &((void **)seq->array.array)[seq->head];
		memcpy(old+n, old, (n - seq->head)*sizeof (void *));
		seq->head += n;
	}
}

//new
Seq Seq_new(int hint) 
{
	Seq seq;
	
	assert(hint >= 0);
	
	NEW0(seq);
	if (hint == 0)
		hint = 16;
	ArrayRep_init(&seq->array, hint, sizeof (void *),
		ALLOC(hint*sizeof (void *)));
	
	return seq;
}

//��Ӧ�����б�׷������ 
Seq Seq_seq(void *x, ...) 
{
	va_list ap;
	
	Seq seq = Seq_new(0);
	va_start(ap, x);
	for ( ; x; x = va_arg(ap, void *))
		Seq_addhi(seq, x);
	va_end(ap);
	
	return seq;
}

void Seq_free(Seq *seq) 
{
	assert(seq && *seq);
	assert((void *)*seq == (void *)&(*seq)->array);
	
	Array_free((Array *)seq);
}

int Seq_length(Seq seq) 
{
	assert(seq);
	
	return seq->length;
}

//��ö�Ӧλ���ϵ�ֵ 
void *Seq_get(Seq seq, int i) 
{
	assert(seq);
	
	assert(i >= 0 && i < seq->length);
	return ((void **)seq->array.array)[
	       	(seq->head + i)%seq->array.length];
}

//ָ��λ��������ֵ������֮ǰ��ֵ 
void *Seq_put(Seq seq, int i, void *x) 
{
	void *prev;

	assert(seq);
	assert(i >= 0 && i < seq->length);//ȷ����λ���Ѿ�����ʹ�� 

	prev = ((void **)seq->array.array)[(seq->head + i)%seq->array.length];
	((void **)seq->array.array)[(seq->head + i)%seq->array.length] = x;

	return prev;
}

//ɾ��β���ϵ�ֵ 
void *Seq_remhi(Seq seq) 
{
	int i;

	assert(seq);
	assert(seq->length > 0);

	i = --seq->length;

	return ((void **)seq->array.array)[
	       	(seq->head + i)%seq->array.length];
}

//ɾ��ͷ����ֵ 
void *Seq_remlo(Seq seq) 
{
	void *x;

	assert(seq);
	assert(seq->length > 0);

	x = ((void **)seq->array.array)[
			seq->head % seq->array.length]; //����֮ǰ��ֵ 
	seq->head = (seq->head + 1)%seq->array.length; //��һ��λ��//ѭ���� 
	--seq->length;

	return x;
}

//β������ 
void *Seq_addhi(Seq seq, void *x) 
{
	int i;

	assert(seq);

	if (seq->length == seq->array.length)
		expand(seq);
	i = seq->length++;

	return ((void **)seq->array.array)[
	       	(seq->head + i)%seq->array.length] = x;
}

//ͷ������ 
void *Seq_addlo(Seq seq, void *x) 
{
	int i = 0;

	assert(seq);
	if (seq->length == seq->array.length)
		expand(seq);
	if (--seq->head < 0)
		seq->head = seq->array.length - 1;
	seq->length++;

	return ((void **)seq->array.array)[
	       	(seq->head + i)%seq->array.length] = x;
}

//���� 
void Seq_map(Seq seq, void (*apply)(void *))
{
	int i,head;
	
	assert(seq);
	
	head = seq->head;
	i	 = seq->length;
	
	while(i > 0)
	{
		apply(((void **)seq->array.array)[
	       	(head++)%seq->array.length]);
	    i--;
	}
	 
} 

