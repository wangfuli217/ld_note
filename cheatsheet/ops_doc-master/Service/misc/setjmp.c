/* setjmp example: error handling */
#include <stdio.h>      /* printf, scanf */
#include <stdlib.h>     /* exit */
#include <setjmp.h>     /* jmp_buf, setjmp, longjmp */

int main() {
  jmp_buf env;
  int val;

  val = setjmp (env);
  if (val) {
    fprintf (stderr,"Error %d happened",val);
    exit (val);
  }

  /* code here */

  longjmp (env,101);   /* signaling an error */
  
  return 0;
}
/*
Output:
Error 101 happened
*/