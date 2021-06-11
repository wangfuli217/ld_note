/* 
*  gcc backtrace.c -o backtrace  -rdynamic 
*  ./backtrace
*  �����ʱ��������Ҫ���� -rdynamic ѡ�����Ļ������ű���Ϣ��ӡ��������*  http://www.acsu.buffalo.edu/~charngda/backtrace.html ��ǿ���Ƽ���
*/

#include <execinfo.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

void do_gnu_backtrace()
{
#define BACKTRACE_SIZ 100
    void *array[BACKTRACE_SIZ];
    size_t size, i;
    char **strings;

    size = backtrace(array, BACKTRACE_SIZ);
    strings = backtrace_symbols(array, size);

    for (i = 0; i < size; ++i) {
        printf("%p : %s\n", array[i], strings[i]);
    }

    printf("---------------------------------------------------------\n");
    free(strings);
}

int foo()
{
    do_gnu_backtrace();
}
int bar( void )
{
    foo();
    return 0;
}
int boo( void )
{
    bar();
    return 0;
}
int baz( void )
{
    boo();
    return 0;
}
int main( void )
{
    baz();
    return 0;
}