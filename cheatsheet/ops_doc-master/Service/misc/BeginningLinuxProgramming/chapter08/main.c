/* main.c */
#include <stdio.h>
#include <stdlib.h>
#include "a.h"
#define EXIT_SUCCESS 0

extern void function_two(void);
extern void function_three(void);

int main(void)
{
    function_two();
    function_three();
    exit (EXIT_SUCCESS);
}
