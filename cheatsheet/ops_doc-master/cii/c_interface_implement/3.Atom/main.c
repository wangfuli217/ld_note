#include "atom.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <limits.h>

//�ַ���תΪ���� 
long str2int(char *str)
{
	unsigned long num = 0;
	int less = 0;
	char c;
	
	//��һλ�����Ǹ��Ż����������ĵ�һ�� 
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

//����תΪ�ַ��� 
char* int2str(long n)
{ 
	int length;
	char str[43];	    //long�����λ��
	char *p,*s = str + 43; //��������һ��Ԫ����һ��λ�õ�ָ�� 
	unsigned long m;
	
	//���ȥ�����ź����ֵ 
	if (n == LONG_MIN)	//�����Ƕ����Ʋ����ʾ,
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
	p = (char *)calloc(length + 1,sizeof(char));//������һ���ֽڴ��'\0' 
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
//	//���ֳ�ʼ����ʽ
//	str = Atom_string("HelloWorld");
//	str1 = Atom_new("HelloWorld", 3);
//	str2 = Atom_int(-898);
//	str3 = Atom_string("HelloWorld");//��ͬ����
//	
//	
//	printf("str: %s----%d\n", str, Atom_length(str));
//	printf("str1: %s----%d\n", str1, Atom_length(str1));
//	printf("str2: %s----%d\n", str2, Atom_length(str2));
//	
//	
//	//��֤ԭ�ӵ�Ψһ��
//	printf("%08x---%08x\n", str, str3);


	
	return 0;
}
