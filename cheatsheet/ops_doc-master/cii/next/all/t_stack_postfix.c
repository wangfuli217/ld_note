#include<string.h>
#include<stdio.h>
#include<stdint.h>
#include"stack.h"


int
main(int argc, char *argv[])
{
    int i, N;
    char *arg;
    stack_t stack;

    arg = argv[1];
    N   = strlen(arg);

    stack = stack_new();

    printf("read postfix set length:%d\n", N);
    
    for(i = 0; i < N; i++){

        printf("i:%d, <%c>\n", i, arg[i]);

        if('+' == arg[i] ||
           '*' == arg[i] ||
           '-' == arg[i] ||
           '/' == arg[i]){

            int64_t a = (int64_t)stack_pop(stack);
            int64_t b = (int64_t)stack_pop(stack);
            int64_t c;

            if('+' == arg[i]){
                c = a + b;
            }else if('-' == arg[i]){
                c = a - b; 
            }else if('*' == arg[i]){
                c = a * b;
            }else{
                c = a / b;
            }
            printf("a:%ld, b:%ld, c:%ld, push\n", a, b, c);
            stack_push(stack, (void *)c);
        }

        if(arg[i] >= '0' && arg[i] <= '9'){
            stack_push(stack, (void *)0);
            printf("push --- 0\n");
        }
        while(arg[i] >= '0' && arg[i] <= '9'){
            int64_t prev = (int64_t)stack_pop(stack);
            int64_t now = 10 * prev + (arg[i++] - '0');

            printf("prev:%ld, now:%ld, push\n", prev, now);
            stack_push(stack, (void *) now);
        }
    }

    printf("%ld \n", (int64_t)stack_pop(stack));
    return 0;
}
