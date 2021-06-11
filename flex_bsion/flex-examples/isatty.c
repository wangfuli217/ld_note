#include <unistd.h>
#include <stdio.h>
main() {
  
  if (isatty(0)) 
    printf("interactive\n");
  else 
    printf("non interactive\n");
}
