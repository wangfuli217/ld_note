#include <stdio.h>
int main(void)
{
unsigned int a = 29;    /* 29 = 0001 1101 */  
   unsigned int b = 48;    /* 48 = 0011 0000 */
   int c = 0;          
   c = a & b;              /* 32 = 0001 0000 */
   printf("%d & %d = %d\n", a, b, c );
   c = a | b;              /* 61 = 0011 1101 */
   printf("%d | %d = %d\n", a, b, c );
   c = a ^ b;              /* 45 = 0010 1101 */
   printf("%d ^ %d = %d\n", a, b, c );
   c = ~a;                 /* -30 = 1110 0010 */
   printf("~%d = %d\n", a, c );
   c = a << 2;             /* 116 = 0111 0100 */
   printf("%d << 2 = %d\n", a, c );
   c = a >> 2;             /* 7 = 0000 0111 */
   printf("%d >> 2 = %d\n", a, c );
   return 0;
}

#include <limits.h>
void bit_pattern(int u)
{
    int i, x, word;
    unsigned mask = 1
    word = CHAR_BIT * sizeof(int);
    mask = mask << (word - 1);    /* shift 1 to the leftmost position */
    for(i = 1; i <= word; i++)
    {
        x = (u & mask) ? 1 : 0;  /* identify the bit */
        printf("%d", x);         /* print bit value */
        mask >>= 1;              /* shift mask to the right by 1 bit */
    }
}