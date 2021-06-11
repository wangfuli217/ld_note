#include <stdio.h>
#include "arena.h"

int main(int argc, char *argv[])
{
  Arena_T arena = Arena_new();
  char *ptr = (char *)Arena_alloc(arena, 100, __FILE__, __LINE__);
  char *ptr1 = (char *)Arena_alloc(arena, 100, __FILE__, __LINE__);
  char *ptr2 = (char *)Arena_alloc(arena, 100, __FILE__, __LINE__);
  char *ptr3 = (char *)Arena_alloc(arena, 500, __FILE__, __LINE__);
  char *ptr4 = (char *)Arena_alloc(arena, 500, __FILE__, __LINE__);
  char *ptr5 = (char *)Arena_alloc(arena, 500, __FILE__, __LINE__);

  printf("ptr = %p\n", ptr);
  printf("ptr1 = %p\n", ptr1);
  printf("ptr2 = %p\n", ptr2);
  printf("ptr3 = %p\n", ptr3);
  printf("ptr4 = %p\n", ptr4);
  printf("ptr5 = %p\n", ptr5);
  printf("after alloc 1800 bytes\n");
  Arena_print(arena);

  char *ptr6 = (char *)Arena_alloc(arena, 2000, __FILE__, __LINE__);
  printf("after alloc 3800 bytes\n");
  Arena_print(arena);

  char *ptr7 = (char *)Arena_alloc(arena, 9*1024, __FILE__, __LINE__);
  printf("after alloc 1800 + 9 * 1024 bytes\n");
  Arena_print(arena);

  return 0;
}