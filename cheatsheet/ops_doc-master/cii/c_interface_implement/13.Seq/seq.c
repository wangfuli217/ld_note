#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>
#include "seq.h"
#include "array.h"
#include "mem.h"



struct Seq_t
{
	struct Array_t array; //一个动态数组 
	int length;			  //使用长度 
	int head;			  //起始头位置 
};
/*
 array更高级的版本
 类似于vector,但比其更强大 
 可添加到头部也可以添加到尾部，添加头部就是在head位置之前添加，并调整head，
 如果head为0，其前一个位置就是array.length - 1的位置，循环使用，length控制使用情况 
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

//类似vector的增长 
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

//对应参数列表追加序列 
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

//获得对应位置上的值 
void *Seq_get(Seq seq, int i) 
{
	assert(seq);
	
	assert(i >= 0 && i < seq->length);
	return ((void **)seq->array.array)[
	       	(seq->head + i)%seq->array.length];
}

//指定位置上设置值，返回之前的值 
void *Seq_put(Seq seq, int i, void *x) 
{
	void *prev;

	assert(seq);
	assert(i >= 0 && i < seq->length);//确保该位置已经申请使用 

	prev = ((void **)seq->array.array)[(seq->head + i)%seq->array.length];
	((void **)seq->array.array)[(seq->head + i)%seq->array.length] = x;

	return prev;
}

//删除尾部上的值 
void *Seq_remhi(Seq seq) 
{
	int i;

	assert(seq);
	assert(seq->length > 0);

	i = --seq->length;

	return ((void **)seq->array.array)[
	       	(seq->head + i)%seq->array.length];
}

//删除头部的值 
void *Seq_remlo(Seq seq) 
{
	void *x;

	assert(seq);
	assert(seq->length > 0);

	x = ((void **)seq->array.array)[
			seq->head % seq->array.length]; //返回之前的值 
	seq->head = (seq->head + 1)%seq->array.length; //下一个位置//循环的 
	--seq->length;

	return x;
}

//尾部附加 
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

//头部附加 
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

//遍历 
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

