#include <stdio.h>
#include "foo.h"
#include "commonbar.h"
void bar(int i)
{
printf("hell from %s() in file: %s, num:%d\n", __func__, __FILE__, i);
}

int hello_bar(void)
{
printf("in func: %s()\n", __func__);
foo(200);
common_bar();
printf("=========================================\n");
return 0;
}
