stdio_unlocked()
{
#include <stdio.h>

int getc_unlocked(FILE *stream);
int getchar_unlocked(void);
int putc_unlocked(int c, FILE *stream);
int putchar_unlocked(int c);

void clearerr_unlocked(FILE *stream);
int feof_unlocked(FILE *stream);
int ferror_unlocked(FILE *stream);
int fileno_unlocked(FILE *stream);
int fflush_unlocked(FILE *stream);
int fgetc_unlocked(FILE *stream);
int fputc_unlocked(int c, FILE *stream);
size_t fread_unlocked(void *ptr, size_t size, size_t n,
                      FILE *stream);
size_t fwrite_unlocked(const void *ptr, size_t size, size_t n,
                      FILE *stream);

char *fgets_unlocked(char *s, int n, FILE *stream);
int fputs_unlocked(const char *s, FILE *stream);

#include <wchar.h>

wint_t getwc_unlocked(FILE *stream);
wint_t getwchar_unlocked(void);
wint_t fgetwc_unlocked(FILE *stream);
wint_t fputwc_unlocked(wchar_t wc, FILE *stream);
wint_t putwc_unlocked(wchar_t wc, FILE *stream);
wint_t putwchar_unlocked(wchar_t wc);
wchar_t *fgetws_unlocked(wchar_t *ws, int n, FILE *stream);
int fputws_unlocked(const wchar_t *ws, FILE *stream);
}

pthread(重入问题)
{

传统的UNIX没有太多考虑线程问题，库函数里过多使用了全局和静态数据，导致严重的线程重入问题。
1.1 –D_REENTRANT /-pthread和errno的重入问题。
    首先UNIX的系统调用被设计为出错返回-1，把错误码放在errno中（更简单而直接的方法应该是程序直接返回错误码，
或者通过几个参数指针来返回）。由于线程共享所有的数据区，而errno是一个全局的变量，这里产生了最糟糕的线程重
入问题。比如：
do {
    bytes = recv(netfd, recvbuf, buflen, 0);
} while (bytes != -1 && errno != EINTR);

在上面的处理recv被信号打断的程序里。如果这时连接被关闭，此时errno应该不等于EINTR，如果别的线程正好设置errno
为EINTR，这时程序就可能进入死循环。其它的错误码处理也可能进入不可预测的分支。

    在线程需求刚开始时，很多方面技术和标准（TLS）还不够成熟，所以在为了解决这个重入问题引入了一个解决方案，
把errno定义为一个宏：
extern int *__errno_location (void);
#define errno (*__errno_location())

在上面的方案里，访问errno之前先调用__errno_location()函数，线程库提供这个函数，不同线程返回各自errno的地址，
从而解决这个重入问题。在编译时加-D_REENTRANT就是启用上面的宏，避免errno重入。另外-D_REENTRANT还影响一些stdio
的函数。在较高版本的gcc里，有很多嵌入函数的优化，比如把

printf("Hello\n");
优化为
puts("hello\n");

之类的，有些优化在多线程下有问题。所以gcc引入了 –pthread 参数，这个参数出了-D_REENTRANT外，还校正一些针对
多线程的优化。

    因为宏是编译时确定的，所以没有加-D_REENTRANT编译的程序和库都有errno重入问题，原则上都不能在线程环境下使用。
不过在一般实现上主线程是直接使用全局errno变量的，也就是 __errno_location()返回值为全局&errno，所以那些没加
-D_REENTRANT编译的库可以在主线程里使用。这里仅限于主线程，有其它且只有一个固定子线程使用也不行，因为子线程使用
的errno地址不是全局errno变量地址。

    对于一个纯算法的库，不涉及到errno和stdio等等，有时不加_REENTRANT也是安全的，比如一个纯粹的加密/解谜函数库。
比较简单的判断一个库是否有errno问题是看看这个库是使用了errno还是__errno_location()：
readelf -s libxxx.so | grep errno
另外一个和errno类似的变量是DNS解析里用到的h_errno变量，这个变量的重入和处理与errno一样。这个h_errno用于
gethostbyXX这个系列的函数。


}

libc(库函数重入)
{
早期很多unix函数设计成返回静态buffer。这些函数都是不能重入的。识别这些函数有几个简单的规则：
    stdio函数是可以重入的。这是因为stdio函数入口都会调用flockfile()锁定FILE。另外stdio也提供不锁定（非重入）
的函数，这些函数以_unlock结尾，具体参见man unlocked_stdio。利用这些特性可以做到多个stdio的互斥操作。如：
flockfile(fp)
fwrite_unlocked(rec1, reclen1, 1, fp);
fwrite_unlocked(rec2, reclen2, 1, fp);
funlockfile(fp);

    返回动态分配数据的函数，这些一般是可以重入的。这些函数的特点是返回的指针需要显式释放，用free或者配对的
释放函数。如：
getaddrinfo /freeaddrinfo
malloc/strdup/calloc/free
fopen/fdopen/popen/fclose
get_current_dir_name/free
asprintf/vasprintf/free
getline/getdelim/free
regcomp/regfree

    函数返回一个和输入参数无关的数据，而且不需要free的大部分情况下是不可重入的。如gmtime, ntoa, gethostbyname
    函数依赖一个全局数据，在多次或者多个函数间维护状态的函数是不可重入的。如getpwent, rand…
    带有_r变体的函数都是不可重入的。这些函数大部分是上面两类的。这些变体函数是可重入的代替版本。可以用下面命令查看glibc有多少这种函数：
readelf -s /lib/libc.so.6  | grep _r@
这些函数名有很大一部分是
getXXbyYY, getXXid, getXXent, getXXnam
    rand，lrand48系列随机数不可重入的原因在于这些函数使用一个全局的状态，并且都有相应的_r变体。重入这些非线程
安全的函数不会有稳定性问题，不过会导致随机数不随机（可预测）。在要求比较严格的随机数应用里，建议用/dev/random和
/dev/urandom，这两个设备的不同在于前者读出的数据理论上是绝对随机的，在系统无法提供足够随机数据时读会阻塞。后者
只是提供尽量随即的数据，随机度不够时用算法生成伪随机数来代替，所以不会阻塞。
    不可重入函数处理。对大部分不可重入函数可以使用对应的_r变体。有些函数可能没有对应_r变体，可以选用类似功能的函数替换。如
inet_ntoa à inet_ntop
ctime à strftime, asctime, localtime_r+sprintf
gethostbyname, getservbyname à getaddrinfo

}


