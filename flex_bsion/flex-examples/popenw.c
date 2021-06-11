#include <stdio.h>
main() {
	FILE *yyout;

  yyout = (FILE *)popen("sort","w");
  fprintf(yyout,"6\n5\n4\n3\n2\n1\n");
  pclose(yyout);
}
