#include <stdio.h>
#include <stdlib.h>

unsigned int fit_block_size(unsigned int size)
{
	unsigned int i = 10;
	size = (size>>10);
	for(; size; i++, size = (size>>1));
	unsigned int j = 1 << (i < 10 ? 10 : i);
	return j;
}

void show8_11(int var)
{
	int num, mask;
	
	num = var;

	num >>= 8;           	 /*右移8位，将8～11位移到低4位上*/
	mask = ~ ( ~0 << 4);  	/*间接构造1个低4位为1、其余各位为0的整数*/
	printf("result=0x%x:mask:%d:num:%d\n", num & mask, mask, num);
}


void
swap(int x, int y)
{
	x ^= y;
	y ^= x;
	x ^= y;
	
	printf("x:%d:y:%d\n", x, y);
}

//获取1的个数
int Get1Nums(int i)
{
	int count = 0;
	int k = i;
	
	while(k)
	{
		count++;
		
		k &= (k - 1);
	}
	
	return count;
}

typedef unsigned char BYTE;

#pragma pack(push, 1)

typedef struct tagbits
{
	BYTE i:	1,
		i2:	1,
		i3:	1,
		i4:	1,
		i5: 1,
		i6:	1,
		i7:	1,
		i8: 1;
}bits;

struct bit
{
	unsigned a: 5,
			 b: 5;
};

struct bit2
{
	int a: 5;
	int b: 5;
	int c: 5;
};

struct bit3
{
	BYTE a: 5;
	BYTE b: 5;
	int c: 5;
};

struct bit4
{
	unsigned short i0: 2,
					i1: 3,
					i2: 4,
					i3: 5,
					:	2; // 无名段
};

#pragma pack(pop)

void opBits()
{
	bits b = {0};
	
	b.i = 1;
	b.i2 = 1;
	
	printf("b: 0x%x\n", b.i3);
}


//将int型变量a的第k + 1位清0，即a=a&~(1<<k), 0 by start

#define SetBitTo0(a, k)	(a)&~(1<<k)

// 将int型变量a的第k位置1， 即a=a|(1<<k)
#define SetBitTo1(a, k)	(a) | (1<<k)

#define average(x, y)	((x) & (y))+(((x) ^ (y))>>1)


#define lmove(a, b)	(a) << (b)
#define rmove(a, b)	(a) >> (b)

//变换符号
#define ABS(a) (~(a) + 1) 

//连接字符串,用于函数的格式化参数
//inttypes.h 定义了很多这种格式
#define PRIU32 "l" "u"

// 获取系统的字长
#define OS_BITS (((int)((int *)0 + 1)) << 3) 

/* int *p=NULL;       //0x00000000

    int *ptr = p + 1;  //0x00000004

    int res = (int)ptr; // 4

    int myres = res <<3; //32

关键就是 p+1 后，移动了4个字节。*/

//是否为2的幂 0: 是 非零不是
#define IS_2_N(a) ((a) & (a -1)) 
#define IS_2_N_2(a) (((a) & (~a + 1)) == (a))

//获取类型的最大值
#define MAX_INT ((int)(~(int)0) - 2) // 只能是unsigned的
#define MAX_SIZET	((size_t)(~(size_t)0)-2)

#define __MAX_SLOT__ 16833
 
int main(int argc, char **argv)
{
	show8_11(0x0A0C);
	
	swap(11, 22);

	opBits();
	
	int i = 12;
	
	i = SetBitTo0(i, 3);
	
	printf("i: %d\n", i);
	
	i = SetBitTo1(i, 3);
	
	printf("i: %d\n", i);
	
	printf("i: %d\n", average(i, i));
	
	int j = 1;
	
	j = lmove(j, 30);
	
	printf("j: %d\n", j);
	
	printf("sizeof: %d\n", sizeof(bit3));
	
	printf("1 : %d\n", Get1Nums(3));
	
	printf("size: %u\n", fit_block_size(1025));
	
	int aaa = 1;
	
	printf("change: %x\n", aaa);
	printf("change: %x\n", ABS(aaa));
	
	printf("qufan: %x\n", ~aaa);
	
	int bbb = -1;
	
	printf("bbb: %x\n", bbb);
	printf("bbb: %x\n", bbb << 2);
	printf("bbb: %x\n", bbb >> 2);
	
	
	unsigned int ccc = 100;
	
	printf("ccc: %" PRIU32 "\n", ccc);
	printf("PRIU32: %s\n", PRIU32);
	
	printf("MAX_INT: %u\n", MAX_INT);
	printf("MAX_INT: %zu\n", MAX_SIZET);
	
	printf("xxx: %d\n", 10 << 10); // 相当于 10 * 2的10幂
	
	long uid = 1499999999;  
	printf("slotId: %d\n", uid & __MAX_SLOT__);
	
	return 0;
}
