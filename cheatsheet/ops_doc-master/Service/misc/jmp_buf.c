#include <stdio.h>
#include <setjmp.h>
#include <stdnoreturn.h>
 
jmp_buf jump_buffer;
 
noreturn void a(int count) 
{
    printf("a(%d) called\n", count);
    longjmp(jump_buffer, count+1); // will return count+1 out of setjmp
}
 
int main(void)
{
    volatile int count = 0; // local vars must be volatile for setjmp
    if (setjmp(jump_buffer) != 9)
        a(count++);
}
jmp_buf env; // only can share in the same thread

void DoSomething() {
  if (error) {
    longjmp(env, SOMETHING_ERROR);
  }
}

void Test() {
  switch (setjmp(env)) {
  case 0:
    DoSomething(env);
    break;
  case SOMETHING_ERROR:
    // handle error
    break;
  }
}