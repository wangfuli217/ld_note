#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <limits.h>

/* 对2的幂进行取余 */
#define mod_power_2(x, y) (x) & ((y) - 1)

/* 是否为2的幂 0: 是 */
#define is_power_2(x) (x) & ((x) - 1)

/* 按照alignment对齐 */
#define aligned(size, alignment) (size + alignment - 1) & (~(aligment - 1))

/* 按照 2的幂 取余 */
#define mod_power_2(m, mod) (m) & (mod - 1)

/* 符号取反 */
#define sign(a) (~(a) + 1)

// 设置第n位
#define set_bit(i, n) (i | (1 << n))

// 清除第n位
#define unset_bit(i, n) (i & ~(1 << n))

// 翻转第n位
#define reset_bit(i, n) (i ^ (1 << n))

/* 绝对值 */
#define _abs(a) ((a ^ (a >> 31)) - (a >> 31))

// 设置开关值 |
#define FL_SET(flag, value) flag |= value

// 判断是否已经设置开关值 
#define FL_IFSET(f, v) (f & v) 

// 移除开关
#define FL_DSET(f, v) flag &= ~newvalue

// 判断两个值是否相等
#define eq(a, b) !(a ^ b)

// 翻转特定位  第一 第二位
//10100001^00000110 = 10100111
#define rbit(a, n) a ^ (1 << n)

// 将某个变量清零
#define zero(a) a ^ a


/* base.h：基本操作的位运算实现 */  
#ifndef BASE_H  
#define BASE_H  
#define word   int  
#define uword  unsigned int  
/* 将最右侧的1位改成0位 */  
#define right1to0(x)  ((x)&((x)-1))  
/* 向右传播最右侧的1位 */  
#define right1torig(x)  ((x)|((x)-1))  
/* 将最右侧的连续1位串改成0位串 */  
#define right1sto0s(x)  (((x)|(x)-1)+1 & (x))  
/* 检查无符号整数x是否为2的幂，注意&的优先级低于==，需要括号 */  
#define powof2u(x)  (((x)&((x)-1))==0)  
/* 检查无符号整数x是否为2**n-1的形式 */  
#define pow2sub1u(x)  (((x)&((x)+1))==0)  
/* 检查无符号整数x是否为2**j-2**k形式 */  
#define pow2subpow2u(x)  ((((x)|(x)-1)+1 & (x))==0)  
  
/* 下列掩码直接析出字中指定的位 */  
/* 析出最右侧的1位 */  
#define right1(x)  ((x) & -(x))  
/* 析出最右侧的0位 */  
#define right0(x)  (~(x)&((x)+1))  
/* 析出后缀0 */  
#define suffix0(x)  (((x)&-(x))-1)  
/* 析出最右侧的1位和后缀0(即后缀10...0) */  
#define suffix10s0(x)  ((x) ^ (x)-1)  
/* 下列掩码与字做&运算，可以析出字中指定的字段 */  
/* 析出高阶n位(注意n的值不能大于int型的宽度) */  
#define high_ones(n) (-1<<32-(n))  
/* 析出低阶n位 */  
#define low_ones(n) (~(-1<<(n)))  
/* 析出低阶offset位和高阶32-offset-width位 */  
#define mid_zeros(width,offset)    \  
        (-1<<(width)+(offset) | ~(-1<<(offset)))      
/* 析出中间width位，它右侧有offset位 */  
#define mid_ones(width,offset)     \
        (~(-1<<(width)+(offset)) & (-1<<(offset)))  
  
/* 对无符号整数x，求比x大且与x中的位1个数相同的下一个整数： 
    例如对nnn0 1111 0000，则下一个整数为nnn1 0000 01111。 
    可以用这个函数来遍历一个集合的所有子集 */  
#define nextsame1u(x)  (right1(x)+(x) |      \  
      (((x)^right1(x)+(x))>>2)/right1(x))  
