#include <stdarg.h>
#include <string.h>
#include <assert.h>
#include "bit.h"
#include "mem.h"
//long的比特位个数 
#define BPW (8*sizeof (unsigned long))
//给定bit位以long型存储的个数 
#define nwords(len) ((((len) + BPW - 1)&(~(BPW-1)))/BPW)
//给定bit位以char型存储的个数 
#define nbytes(len) ((((len) + 8 - 1)&(~(8-1)))/8)

#define setop(sequal, snull, tnull, op) \
	if (s == t) { assert(s); return sequal; } \
	else if (s == NULL) { assert(t); return snull; } \
	else if (t == NULL) return tnull; \
	else { \
		int i; Bit set; \
		assert(s->length == t->length); \
		set = Bit_new(s->length); \
		for (i = nwords(s->length); --i >= 0; ) \
			set->words[i] = s->words[i] op t->words[i]; \
		return set;\
	}
	
/* 函数的形式

[返回值类型] 函数名([参数列表])
{
	[局部变量定义];
	
	[参数校验];
	
	[控制计算];
	
	[返回值]; 
}
 
*/

//[i,7]全部置位的值，i为数组下标 
unsigned char msbmask[] =
{
	0xFF, 0xFE, 0xFC, 0xF8,
	0xF0, 0xE0, 0xC0, 0x80
};

//[0,i]全部置位的值，i为数组下标 
unsigned char lsbmask[] =
{
	0x01, 0x03, 0x07, 0x0F,
	0x1F, 0x3F, 0x7F, 0xFF
};

//拷贝一个位向量 
static Bit copy(Bit t)
{
	Bit set;
	assert(t);
	set = Bit_new(t->length);
	if (t->length > 0)
		memcpy(set->bytes, t->bytes, nbytes(t->length));
	return set;
}
//new 
Bit Bit_new(int length)
{
	Bit set;
	assert(length >= 0);
	NEW(set);
	if (length > 0) //申请空间并清零 
		set->words = CALLOC(nwords(length),
		                    sizeof (unsigned long));
	else
		set->words = NULL;
	set->bytes = (unsigned char *)set->words; //同样指向位图区域 
	set->length = length;
	return set;
}

//free 
void Bit_free(Bit *set)
{
	assert(set && *set);
	FREE((*set)->words);
	FREE(*set);
}

//比特位的个数即数值的最大值 - 1  
int Bit_length(Bit set)
{
	assert(set);
	return set->length;
}

//比特位中置位个数 
int Bit_count(Bit set)
{
	int length = 0, n;
	static char count[] =
	{
		0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4
	}; //半字节的数值对应的置位个数 

	assert(set);

	for (n = nbytes(set->length); --n >= 0; )
	{
		unsigned char c = set->bytes[n]; //一个字节 
		length += count[c&0xF] + count[c>>4]; //一个字节置位个数，即两个半字节置位个数 
	}
	
	return length;
}

//获得一个数值(即bit位)的存在状态，1存在，0不存在
int Bit_get(Bit set, int n)
{
	assert(set);
	assert(0 <= n && n < set->length);
	
	return ((set->bytes[n/8]>>(n%8))&1); //bit位n是字节n/8中的第n%8 
}

//将一个值填入位向量中，并设置其状态(0/1),返回之前状态 
int Bit_put(Bit set, int n, int bit)
{
	int prev;
	
	assert(set);
	assert(bit == 0 || bit == 1);
	assert(0 <= n && n < set->length);
	
	prev = ((set->bytes[n/8]>>(n%8))&1); //获得某一位的状态 
	if (bit == 1)
		set->bytes[n/8] |=   1<<(n%8); //某一位置位 
	else
		set->bytes[n/8] &= ~(1<<(n%8));//某一位清零 
	return prev;
}

