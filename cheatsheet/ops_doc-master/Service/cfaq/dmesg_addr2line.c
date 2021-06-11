#include <stdio.h>  
  
int func(int a, int b)  
{  
  return a / b;  
}  
  
int main()  
{  
  int x = 10;  
  int y = 0;  
  printf("%d / %d = %d\n", x, y, func(x, y));  
  return 0;  
}  
/*
gcc -o test1 -g test1.c
dmesg
test[19979] trap divide error ip:4004d6 sp:7fff27dea480 error:0 in test[400000+1000]
addr2line -e test1 400506
*/
