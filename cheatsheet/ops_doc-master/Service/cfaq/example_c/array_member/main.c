#include <stdio.h>
#include <stdlib.h>

//#pragma pack(push, 1)
struct test{
    int i;
    short c;
    char *p;
    char s[10];
} __attribute__((packed, aligned(1)));
//#pragma pack(pop)
 
int main(){
    struct test *pt=NULL;
    printf("&s = %x\n", pt->s); //等价于 printf("%x\n", &(pt->s) );
    printf("&i = %x\n", &pt->i); //因为操作符优先级，我没有写成&(pt->i)
    printf("&c = %x\n", &pt->c);
    printf("&p = %x\n", &pt->p);
	
	printf("sizeof: %d\n", sizeof(struct test));
	
	system("pause");
	
    return 0;
}