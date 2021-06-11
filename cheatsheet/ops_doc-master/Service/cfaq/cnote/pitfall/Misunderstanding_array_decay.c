#include <stdio.h>
/*
 * Note the rearranged parameters and the change in the parameter name
 * from the previous definitions:
 *      n (number of strings)
 *   => scount (string count)
 *
 * Of course, you could also use one of the following highly recommended forms
 * for the `strings` parameter instead:
 *
 *    char strings[scount][ccount]
 *    char strings[][ccount]
 */
void print_strings(size_t scount, size_t ccount, char (*strings)[ccount])
{
    size_t i;
    for (i = 0; i < scount; i++)
        puts(strings[i]);
}
int main(void)
{
    char s[4][20] = {"Example 1", "Example 2", "Example 3", "Example 4"};
    print_strings(4, 20, s);
    return 0;
}


#if 0
#include <stdio.h>
//void print_strings(char (*strings)[20], size_t n)
/* OR */
// void print_strings(char strings[][20], size_t n)

void print_strings(char **strings, size_t n)
{
    size_t i;
    for (i = 0; i < n; i++)
        puts(strings[i]);
}
int main(void)
{
    char s[4][20] = {"Example 1", "Example 2", "Example 3", "Example 4"};
    print_strings(s, 4);
    return 0;
}
#endif

/*
Before Decay                                                 After Decay  
char [20] array of (20 chars)                                char * pointer to (1 char)
char [4][20] array of (4 arrays of 20 chars)                 char (*)[20] pointer to (1 array of 20 chars)
char *[4] array of (4 pointers to 1 char)                    char ** pointer to (1 pointer to 1 char)
char [3][4][20] array of (3 arrays of 4 arrays of 20 chars)  char (*)[4][20] pointer to (1 array of 4 arrays of 20 chars)
char (*[4])[20] array of (4 pointers to 1 array of 20 chars) char (**)[20] pointer to (1 pointer to 1 array of 20 chars)
*/