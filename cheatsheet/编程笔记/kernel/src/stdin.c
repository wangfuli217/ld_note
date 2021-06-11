#include <stdio.h>

char buf[BUFSIZ];
inline int aaa();

int main()
{
#if 0
	getchar();
	int i = ftell(stdin);
	printf("pos: %d\n", i);
#endif
	setvbuf(stdin, buf, _IOLBF, BUFSIZ);
	int a, i;
	char c;
	float b;
	char *bp = buf;

	printf("g1\n");
	getchar();
	bp++;
	/* *bp++ = '\n'; */
	/* *bp++ = 'n'; */
#if 0
	*bp++ = 'n';
	*bp++ = 'n';
	*bp++ = 'n';
#endif
	/* *bp++ = '\n'; */
	printf("scanf\n");
	scanf("%d", &a);
	bp = buf;
	for (i = 0; i < 8; i++) {
		printf("%x ", *bp);
		bp++;
	}
	printf("a is %d\n", a);
#if 0
	bp = buf;
	for (i = 0; i < 8; i++) {
		printf("%x ", *bp);
		bp++;
	}
	putchar('\n');
#endif
	return 0;
}
