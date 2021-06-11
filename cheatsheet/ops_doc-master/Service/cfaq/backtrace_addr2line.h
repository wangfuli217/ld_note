#ifndef __FUNCTION_STACK_H__
#define __FUNCTION_STACK_H__

#define BACKTRACE_BUFFER_SIZE 256




/**
 *  使用方法：
 *      有以下两种方式，第二种方式稍显麻烦；
 *      1-调试时，只需要将下面的宏放到所需调试的函数内即可；
 *      2-使用GCC编译时，必须要使用 -rdynamic 选项；
 *      3-若使用G++进行编译，则在程序运行时使用c++filter过滤后查看函数修饰名，如：./a.out | c++filter
 *  
**/
#define CurrentFunctionStackDebug() \
        do {                        \
            CurrentFunctionStackInfoDebug(__FILE__, __LINE__, __FUNCTION__);  \
        } while(0)


/**
 *  
 *  注意：
 *      当调试函数时，需要手动添加以下头文件：
 *          #include<execinfo.h>
 *          #include<stdio.h>
 *          #include<stdlib.h>
 *          #include<unistd.h>
 **/
#define CurrentFunctionStackInfo() \
        do {                                         \
            void* btBuffer[BACKTRACE_BUFFER_SIZE];   \
            char** strings;           \
            int i = 0, nptrs;         \
            nptrs = backtrace(btBuffer, BACKTRACE_BUFFER_SIZE);   \
            printf("[%s:%d][%s]backtrace returned [[%d]] addresses:\n", __FILE__, __LINE__, __FUNCTION__, nptrs);  \
            strings = backtrace_symbols(btBuffer, nptrs);   \
            for(i = 0; i < nptrs; ++i)                      \
                printf("%s/n", strings[i]);                 \
        } while(0);



int CurrentFunctionStackInfoDebug(const char *file, int line, const char *function);



//当程序崩溃时，可以用此函数提取出所有线程的函数调用栈
//该函数只是注册几个捕获信号后的处理函数，可在程序启动时加入该函数；
int InitFunctionStack();





#endif  //__FUNCTION_STACK_H__