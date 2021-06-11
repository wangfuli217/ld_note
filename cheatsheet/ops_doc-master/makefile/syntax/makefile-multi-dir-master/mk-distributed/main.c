#include <stdio.h>
#include <foo.h>
#include <bar.h>
int main(void)
{
    printf("hello from %s()\n", __func__);
    hello_foo();
    hello_bar();
    //print_trace(11);
    return 0;
}
