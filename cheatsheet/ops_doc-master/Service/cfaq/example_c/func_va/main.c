#include <stdio.h>  
#include <string.h>   
#include <stdarg.h>  
#include <stdlib.h>
#include <stdint.h>

#define __va_rounded_size(TYPE)  \
	(((sizeof (TYPE) + sizeof (long) - 1) / ~(sizeof(long) - 1)))


/* ANSI标准形式的声明方式，括号内的省略号表示可选参数 */    
  
int demo(char *msg, ... )    
{    
    va_list argp;             /* 定义保存函数参数的结构 */    
    int argno = 0;                  /* 纪录参数个数 */    
    char *para;                     /* 存放取出的字符串参数 */    
      
                                    /* argp指向传入的第一个可选参数，    msg是最后一个确定的参数 */    
    va_start( argp, msg );    
      
    while (1)   
    {    
        para = va_arg(argp, char *);                 /*    取出当前的参数，类型为char *. */    
        if ( strcmp( para, "\0") == 0 )    
                                                      /* 采用空串指示参数输入结束 */    
            break;    
        printf("Parameter #%d is: %s\n", argno, para);    
        argno++;    
    }    
    va_end( argp );                                   /* 将argp置为NULL */    
    return 0;    
}  
  
void
demo_2(const char* fmt, ...) /* int char float */
{

	char* ap = (char*)(&fmt + 1);
	printf("a:%d\n", *(int*)ap);
	
	ap += sizeof(int) + __va_rounded_size(int);
	printf("b:%c\n", *ap);
	
	ap += sizeof(int) + __va_rounded_size(int); /*  char 类型提升到整型 */
	
	printf("c:%f\n", *(double*)ap);
} 
 
typedef char* va_list_t;

#define va_start_a(ap,v) ( ap = (va_list_t)&v + _INTSIZEOF(v) )           //第一个可选参数地址
#define va_arg_a(ap,t) (*(t *)((ap += _INTSIZEOF(t)) - _INTSIZEOF(t)))   //下一个参数地址 这里是将ap指向下一个参数的地址，通过 - _INTSIZEOF(t) 获取当前参数的地址
#define va_end_a(ap)    (ap = (va_list_t)0)                              // 将指针置为无效
#define _INTSIZEOF(n) ((sizeof(n)+sizeof(int)-1)&~(sizeof(int) - 1) ) 
 
 
void 
demo_3(const char* fmt, ...) /* int char float uint64_t */
{
	va_list_t ap;
	
	va_start_a(ap, fmt);
	
	int i = va_arg_a(ap, int); /* 这里ap已经指向char类型参数的地址了。 */
	printf("i: %d\n", i);
	
	char c = va_arg_a(ap, int); /* 这里ap已经指向float类型参数的地址了。 */
	printf("c: %c\n", c);
	
	float f = va_arg_a(ap, double);
	printf("f: %f\n", f);
	
	uint64_t ll = va_arg_a(ap, uint64_t);
	printf("ll: %llu\n", ll);
	
	va_end_a(ap);
}


 
int 
main(int arg, char** argv)    
{    
	demo("DEMO", "This", "is", "a", "demo!" ,"333333", "\0");
	
	int i = 100;
	char c = 'a';
	float f = 999.32f;
	uint64_t ll = 10000000000000;
	
	demo_2("icf", i, c, f);
	
	demo_3("icf", i, c, f, ll);
	
	return 0;
}    