#include <stdio.h>
#include <stdlib.h>

typedef struct {
	char *p;
} p_t;

int main(int argc, char **argv)
{
	char *p;
	
	p = 0x4;
	
	if (p) {
		printf("p is not full.\n");
	} else {
		printf("p is full.\n");
	}
	
	p_t* pp = NULL;
	
	if (pp->p) {
		printf("pp.p is not full.\n");
		
	} else {
		printf("pp.p is full.\n");
	}	
	
	int **ppp;
    int temp[10][10] = {0};
    
    ppp = (int**)&temp;
    
    
    printf("%p\n", *(int*)*((int*)ppp));
    
	system("pause");
	return 0;
}
