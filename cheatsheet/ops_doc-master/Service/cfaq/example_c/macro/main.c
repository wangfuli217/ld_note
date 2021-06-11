#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <limits.h>

//#include <stdarg.h>

#define _sprintf(a)     \
	do { 				\
		printf(#a);		\
		printf("\n");	\	
	}while(0)			

#define FreeHandler(h) 	\
	delete h;         	\
	h = NULL;					//最后一行不需要 "\"				 	
		

#define _vprintf(format, ...) 		printf(format, __VA_ARGS__) // c99 __VA_ARGS__
#define _mprintf(format, args...) 	printf(format, ##args)
#define _mmprintf(format, ...) 		printf(format, args)   // 这种方式有问题

#define _vprintf2(format, args...) 	printf(format, args)	// c99 gcc
#define _mprintf_3(format, ...) 	printf(format, ##__VA_ARGS__) //添加##允许变参为空的调用

#define debug(fmt, ...)                    \
        printf("[DEBUG] %s:%d <%s>: " fmt, \
               __FILE__, __LINE__, __func__, ##__VA_ARGS__)

#define PRINT_VARNAME(v) #v


#define  ___ANONYMOUS1(type, var, line)  type  var##line
#define  __ANONYMOUS0(type, line)  ___ANONYMOUS1(type, _anonymous, line)
#define  ANONYMOUS(type)  __ANONYMOUS0(type, __LINE__)


#define  _GET_FILE_NAME(f)   #f
#define  GET_FILE_NAME(f)    _GET_FILE_NAME(f)
static char  FILE_NAME[] = GET_FILE_NAME(__FILE__);

/* 宏的名称重复判定是以宏的名称判定的name(x), name相同宏就重复： */
/* #define <宏名>（<参数表>） <宏体>
 * */
#ifdef _GET_FILE_NAME(f) /* _GET_FILE_NAME 也可以 */
#pragma message "_GET_FILE_NAME(f) defined"
#endif


#if  defined(_GET_FILE_NAME) /* _GET_FILE_NAME 也可以 */
#pragma message "_GET_FILE_NAME(f) defined"
#endif

#if defined _GET_FILE_NAME /* 不能带括号与参数的声明 */
#pragma message "_GET_FILE_NAME(f) defined"
#endif

#ifdef __STDC__
	#pragma message("__STDC__")
#endif

#ifdef __GNUC__
	#pragma message("__GNUC__")
#endif

#ifdef __LP64__
	#pragma message("__LP64__")
#endif

#ifdef __LP32__
	#pragma message("__LP32__")
#endif

#ifdef __WIN32
	#pragma message("__WIN32")
#endif

#ifdef __LINUX
	#pragma message("__LINUX")
#endif

#ifdef __WORDSIZE == 64
	#pragma message("__WORDSIZE")
#endif

#ifdef	__cplusplus
	extern "C" {
#endif

#ifdef __i386__
    #error __i386__
#endif

#ifdef __X86_64__
    #error __X86_64__
#endif

void show(int i)
{
	_vprintf2("%s:%d\n", "I", i);
}

#ifdef __cplusplus
	}
#endif

#define _offsetof(type, member) ((size_t)&(((type*)0)->member))


#define container_of(ptr, type, member) ( {                      \
        const typeof( ((type *)0)->member ) *__mptr = (ptr);     \
        (type *)( (char *)__mptr - _offsetof(type,member) );} )

#define plus_var(var, nums) var##nums

struct A
{
	int a;
	float b;
};

#define FILL(a)   {a, #a}

enum IDD
{
	OPEN, 
	CLOSE
};
 
typedef struct MSG{ 
	enum IDD id; 
	const char * msg; 
}MSG;


#define AA           (2) 
#define _STR(s)     #s 
#define STR(s)      _STR(s)          // 转换宏 
#define _CONS(a,b) int(a##e##b) 
#define CONS(a,b)   _CONS(a,b)       // 转换宏
 
 
#define atomic_inc(x) __sync_add_and_fetch((x),1)  
#define atomic_dec(x) __sync_sub_and_fetch((x),1)  
#define atomic_add(x,y) __sync_add_and_fetch((x),(y))  
#define atomic_sub(x,y) __sync_sub_and_fetch((x),(y)) 

//连接字符串,用于函数的格式化参数
//inttypes.h 定义了很多这种格式
#define PRIU32 "l" "u"

//double 2 long

union luai_Cast { double l_d; long l_l; };
#define lua_number2int(i,d) \
  { volatile union luai_Cast u; u.l_d = (d) + 6755399441055744.0; (i) = u.l_l; }
 
#define __T_MAX(t) ((t)(~((t)0))) /* 类型的最大值 unsigned 类型*/
/* int 类型的最大值 + 1  == 最小值 
 * int 类型的最小值 - 1 == 最大值
 * 
 * */

/* Test for polling API */
#ifdef __linux__
#define HAVE_EPOLL 1
#endif

#if defined(__APPLE__) || defined(__FreeBSD__) || defined(__OpenBSD__) || defined (__NetBSD__)
#define HAVE_KQUEUE 1
#endif

//#if !defined(HAVE_EPOLL) && !defined(HAVE_KQUEUE)
//#error "system does not support epoll or kqueue API"
//#endif
/* ! Test for polling API */


#define ACCESS_ONCE(x) (* (volatile typeof(x) *) &(x))

#define XX(n) ({ \
	int i = 10;		\
	n + i;			\
})

int main(int argc, char **argv)
{
	show(1);	
	
	struct A sa;
	
	printf("offset: %d\n", _offsetof(struct A, b));
	
	struct A* pa = container_of(&(sa.b), struct A, b);
	
	pa->a = 10;
		
	int iii = 0;
	
	printf("VarName: %s\n", PRINT_VARNAME(iii));
	
	printf("ANONYMOUS: %s\n", GET_FILE_NAME(__FILE__));
	
	_sprintf(iii);

	printf("D:%d\n", __LOG_LEVEL__); // 编译参数中 -D
	
	int x1, x2;
	
	x1 = x2 = 10;
	
	printf("x: %d\n", plus_var(x, 1));
	
	MSG _msg[] = { FILL(OPEN), FILL(CLOSE) }; 
	
	printf("int max: %s\n", STR(INT_MAX)); 
	
	
	unsigned int ccc = 100;
	
	printf("ccc: %" PRIU32 "\n", ccc);
	printf("PRIU32: %s\n", PRIU32);	
	
	
	double dd = 1000.2323;
	int k;
	
	lua_number2int(k, dd);
	
	printf("K: %d\n", k);
	
	printf("unsigned int_max: %u\n", __T_MAX(unsigned int));
	printf("unsigned int_max: %u\n", UINT_MAX);
	printf("int_max: %d\n", __T_MAX(int));
	
	
	printf("XX: %d\n", XX(10));
	return 0;
}
