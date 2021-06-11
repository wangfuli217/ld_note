#include <stdio.h>

int function(void) 
{
    static int i, state = 0;
    switch (state) {
        case 0: /* start of function */
        for (i = 0; i < 10; i++) {
            state = 1; /* so we will come back to "case 1" */
            return i;
            case 1:; /* resume control straight after the return */
        }
    }
}

int function_1(void) 
{
    static int i, state = 0;
    switch (state) {
        case 0: /* start of function */
        for (i = 0; i < 10; i++) {
            state = __LINE__ + 2; /* so we will come back to "case __LINE__" */
            return i;
            case __LINE__:; /* resume control straight after the return */
        }
    }
}


int 
main(int argc, char **argv)
{
    printf("I: %d\n", function());
    printf("I: %d\n", function());
    
    printf("I: %d\n", function_1());
    printf("I: %d\n", function_1());
    printf("I: %d\n", function_1());
    
    system("pause");
	return 0;
}
