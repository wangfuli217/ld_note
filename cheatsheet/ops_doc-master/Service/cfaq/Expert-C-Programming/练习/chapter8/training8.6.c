#include <stdio.h>

int foo();//K&R C
int foo1(int a,int b);//ANSI C
//int foo1(int, int);//ANSI C
int main()
{
    int x=1,y=2;
    foo(x,y);
    foo1(x,y);
}

//K&R C
int foo(a, b)
int a;
int b;
{
    printf("%d %d\n",a,b);
    return 0;
}

//ANSI C
int foo1(int a,int b)
{
    printf("%d %d\n",a,b);
    return 0;
}