/* 字的绝对值函数：注意x>>31为0或-1，而x^0=x，x^-1=~x */  
#define abs(x)  (((x)^((x)>>31))-((x)>>31))  
/* 绝对值的负值 */  
#define nabs(x)  (((x)>>31)-((x)^((x)>>31)))   
/* 符号扩展：将第7位向左传播(位编号从0开始) */  
#define prop7thtolef(x)  ((((x) & 0x000000FF) ^ 0x00000080)-0x00000080)  
/* 对无符号整数实现算术右移：也可用更简单的((signed)(x)>>n) */  
#define arithrshiftu(x,n)  ((((x)^0x80000000)>>(n))-(0x80000000>>(n)))       
/* 对有符号整数实现逻辑右移：也可用更简单的((unsigned)(x)>>n) */  
#define logicrshift(x,n)  ((((x)^0x80000000)>>(n))+(1<<31-(n)))   
/* 符号函数：x>0返回1，x=0返回0，x<0返回-1 */  
#define sign(x)  (((x)>0)-((x)<0))  
/* 三值比较函数：x>y返回1，x=y返回0，x<y返回-1 */  
#define cmp(x,y)  (((x)>(y))-((x)<(y)))  
/*  符号传递函数：返回采用y的符号后的x */  
#define copysign(x,y)  ((abs(x)^((y)>>31))-((y)>>31))   
/* 比较谓词：带符号整数 */  
#define equal(x,y)     (~((x)-(y)|(y)-(x))>>31)  
#define noteq(x,y)     (((x)-(y)|(y)-(x))>>31)  
#define less(x,y)      ((((x)^(y)) & ((x)-(y)^(x)) ^ (x)-(y))>>31)  
#define larger(x,y)    ((((y)^(x)) & ((y)-(x)^(y)) ^ (y)-(x))>>31)  
#define lesseq(x,y)    ((((x)|~(y)) & ((x)^(y) | ~((y)-(x))))>>31)  
#define largereq(x,y)  ((((y)|~(x)) & ((y)^(x) | ~((x)-(y))))>>31)  
/* 比较谓词：无符号整数 */       
#define equalu(x,y)     (~((x)-(y)|(y)-(x))>>31)  
#define notequ(x,y)     (((x)-(y)|(y)-(x))>>31)  
#define lessu(x,y)      ((~(x) & (y) | ~((x)^(y)) & (x)-(y))>>31)  
#define largeru(x,y)    ((~(y) & (x) | ~((y)^(x)) & (y)-(x))>>31)  
#define lessequ(x,y)    (((~(x)|(y)) & (((x)^(y)) | ~((y)-(x))))>>31)  
#define largerequ(x,y)  (((~(y)|(x)) & (((y)^(x)) | ~((x)-(y))))>>31)  
/* 溢出检测：带符号运算 */  
#define addovf(x,y)  ((~((x)^(y))&(((x)+(y))^(x)))>>31)  
#define subovf(x,y)  ((((x)^(y))&(((x)-(y))^(x)))>>31)  
#define mulovf(x,y)  ((y)<0 && (x)==0x80000000 || (y)!=0 && (x)*(y)/(y)!=(x))  
#define divovf(x,y)  ((y)==0 || (x)==0x80000000 && (y)==-1)  
/* 溢出检测：无符号运算 */  
#define addovfu(x,y)  (~(x)<(y))  /* 也可用less(~(x),y) */  
#define subovfu(x,y)  ((x)<(y))   /* 也可用less(x,y) */  
#define mulovfu(x,y)  ((y)!=0 && (x) > 0xffffffff/(y))  
#define divovfu(x,y)  ((y)==0)  
/* 循环移位：带符号整数 */  
/* 循环左移n位 */  
#define rotlshift(x,n)  ((x)<<(n) | (unsigned)(x)>>32-(n))  
/* 循环右移n位 */  
#define rotrshift(x,n)  ((unsigned)(x)>>(n) | (x)<<32-(n))  
/* 循环移位：无符号整数 */  
#define rotlshiftu(x,n)  ((x)<<(n) | (x)>>32-(n))  
#define rotrshiftu(x,n)  ((x)>>(n) | (x)<<32-(n))  
/* 正差函数：x>=y时返回x-y，x<y时返回0。注意&优先级高于^，无需要括号 */  
#define doz(x,y)  ((x)-(y)&~((x)-(y)^((x)^(y))&((x)-(y)^(x)))>>31)  
/* 大值函数 */  
#define max(x,y)  ((y)+doz(x,y))  
/* 小值函数 */  
#define min(x,y)  ((x)-doz(x,y))  
/* 下面是无符号版本 */  
#define dozu(x,y)  ((x)-(y)& arithrshiftu(((x)|~(y))&((x)^(y)|~((x)-(y))) ,31))  
#define maxu(x,y)  ((y)+dozu(x,y))  
#define minu(x,y)  ((x)-dozu(x,y))  
/* 交换变量的值 */  
#define swap(x,y)      \  
    do { x=x^y; y=y^x; x=x^y; } while(0)  
