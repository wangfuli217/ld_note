//字符串存储形式之间的比较
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main(void)
{
	char *pc="hello";  //pc存储字符串的首地址，不能存内容，pc指向只读常量区,pc本身在栈区
	char str[]="hello"; //str[]存储字符串的内容，而不是地址，str指向栈区,str本身在栈区，将字符串内容拷贝一份到字符数组
	printf("字符串的地址:%p\n","hello");
	printf("数组的地址:%p\n",str);
	printf("---------------------------------------\n");
	//修改指向
	pc="1234";           //ok
//	str="1234";				//error
	//修改指向的内容
//	*pc='A';               //error
	str[0]='A';				//ok
	return 0;
}
