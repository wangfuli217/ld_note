
#include <stdio.h>
 
int main(void)
{
   int         hoge = 0x12345678;
   unsigned char *hoge_p = (unsigned char *)&hoge;

   printf("%x\n", hoge_p[0]);
   printf("%x\n", hoge_p[1]);
    printf("%x\n", hoge_p[2]);
    printf("%x\n", hoge_p[3]);
 
    return 0;
}