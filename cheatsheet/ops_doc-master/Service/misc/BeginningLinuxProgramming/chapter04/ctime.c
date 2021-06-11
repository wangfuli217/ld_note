#include <time.h>
#include <stdio.h>

int main(void)
{
    time_t timeval;

    (void)time(&timeval);
    printf("The date is: %s", ctime(&timeval));
    exit(0);
}
