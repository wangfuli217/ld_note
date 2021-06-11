#include <stdio.h>
#include "bar.h"
#include "commonfoo.h"

void foo(int i)
{
printf("hell from %s() in file: %s, num:%d\n", __func__, __FILE__, i);
}
void hello_foo(void)
{
printf("in func: %s()\n", __func__);
bar(100);
common_foo();
printf("=========================================\n");
//return 0;
}
