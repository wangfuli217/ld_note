#include <stdarg.h>
#include <string.h>
#include <assert.h>
#include "bit.h"
#include "mem.h"
//long�ı���λ���� 
#define BPW (8*sizeof (unsigned long))
//����bitλ��long�ʹ洢�ĸ��� 
#define nwords(len) ((((len) + BPW - 1)&(~(BPW-1)))/BPW)
//����bitλ��char�ʹ洢�ĸ��� 
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
	
/* ��������ʽ

[����ֵ����] ������([�����б�])
{
	[�ֲ���������];
	
	[����У��];
	
	[���Ƽ���];
	
	[����ֵ]; 
}
 
*/

//[i,7]ȫ����λ��ֵ��iΪ�����±� 
unsigned char msbmask[] =
{
	0xFF, 0xFE, 0xFC, 0xF8,
	0xF0, 0xE0, 0xC0, 0x80
};

//[0,i]ȫ����λ��ֵ��iΪ�����±� 
unsigned char lsbmask[] =
{
	0x01, 0x03, 0x07, 0x0F,
	0x1F, 0x3F, 0x7F, 0xFF
};

//����һ��λ���� 
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
	if (length > 0) //����ռ䲢���� 
		set->words = CALLOC(nwords(length),
		                    sizeof (unsigned long));
	else
		set->words = NULL;
	set->bytes = (unsigned char *)set->words; //ͬ��ָ��λͼ���� 
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

//����λ�ĸ�������ֵ�����ֵ - 1  
int Bit_length(Bit set)
{
	assert(set);
	return set->length;
}

//����λ����λ���� 
int Bit_count(Bit set)
{
	int length = 0, n;
	static char count[] =
	{
		0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4
	}; //���ֽڵ���ֵ��Ӧ����λ���� 

	assert(set);

	for (n = nbytes(set->length); --n >= 0; )
	{
		unsigned char c = set->bytes[n]; //һ���ֽ� 
		length += count[c&0xF] + count[c>>4]; //һ���ֽ���λ���������������ֽ���λ���� 
	}
	
	return length;
}

//���һ����ֵ(��bitλ)�Ĵ���״̬��1���ڣ�0������
int Bit_get(Bit set, int n)
{
	assert(set);
	assert(0 <= n && n < set->length);
	
	return ((set->bytes[n/8]>>(n%8))&1); //bitλn���ֽ�n/8�еĵ�n%8 
}

//��һ��ֵ����λ�����У���������״̬(0/1),����֮ǰ״̬ 
int Bit_put(Bit set, int n, int bit)
{
	int prev;
	
	assert(set);
	assert(bit == 0 || bit == 1);
	assert(0 <= n && n < set->length);
	
	prev = ((set->bytes[n/8]>>(n%8))&1); //���ĳһλ��״̬ 
	if (bit == 1)
		set->bytes[n/8] |=   1<<(n%8); //ĳһλ��λ 
	else
		set->bytes[n/8] &= ~(1<<(n%8));//ĳһλ���� 
	return prev;
}

//[lo,hi]��Χ��λ 
void Bit_set(Bit set, int lo, int hi)
{
	int i;
	
	assert(set);
	assert(0 <= lo && hi < set->length);
	assert(lo <= hi);
	
	if (lo/8 < hi/8) //��ͬ�ֽ��� 
	{
		set->bytes[lo/8] |= msbmask[lo%8];	//[lo, x.7]����λ
		for (i = lo/8+1; i < hi/8; i++)
			set->bytes[i] = 0xFF;           //�м������ֽھ���λ 
		set->bytes[hi/8] |= lsbmask[hi%8];  //[x.0, hi]����λ
	}
	else	//ͬһ���ֽ��� 
		set->bytes[lo/8] |= (msbmask[lo%8]&lsbmask[hi%8]);//һ���ֽ���[lo,hi]��λ
		//[lo,x.7]&[x.0,hi] 
}

//[lo,hi]��Χ���� 
void Bit_clear(Bit set, int lo, int hi)
{
	assert(set);
	assert(0 <= lo && hi < set->length);
	assert(lo <= hi);
	if (lo/8 < hi/8)
	{
		int i;
		set->bytes[lo/8] &= ~msbmask[lo%8]; //[lo, x.7]������ 
		for (i = lo/8+1; i < hi/8; i++)
			set->bytes[i] = 0;				//�м������ֽھ����� 
		set->bytes[hi/8] &= ~lsbmask[hi%8]; //[x.0, hi]������ 
	}
	else
		set->bytes[lo/8] &= ~(msbmask[lo%8]&lsbmask[hi%8]); //һ���ֽ���[lo,hi]���� 
}

//[lo,hi]��Χȡ�� 
void Bit_not(Bit set, int lo, int hi)
{
	assert(set);
	assert(0 <= lo && hi < set->length);
	assert(lo <= hi);
	if (lo/8 < hi/8)
	{
		int i;
		set->bytes[lo/8] ^= msbmask[lo%8]; //[lo, x.7]��ȡ�� (ĳλȡ�����ڸ�λ��1���) 
		for (i = lo/8+1; i < hi/8; i++)
			set->bytes[i] ^= 0xFF;	  	   //�м������ֽھ�ȡ�� 
		set->bytes[hi/8] ^= lsbmask[hi%8]; //[x.0, hi]��ȡ�� 
	}
	else
		set->bytes[lo/8] ^= (msbmask[lo%8]&lsbmask[hi%8]);//һ���ֽ���[lo,hi]ȡ�� 
}

//��ÿһλʩ��apply���� 
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

//λ�������ϵĲ�������ȳ��������������

//�� 
Bit Bit_union(Bit s, Bit t)
{
	setop(copy(t), copy(t), copy(s), |)
}

//�� 
Bit Bit_inter(Bit s, Bit t)
{
	setop(copy(t),
	      Bit_new(t->length), Bit_new(s->length), &)
}

//�� 
Bit Bit_minus(Bit s, Bit t)
{
	setop(Bit_new(s->length),
	      Bit_new(t->length), copy(s), & ~)
}

//�ԳƲ� 
Bit Bit_diff(Bit s, Bit t)
{
	setop(Bit_new(s->length), copy(t), copy(s), ^)
}

