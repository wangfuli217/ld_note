#include <stdio.h>
#include <qq.h>

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

int main(void)
{
   int a = 23;

   printf( "Hello, I am teacher(%d), pls tell me your names!\n", a );

   #ifdef POPO
   printf("My name is PoPo!\n");
   #endif

   qq();
   return 0;
}

