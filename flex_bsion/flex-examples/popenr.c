#include <stdio.h>
main() {
  int c, lineno = 1;
  char string[80];
  FILE * yyin;

  yyin = (FILE *)popen("/lib/cpp hello.c","r");
  fprintf(stdout,"%2d ",lineno++);
  while ((c = fgetc(yyin)) != EOF) {
    putc(c,stdout);
    if (c == '\n') fprintf(stdout,"%2d ",lineno++);
  }
  pclose(yyin);
}
