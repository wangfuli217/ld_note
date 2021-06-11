#include "atom.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <limits.h>

//字符串转为整形 
long str2int(char *str)
{
	unsigned long num = 0;
	int less = 0;
	char c;
	
	//第一位可能是负号或者是正数的第一个 
	c = *(str++);
	if(c == '-')
	{
		less = 1;
	}
	else
	{
		assert(isdigit(c));
		num = num * 10 + c -'0';
		
	}
	while(c = *(str++))
	{
		assert(isdigit(c));
		num = num * 10 + c -'0';
	}
	
	return less == 0 ? num : (0 - num);
}

//整形转为字符串 
char* int2str(long n)
{ 
	int length;
	char str[43];	    //long型最大位数
	char *p,*s = str + 43; //数组的最后一个元素下一个位置的指针 
	unsigned long m;
	
	//获得去掉符号后的数值 
	if (n == LONG_MIN)	//负数是二进制补码表示,
		m = LONG_MAX + 1UL;
	else if ( n < 0)
		m = -n;
	else
		m = n;
	
	do 
	{
		*--s = '0' + (m % 10);
	} while ((m /= 10) > 0);

	if (n < 0)
		*--s = '-';
	length = str + 43 - s;
	p = (char *)calloc(length + 1,sizeof(char));//多申请一个字节存放'\0' 
	memcpy(p,s,length);
	
	return p;
}

int main(void)
{
	
	char *str = int2str(LONG_MIN);
	printf("%d\n",str2int(str)); 
	printf("%s\n",int2str(str2int(str))); 
//	char *str = NULL;
//	char *str1 = NULL;
//	char *str2 = NULL;
//	char *str3 = NULL;
//	
//	
//	//三种初始化方式
//	str = Atom_string("HelloWorld");
//	str1 = Atom_new("HelloWorld", 3);
//	str2 = Atom_int(-898);
//	str3 = Atom_string("HelloWorld");//相同内容
//	
//	
//	printf("str: %s----%d\n", str, Atom_length(str));
//	printf("str1: %s----%d\n", str1, Atom_length(str1));
//	printf("str2: %s----%d\n", str2, Atom_length(str2));
//	
//	
//	//验证原子的唯一性
//	printf("%08x---%08x\n", str, str3);


	
	return 0;
}
