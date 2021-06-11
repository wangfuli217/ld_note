#include <stdlib.h>
#include <stdio.h>

/*system和execl不一样的在于，system执行以后，自动回到原先的程序空间中。
system 不会自己开程序空间，而是像函数一样执行一下程序。
然而，execl就不一样了，它会将别人的空间看做自己的空间，且
不会执行以后的程序代码*/
int main(void)
{
    printf("Running ps with system\n");
    system("ps -ax");
    printf("Done.\n");
    exit(0);
}

