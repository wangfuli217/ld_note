#include <stdio.h>
#include <term.h>
#include <ncurses.h>

///------------- �д���ѧϰ---------------------//

int main(void)
{
    setupterm("unlisted", fileno(stdout), (int *)0);
    printf("Done.\n");
    exit(0);
}
