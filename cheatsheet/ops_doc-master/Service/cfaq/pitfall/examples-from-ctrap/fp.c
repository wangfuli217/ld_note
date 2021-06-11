#include<stdio.h>

void func();

typedef void (*funcptr)();

int main()
{
  void *g();     /* declaration: function g, returning (void*) */
  
  void (*h)();   /* declaration: pointer, named h, to a function takes no parameter and return void */

  void f();      /* declaration: function f, returning  void */

  void (*fp)();  /* fp and h share same type */

  /* not able to do (* 0) (); need to converse ZERO to a the type of pointer */

  (*   (void (*)())     0 ) ();         /* cast 0 to a pointer to function which type is (void (*)()), the function takes no parameter and return void */
  (*   (void (*)(int, float))     1) (8, 9.0); /* cast 1 to a pointer to function which type is (void (*)(int, float)), the function takes an integer and a floating as its parameters and return void*/
  
  return 0;
}
