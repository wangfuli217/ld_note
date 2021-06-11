#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>


int main ()
{
/*CALENDAR----------------------------------------------------------*/
/*
	int calendar[12][31];
    int (*monthp)[31];
    int month;

    for (month = 0; month < 12; month++) {
        int day;
        for (day = 0; day < 31; day++)
            *(*(calendar + month) + day) = 0;
    }
*/
/*STRING-MEMORY------------------------------------------------------*/
/*
    const char *s = "strings", *t = " space\n"; 
    char *r;
    
    r = malloc(strlen(s) + strlen(t) + 1); //one for EOF
    if (!r) {
        printf("no memory");
        exit(1);
    }
    strcpy(r, s);
    strcat(r, t);
    
    printf("memory: %s", r);    
 */  
/*OVERFLOW----------------------------------------------------------------*/
/*
    int a = 50, b;
    scanf("%d", &b);
    
	if (a > INT_MAX - b)
        printf("overflow\n");
    else
        printf("nice\n");

*/
/*SEARCH-------------------------------------------------------------------*/
/*
    #define NTABLE 8
    
    int* bsearch (int *begin, int n, int value) {
        while (n != 0) { 
            if (*begin++ == value) {
                return --begin;
            } 
        n--;
        }
        return 0;     
    }   
    
    int table[NTABLE] = { 1, 8, 6, 4, 3, 100, 89, 98};
    int *p;
    int input;
    scanf("%d", &input);
    
    p = bsearch(&table[0], NTABLE, input);
    
    printf("value: %d, pointer mem:%p\n", p!=0 ? *p : 0, p);
*/
}















