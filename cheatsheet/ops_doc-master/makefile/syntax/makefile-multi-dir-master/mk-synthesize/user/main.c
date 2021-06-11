#include <stdio.h>
#include <foo.h>
#include <bar.h>
#include "app.h"
int main(void)
{
    printf("\n=========================================\n");
    printf("hello from %s()\n", __func__);
    hello_foo();
    hello_bar();
    app(99);
    //print_trace(11);
    return 0;
}

