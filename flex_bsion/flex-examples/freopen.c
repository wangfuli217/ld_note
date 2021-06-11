#include <stdio.h>
main() {
	int c;

	freopen("hello.c","r",stdin);
	while ((c = getchar()) != EOF) {
		putc(c,stdout);
	}
}
