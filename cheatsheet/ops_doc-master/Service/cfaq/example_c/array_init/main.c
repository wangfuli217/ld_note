#include <stdio.h>

static int 
ArraySum(int a,int b ){
    return a+b;
}


int 
main(int argc, char **argv)
{
	char a[5] = {[0] = 'a', [1] = 'b', [3] = 'c', [2] = 'd', [4] = 'e'};

    int b[10] = {
        [0 ... 1] = 1,
        [2 ... 8] = 2,
        [9] = 3
    };
	
	char c[] = "12345678";
	char d[64] = {0};
	char e[10] = {'1', '2'};

	for (unsigned int idx = 0; idx < 10; idx++) {
		printf("%d\t", *(b + idx));
	}
	printf("\n");

	int *p = (int []){
		*(b+0)=1,
		[1]=(*(b+1)=ArraySum(1,0)),
        /*表达式中调用函数*/
	    [2]=*(b+2)=ArraySum(*(b+1),(*b)),
        /*数组值列表中的位置属性[e]可以省略*/
        (*(b+3)=(*(b+2)+*(b+1))),
        [4]=(*(b+4)=(*(b+3)+*(b+2))),
		[5]=(*(b+5)=(*(b+4)+*(b+3))),
		[6]=(*(b+6)=(*(b+5)+*(b+4)))
     };
	
	for (unsigned int i = 0;i < 7; i++) {
		printf("%d\t",*p++);
	}
	printf("\n");
	
	for (unsigned int idx = 0; idx < 10; idx++) {
		printf("%d\t", *(b + idx));
	}
	printf("\n");
	
	return 0;
}
