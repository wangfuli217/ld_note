#include <stdio.h>

int main ()
{   
    void function (int n) 
    {
        printf("%d, hello\n", n);
    } 
    void hard ()
    {
        printf("All clear\n");
    }
    void sigfunc (int m)
    {
        printf("%d, ok\n", ++m);
    }
    void sigelse (int n)
    {
        printf("%d, wow\n", n);    
    }
    void (*signal(int n, void(*func)(int)))(int)
    {
        int m = 5;
        func(m);
        
        if (n == 1)
            return function;
        else
            return sigelse;   
    }
    
    typedef void (*funcptr)(int);
    (*(funcptr)&function)(4);
    
    void (*fp)(int);
    fp = &function;
    (*fp)(5);
        
    (* (void(*)())&hard) ();
    
    void(*f)(int);
    f = signal(2, sigfunc);
    f(4);    
    
    return 0;
}