#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

/* 进制的本质
 * 程序说明:
 * 	argv[1]必须是个大于0的数值，代表本次需要打印的是几进制
 *  argv[2] ~ argv[argv[1] + 1]是符号，可以是自定义的符号序列
 * 
 *  程序先用给出的进制打印相应的数值
 *  然后输出该进制的加法表和乘法表。
 * 
 **/
/* 变量scale数值代表几进制 */
int scale;
char *sym;

/* 这里其实就是10进制转到其他进制的方法 */
static void print(unsigned int value)
{
	unsigned int quotient = value / scale; 
	unsigned int remainder = value % scale;	

	if (quotient >= scale) {
		print(quotient);	
	} else {
		if (quotient != 0) {
			printf("%c", sym[quotient]);
		}
	}
	printf("%c", sym[remainder]);
}

int main(int argc, const char *argv[])
{
	if (argc <= 2) {
		(void)fprintf(stderr, "Usage: %s + num + symbol list ... \n", argv[0]);	
		exit(EXIT_FAILURE);
	}	

	unsigned int i;
	scale = atoi(argv[1]);
	if (scale <= 1) {
		(void)fprintf(stderr, "argv[1] must > 2\n");		
		exit(EXIT_FAILURE);
	}

	/* 是几进制，该进制就有多少个符号 */
	sym = malloc(sizeof(char) * scale); 
	if (sym == NULL) {
		(void)fprintf(stderr, "malloc error: %s\n", strerror(errno));	
		exit(EXIT_FAILURE);
	}

	for (i = 1; i <= scale; i++) {
		if (argv[i+1] == NULL) break;
		sym[i-1] = argv[i+1][0];	
	}
	if (i <= scale) {
		(void)fprintf(stderr, "Please give at lease %d symbols\n", scale);	
		goto err;
	}

	printf("scale: %d\n", scale);
	for (i = 0; i < scale; i++) {
		printf("%c ", sym[i]);
	}
	printf("\n");

	/* 输出100行该进制数值 */
	for (i = 0; i < scale * 100; i++) {
		print(i);	
		printf("\t");
		if ((i + 1) % scale == 0) printf("\n");
	}

	// 加法表
	for (i = 1; i < scale; i++) {
		int j;	
		for (j = 1; j <= i; j++) {
			printf("%c + %c = ", sym[i], sym[j]);	
			print(i+j);
			printf("\t");
		}
		printf("\n");
	}

	printf("\n\n");
	// 乘法表
	for (i = 1; i < scale; i++) {
		int j;
		for (j = 1; j <= i; j++) {
			printf("%c * %c = ", sym[i], sym[j]);	
			print(i*j);
			printf("\t");
		}	
		printf("\n");
	}

//	0		1 		2
//	10  	11		12	
//	20 		21		22	
//	100		101		102
//	110		111		112
//	120		121		122
//	200		201		202
//	210		211		212
//	220		221		222
//	1000	1001	1002
//	1010	1011	1012
//	1020	1021	1022
//	1100	1101	1102
//	1110	1111	1112
//	1120	1121	1122
//	1200	1201	1202


	if (sym) {
		free(sym);	
	}
	exit(EXIT_SUCCESS);
err:
	if (sym) {
		free(sym);	
	}
	exit(EXIT_FAILURE);
}

