#include <stdio.h>
#include <assert.h>

int add(int a, int b){return a + b;}
int minus(int a, int b){return a - b;}
int multi(int a, int b){return a * b;}
int divi(int a, int b){return a / b;}

int (*route_fn(char operator))(int, int){
    static int(*funs[])(int, int) = {add, minus, multi, divi};
    static char operators[] = {'+', '-',   '*',   '/'};
    int i = 0;
    while(operators[i] != operator) i++;
    assert(i<4);
    return funs[i];
}
int main(void){
    printf("%d\n", route_fn('+')(10,20));
    return 0;
}

#if 0
#include <stdio.h>
#include <assert.h>

int add(int a, int b){return a + b;}
int minus(int a, int b){return a - b;}
int multi(int a, int b){return a * b;}
int divi(int a, int b){return a / b;}

typedef int(*FUN)(int, int);

FUN route_fn(char operator){
    static FUN funs[] = {add, minus, multi, divi};
    static char operators[] = {'+', '-',   '*',   '/'};
    int i = 0;
    while(operators[i] != operator) i++;
    assert(i<4);
    return funs[i];
}
int main(void){
    printf("%d\n", route_fn('+')(10,20));
    return 0;
}
#endif