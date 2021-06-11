main.c:
#include <stdlib.h> /* for EXIT_SUCCESS */
#include <stdio.h>
#include "resources.h"
int main(void)
{
  EnumResourceID resource_id = RESOURCE_UNDEFINED;
  while ((++resource_id) < RESOURCE_MAX)
  {
    printf("resource ID: %d, resource: '%s'\n", resource_id, resources[resource_id]);
  }
  return EXIT_SUCCESS;
}
// gcc -Wall -Wextra -pedantic -Wconversion -g  main.c resources.c -o main