//[lo,hi]范围置位 
void Bit_set(Bit set, int lo, int hi)
{
	int i;
	
	assert(set);
	assert(0 <= lo && hi < set->length);
	assert(lo <= hi);
	
	if (lo/8 < hi/8) //不同字节中 
	{
		set->bytes[lo/8] |= msbmask[lo%8];	//[lo, x.7]均置位
		for (i = lo/8+1; i < hi/8; i++)
			set->bytes[i] = 0xFF;           //中间所有字节均置位 
		set->bytes[hi/8] |= lsbmask[hi%8];  //[x.0, hi]均置位
	}
	else	//同一个字节中 
		set->bytes[lo/8] |= (msbmask[lo%8]&lsbmask[hi%8]);//一个字节中[lo,hi]置位
		//[lo,x.7]&[x.0,hi] 
}

//[lo,hi]范围清零 
void Bit_clear(Bit set, int lo, int hi)
{
	assert(set);
	assert(0 <= lo && hi < set->length);
	assert(lo <= hi);
	if (lo/8 < hi/8)
	{
		int i;
		set->bytes[lo/8] &= ~msbmask[lo%8]; //[lo, x.7]均清零 
		for (i = lo/8+1; i < hi/8; i++)
			set->bytes[i] = 0;				//中间所有字节均清零 
		set->bytes[hi/8] &= ~lsbmask[hi%8]; //[x.0, hi]均清零 
	}
	else
		set->bytes[lo/8] &= ~(msbmask[lo%8]&lsbmask[hi%8]); //一个字节中[lo,hi]清零 
}

//[lo,hi]范围取反 
void Bit_not(Bit set, int lo, int hi)
{
	assert(set);
	assert(0 <= lo && hi < set->length);
	assert(lo <= hi);
	if (lo/8 < hi/8)
	{
		int i;
		set->bytes[lo/8] ^= msbmask[lo%8]; //[lo, x.7]均取反 (某位取反等于该位与1异或) 
		for (i = lo/8+1; i < hi/8; i++)
			set->bytes[i] ^= 0xFF;	  	   //中间所有字节均取反 
		set->bytes[hi/8] ^= lsbmask[hi%8]; //[x.0, hi]均取反 
	}
	else
		set->bytes[lo/8] ^= (msbmask[lo%8]&lsbmask[hi%8]);//一个字节中[lo,hi]取反 
}

//对每一位施加apply操作 
void Bit_map(Bit set, void apply(int n, int bit))
{
	int n;
	
	assert(set);
	
	for (n = 0; n < set->length; n++)
		apply(n, ((set->bytes[n/8]>>(n%8))&1));
}


int Bit_eq(Bit s, Bit t)
{
	int i;
	assert(s && t);
	assert(s->length == t->length);
	for (i = nwords(s->length); --i >= 0; )
		if (s->words[i] != t->words[i])
			return 0;
	return 1;
}

int Bit_leq(Bit s, Bit t)
{
	int i;
	assert(s && t);
	assert(s->length == t->length);
	for (i = nwords(s->length); --i >= 0; )
		if ((s->words[i]&~t->words[i]) != 0)
			return 0;
	return 1;
}

int Bit_lt(Bit s, Bit t)
{
	int i, lt = 0;
	assert(s && t);
	assert(s->length == t->length);
	for (i = nwords(s->length); --i >= 0; )
		if ((s->words[i]&~t->words[i]) != 0)
			return 0;
		else if (s->words[i] != t->words[i])
			lt |= 1;
	return lt;
}

//位向量集合的操作必须等长即容纳能力相等

//并 
Bit Bit_union(Bit s, Bit t)
{
	setop(copy(t), copy(t), copy(s), |)
}

//交 
Bit Bit_inter(Bit s, Bit t)
{
	setop(copy(t),
	      Bit_new(t->length), Bit_new(s->length), &)
}

//差 
Bit Bit_minus(Bit s, Bit t)
{
	setop(Bit_new(s->length),
	      Bit_new(t->length), copy(s), & ~)
}

//对称差 
Bit Bit_diff(Bit s, Bit t)
{
	setop(Bit_new(s->length), copy(t), copy(s), ^)
}

