/* beancounter.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
void* beancounter(void* beans_arg)
{
  int counter;
  int* beans = (int*)beans_arg;

  for (counter=0; counter<100000; counter++) {
    (*beans)++;
  }
  return beans_arg;
}

int main(void)
{
  pthread_t t_beancounter0, t_beancounter1;
  int beans = 0;

  pthread_create(&t_beancounter0,0,beancounter,
                 (void*)(&beans));
  pthread_create(&t_beancounter1,0,beancounter,
                 (void*)(&beans));
  pthread_join(t_beancounter0,0);
  pthread_join(t_beancounter1,0);

  printf("The sum of all beans is %d\n",beans);
  return 0;
}
