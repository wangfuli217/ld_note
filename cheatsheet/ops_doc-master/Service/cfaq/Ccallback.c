#include <stdio.h>
#include <assert.h>

int add(int a, int b){return a + b;}
int minus(int a, int b){return a - b;}
int multi(int a, int b){return a * b;}
int divi(int a, int b){return a / b;}

// void (*signal(int signum, void (*handler)(int))) (int);
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
//  typedef void (*sighandler_t)(int);
//  sighandler_t signal(int signum, sighandler_t handler);
// 或者定义typedef一个类型FUN来表示函数指针，增加可读性
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

#if 0
#include<stdio.h>  
   
void printWelcome(int len)  {  
    printf("welcome -- %d\n", len);  
}  
   
void printGoodbye(int len)  {  
    printf("byebye-- %d\n", len);  
}  
   
void callback(int times, void (* print)(int))  {  
    int i;  
    for (i = 0; i < times; ++i){  
        print(i);  
    }  
    printf("\n welcome or byebye !\n");  
}  
int main(void)  {  
    callback(10, printWelcome);  
    callback(10, printGoodbye);  
} 

#endif


#if 0
// call function -> return function
// 模式1
typedef int (*funcptr)();         /* generic function pointer */
typedef funcptr (*ptrfuncptr)();  /* ptr to fcn returning g.f.p. */

funcptr start(), stop();
funcptr state1(), state2(), state3();

void statemachine(){
	ptrfuncptr state = start;

	while(state != stop)
		state = (ptrfuncptr)(*state)();
}

funcptr start(){
	return (funcptr)state1;
}
#endif

#if 0
// call function -> return function
// 模式2
struct functhunk {
	struct functhunk (*func)();
};

struct functhunk start(), stop();
struct functhunk state1(), state2(), state3();

void statemachine()
{
	struct functhunk state = {start};

	while(state.func != stop)
		state = (*state.func)();
}

struct functhunk start()
{
	struct functhunk ret;
	ret.func = state1;
	return ret;
}
#endif

