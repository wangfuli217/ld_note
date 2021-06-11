// cat memory-leak.c 
#include <stdlib.h>

void *p;

int main() {
  p = malloc(7);
  p = 0; // The memory is leaked here.
  return 0;
}
// clang -fsanitize=address -g memory-leak.c
// ./a.out 