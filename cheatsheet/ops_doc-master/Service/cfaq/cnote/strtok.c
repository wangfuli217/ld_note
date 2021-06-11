#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    int toknum = 0;
    char src[] = "Hello,, world!";
    const char delimiters[] = ", !";
    char *token = strtok(src, delimiters);
    while (token != NULL)
    {
        printf("%d: [%s]\n", ++toknum, token);
        token = strtok(NULL, delimiters);
    }
    /* source is now "Hello\0, world\0\0" */


    char src1[] = "1.2,3.5,4.2";
    char *first = strtok(src1, ",");
    do
    {
        char *part;
        /* Nested calls to strtok do not work as desired */
        printf("[%s]\n", first);
        part = strtok(first, ".");
        while (part != NULL)
        {
            printf(" [%s]\n", part);
            part = strtok(NULL, ".");
        }
    } while ((first = strtok(NULL, ",")) != NULL);


    char src2[] = "1.2,3.5,4.2";  
    char *next = NULL;
    first = strtok_r(src2, ",", &next);
    do
    {
        char *part;
        char *posn;
        printf("[%s]\n", first);
        part = strtok_r(first, ".", &posn);
        while (part != NULL)
        {
            printf(" [%s]\n", part);
            part = strtok_r(NULL, ".", &posn);
        }
    }
    while ((first = strtok_r(NULL, ",", &next)) != NULL);

    return 0;
}
