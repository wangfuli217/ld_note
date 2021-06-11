#include <stdlib.h>
#include <stdio.h>

int *fa()
{
  int *p=(int*)malloc(10000);
  return p;
}

int *fb(int *p)
{
  delete p;
}

int main(void)
{
  printf("ok\n");

  printf("really ok?\n");

  int *vec[10000];

  for(int i=0;i<10000;i++)
  {
    vec[i]=fa();
  }

  for(int i=0;i<10000;i++)
  {
    fb(vec[i]);
  }

  return 0;
}