/* 根据掩码来交换变量的相应字段： 
    当m的第i位为1时，交换x,y的第i位；当m的第i位为0时，保留x,y的第i位不变  */  
#define swapbits(x,y,m)     \  
    do { x=x^y; y=y^(x&(m)); x=x^y; } while(0)      
/* 2个常量的循环赋值：当x为a时赋值b，当x为b时赋值a */  
#define rottwo(x,a,b)  do{ x=(a)^(b)^x; }while(0)  
/* 3个常量的循环赋值 */  
#define rotthree(x,a,b,c)     \  
    do{ x=(-(x==c)&(a-c))+(-(x==a)&(b-c))+c; }while(0)  
#endif  

#define s2u32(x)    x ^ 0x80000000
#define s2u32_2(x)  x & 0x7FFFFFFF


static void
__fast_upper(char* str, size_t len)
{
	size_t l = len;
	
	int blocks = len / sizeof(long);
	
	printf("blocks: %d\n", blocks);
	
	for ( int i = 0; i < blocks; i++, l -= sizeof(long)) {
		*((unsigned long*)str + i) &= 0xdfdfdfdfdfdfdfd;
	}
	
	if (l) {
		*((unsigned long*)str + len - sizeof(long)) &= 0xdfdfdfdfdfdfdfd;
	}
	
	printf("UPPER: %s\n", str);
}

static char map[256] = {0};

static void
__fast_to_upper(char* str, int len)
{
	int i = 0;
	uint64_t* data = (uint64_t*)str;
	
	int blocks = len / sizeof(uint64_t);
	
	uint64_t src, a, b;
	
	for (; i < blocks; i++) {
		src = data[i] & 0x7f7f7f7f7f7f7f7f;
		a = src + 0x0505050505050505;
		b = src + 0x7f7f7f7f7f7f7f7f;
		a = a & b;
		a = a & (a >> 1) & 0x2020202020202020;
		data[i] -= a;
	}
	
	i *= sizeof(uint64_t);
	for (; i < len; i++) {
		str[i] = map[str[i]];
	}
}

static void
init_map() 
{
	int i = 0;
	for (; i < 256; i++) {
		if (i >= 'a' && i <= 'z') {
			map[i] = i - 32;
		} else {
			map[i] = i;
		}
	}
}

static inline void
prt_var_bin(const int x)
{
    for (int i = 31; i >= 0; i--) {
        if (x & (1 << i)) {
            printf("1");
        } else {
            printf("0");
        }
    }
    
    printf("\n");
}


int main(int argc, char **argv)
{
	
	char temp[] = "hello";
	
	init_map();
	
	__fast_to_upper(temp, sizeof temp - 1);
	
	printf("s: %s\n", temp);
	
	int i = -1;
	
	printf("abs: %d\n", _abs(i));
    
    int x = -1;
    prt_var_bin(x);
    printf("INT_MAX: %d\n", INT_MAX);
    prt_var_bin(s2u32(x));
    printf("x: %u\n", s2u32(x));
    printf("x: %u\n", s2u32_2(x));
	
	printf("x: %d\n", -1 & 0xffffffff);
	
	system("pause");
	return 0;
}
