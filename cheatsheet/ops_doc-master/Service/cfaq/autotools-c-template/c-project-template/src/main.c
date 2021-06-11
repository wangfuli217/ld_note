#include <stdio.h>
#include "mylib/mylib.h"

int main(int argc, char* argv[])
{
  printf("%f\n", get_sec_since_epoch());
  hello();
  here();
  bye();
  
  return 0;
}
