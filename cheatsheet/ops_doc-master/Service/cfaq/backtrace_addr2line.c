///Linux中共提供了三个函数用于打印调用堆栈：
/**
* int backtrace(void **buffer, int size);
* 函数说明：获取当前函数的调用栈信息，结果存储在buffer中，返回值为栈的深度，参数size限制栈的最大深度，即最大取size步的栈信息。
* 参数：
*     buffer：用于存储函数地址的数组
*     size：buffer数组的长度
* 返回值：
*      存储到数组中的函数个数
*/
/**
* char **backtrace_symbols(void *const *buffer, int size);
* 函数说明：把backtrace函数获取的栈信息(一组函数地址)转化为字符串，以字符指针数组的形式返回，参数size限定转换的深度，一般用backtrace调用的返回值.
* 参数:
*      buffer: 经由backtrace得到的函数地址
*      size: buffer数组的长度
* 返回值:
*       函数在系统中对应用字符串
*/
/**
* void backtrace_symbols_fd(void *const *buffer, int size, int fd);
* 函数说明：它的功能和backtrace_symbols函数差不多，只不过它不把转换结果返回给调用方，而是写入fd指定的文件描述符；
* 参数:
*      buffer: 经由backtrace得到的函数地址
*      size: buffer数组的长度
*      fd: 输出结果文件描述符
*/


/**
 *  
 *  在linux应用程序调试中，使用的方法，可以在函数中加入如下代码：
        void *bt[128]; 
        char **strings; 
        size_t nptrs;
        nptrs = backtrace(bt, 128); 
        strings = backtrace_symbols(bt, nptrs); 
        for(i = 0; i < nptrs; ++i) 
            fprintf(stderr, "%s/n", strings[i]);
 *  
 **/

/**
 *  
 *  编译方法：gcc -o funstack -rdynamic  functionstack.c
 *  使用方法：
 *      有以下两种方式，第二种方式稍显麻烦；
 *      1-调试时，只需要将下面的宏放到所需调试的函数内即可；
 *      2-使用GCC编译时，必须要使用 -rdynamic -g 选项；-rdynamic 的主要作用是让链接器把所有的符号都加入到动态符号表中，
 *      3-若使用G++进行编译，则在程序运行时使用c++filter过滤后查看函数修饰名，如：./a.out | c++filter
 *  
 **/

#include <execinfo.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <stddef.h>
#include <string.h>

#include "backtrace_addr2line.h"



int CurrentFunctionStackInfoDebug(const char *file, int line, const char *function)
{
   int  j = 0, nptrs;
   void *buffer[BACKTRACE_BUFFER_SIZE];
   char **strings;
   
   printf("[%s:%d][%s]\n", (strchr(file, '/') ?  (strchr(file, '/') + 1) : file), line, function);
   
   nptrs = backtrace(buffer, BACKTRACE_BUFFER_SIZE);
   printf("backtrace returned [[%d]] addresses:\n", nptrs);
   
   /* The call backtrace_symbols_fd(buffer, nptrs, STDOUT_FILENO)
    *  would produce similar output to the following: */
   strings = backtrace_symbols(buffer, nptrs);
   if (strings == NULL) {
       perror("backtrace_symbols. \n");
       exit(EXIT_FAILURE);
   }
 
   for (j = 0; j < nptrs; j++)
       printf("line<%d> %s\n", j, strings[j]);
   
   
   free(strings);
   strings = NULL;
   
   return 0;
}


static char gfileBuf[256] = {0};
static int glineNumber = 0;
static char gfuncBuf[64] = {0};
static void CatchSignalHandler(int signum) 
{
    printf("[%s:%d][%s]\n", (strchr(gfileBuf, '/') ?  (strchr(gfileBuf, '/') + 1) : gfileBuf), glineNumber, gfuncBuf);
    
    signal(signum, SIG_DFL);
    CurrentFunctionStackInfoDebug(gfileBuf, glineNumber, gfuncBuf);
    
    return ;
}


int InitFunctionStack() 
{
    printf("[%s:%d][%s]\n", (strchr(gfileBuf, '/') ?  (strchr(gfileBuf, '/') + 1) : gfileBuf), glineNumber, gfuncBuf);
    
    //注册 信号的处理函数,各种信号的定义见http://www.kernel.org/doc/man-pages/online/pages/man7/signal.7.html
    if (signal(SIGSEGV, CatchSignalHandler) == SIG_ERR) // SIGSEGV      11       Core    Invalid memory reference
        perror("can't catch SIGSEGV");
    if (signal(SIGABRT, CatchSignalHandler) == SIG_ERR) // SIGABRT       6       Core    Abort signal from
        perror("can't catch SIGABRT");

    return 0;
}



void print_trace(void)   
{   
    int i;   
    const int MAX_CALLSTACK_DEPTH = 32;    /* 需要打印堆栈的最大深度 */  
    void *traceback[MAX_CALLSTACK_DEPTH];  /* 用来存储调用堆栈中的地址 */  
    
    
    /* 利用 addr2line 命令可以打印出一个函数地址所在的源代码位置   
     * 调用格式为： addr2line -f -e /tmp/a.out 0x400618  
     * 使用前，源代码编译时要加上 -rdynamic -g 选项  
     */  
    char cmd[512] = "addr2line -f -e ";   
    char *prog = cmd + strlen(cmd);   
    
    /* 得到当前可执行程序的路径和文件名 */  
    int r = readlink("/proc/self/exe", prog, sizeof(cmd) - (prog - cmd) - 1);   
    
    /* popen会fork出一个子进程来调用/bin/sh, 并执行cmd字符串中的命令，  
     * 同时，会创建一个管道，由于参数是'w', 管道将与标准输入相连接，  
     * 并返回一个FILE的指针fp指向所创建的管道，以后只要用fp往管理里写任何内容，  
     * 内容都会被送往到标准输入，  
     * 在下面的代码中，会将调用堆栈中的函数地址写入管道中，  
     * addr2line程序会从标准输入中得到该函数地址，然后根据地址打印出源代码位置和函数名。  
     */  
    FILE *fp = popen(cmd, "w");   
    
    /* 得到当前调用堆栈中的所有函数地址，放到traceback数组中 */  
    int depth = backtrace(traceback, MAX_CALLSTACK_DEPTH);   
    for (i = 0; i < depth; i++) {   
        /* 得到调用堆栈中的函数的地址，然后将地址发送给 addr2line */  
        fprintf(fp, "%p\n", traceback[i]);   
        /* addr2line 命令在收到地址后，会将函数地址所在的源代码位置打印到标准输出 */  
    }   
    
    fclose(fp);   
    return ;
}
