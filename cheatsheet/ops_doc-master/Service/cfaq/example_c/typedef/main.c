#include <stdio.h>
#include <stdlib.h>

typedef int* int_a_t[10];
typedef int* (*int_a_p_t)[10];

typedef struct {
	int id;
} tag_t;

typedef struct tagg_s {
	int id;
} tagg_t;

typedef int function_t(int);
typedef int (*pFunction_t)(int);

static int
array_create(int_a_t** a)
{
	int_a_t *p;
    
    p = *a;
    printf("A: %p\n", p);
    printf("A: %p\n", *a);
    
    *a = malloc(sizeof(int_a_t)); /* 这里不能用临时变量赋值，必须使用 *a 的方式，否者不能正确赋值 */

    printf("A: %p\n", p);
    printf("A: %p\n", *a);

	
	return *a == NULL ? 1 : 0;
}


int 
main(int argc, char **argv)
{
	int_a_t a;
	
	int_a_t* p = &a;
	
	int** b = *p; /* *p 就是数组本身，&a == &a[0]  地址一样但是类型不相同 &a int*(*)[10]    &a[0] int**  所以这里可以进行转换*/
	
	int_a_t* pp;
	
	pp = NULL;
	
	if (array_create(&pp)) {
		printf("create failed.\n");
	} else {
        pp ? printf("NOT NULL.\n") : printf("NULL.\n");
        printf("create success.\n");
	}
	
    
    
	
	int** ii = *pp;
	
	int* (*ppp)[15];

	
	printf("ppp: %p\n", &ppp);

	system("pause");
	return 0;
}
