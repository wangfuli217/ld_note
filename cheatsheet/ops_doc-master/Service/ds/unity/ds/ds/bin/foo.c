#include <stdio.h>
#include <stdlib.h>


int main (int argc, char ** argv)
{
  int i;
  int algorithm;
  int array_size;
  int array_type;
  int is_print;

  if (!(argc > 6))
  {
    fprintf(stderr, "Missing paramters\n");
    fprintf(stderr, "Expected: ./benchmark -a <algorithm> -n <array_size> -s <array_type>\n");
    return EXIT_FAILURE;
  }
}