pthread(-D_REENTRANT 宏作用)
{
    在一个多线程程序里，默认情况下，只有一个errno变量供所有的线程共享。在一个线程准备获取刚才的错误代码时，该变量
很容易被另一个线程中的函数调用所改变。类似的问题还存在于fputs之类的函数中，这些函数通常用一个单独的全局性区域来缓
存输出数据。
    为解决这个问题，需要使用可重入的例程。可重入代码可以被多次调用而仍然工作正常。编写的多线程程序，通过定义宏
_REENTRANT来告诉编译器我们需要可重入功能，这个宏的定义必须出现于程序中的任何#include语句之前。

_REENTRANT为我们做三件事情，并且做的非常优雅：
（1）它会对部分函数重新定义它们的可安全重入的版本，这些函数名字一般不会发生改变，只是会在函数名后面添加_r字符串，
     如函数名gethostbyname变成gethostbyname_r。
（2）stdio.h中原来以宏的形式实现的一些函数将变成可安全重入函数。
（3）在error.h中定义的变量error现在将成为一个函数调用，它能够以一种安全的多线程方式来获取真正的errno的值

但是, 该_REENTRANT宏是必须的吗？在编译的时候可以省略它吗?
答案是可以的,在编译时使用-pthread等价于–D_REENTRANT –lpthread。
}

pthread(Reentrant和Thread-safe)
{
    在单线程程序中，整个程序都是顺序执行的，一个函数在同一时刻只能被一个函数调用，但在多线程中，由于并发性，一个函数可能
同时被多个函数调用，此时这个函数就成了临界资源，很容易造成调用函数处理结果的相互影响，如果一个函数在多线程并发的环境中每
次被调用产生的结果是不确定的，我们就说这个函数是"不可重入的"/"线程不安全"的。为了解决这个问题，POSIX多线程库提出了一种
机制，用来解决多线程环境中的线程数据私有化问题，这套机制的主要思想是利用同步和互斥维护一个同名不同值的表，这个表会维护
每个线程自己的资源地址，表面上是同一个变量，实质上这个变量在不同的线程中的地址是不一样，这样就保证了每个线程其实都在使用
自己的资源，实现了"thread-safe"。

模型

如果要查看这些函数的man手册，可以安装相关的man手册

pthread_key_t key           //创建用于保护线程私有资源的key
pthread_once_t once_key     //创建用于初始化key的once_key,要求用PTHREAD_INIT_ONCE来赋值，否则结果不确定
pthread_key_create()        //创建key
pthread_once()              //初始化key
pthread_getspedifc()        //从key表中获得线程私有资源的地址
pthread_setspedifc()        //将线程私有资源的地址放到key中

}

#include<stdio.h>
#include<pthread.h>
#include<stdlib.h>
#include<string.h>
pthread_key_t key;
pthread_once_t once_key=PTHREAD_ONCE_INIT;
#ifdef _REENTRANT
void myDestructor(void*p){
    free(p);
}
void myCreateKey(void){
    //创建key
    pthread_key_create(&key,myDestructor);
}
#endif
char* reverse(char* buf,int len){
#ifdef _REENTRANT
    //初始化key
    pthread_once(&once_key,myCreateKey);

    //从key中获取一个thread-specific的数据
    char* rev=(char*)pthread_getspecific(key);
    if(NULL==rev){
        rev=(char*)malloc(len+1);
        //将thread-specific的数据放到key中
        pthread_setspecific(key,rev);
    }
#else
    static char rev[100];
#endif
    bzero(rev,sizeof(rev));
    //翻转buf
    while(len--)
        rev[len]=*buf++;
    return rev;
}

void* fcn1(void* p){
    while(1){
        char buf[100]="123456789";
        printf("[%lu]:%s\n",pthread_self(),buf);
        char* rev=reverse(buf,strlen(buf));
        sleep(1);
        printf("[%lu]:%s\n",pthread_self(),rev);
    }
}

void* fcn2(void* p){
    while(1){
        char buf[100]="abcdef";
        printf("[%lu]:%s\n",pthread_self(),buf);
        char* rev=reverse(buf,strlen(buf));
        sleep(2);
        printf("[%lu]:%s\n",pthread_self(),rev);

    }
}

int main(int argc, const char *argv[])
{
    pthread_t tid[4];
    pthread_create(&tid[0],NULL,fcn1,NULL);
    pthread_create(&tid[1],NULL,fcn2,NULL);
    pause();
    return 0;
}
    

