#include <stdio.h>
#include <qq.h>

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

void qq(void)
{
   printf("My name is QQ\n");

   #ifdef POPO
   printf("QQ: Hey PoPo, long time no see.\n");
   #endif
}

