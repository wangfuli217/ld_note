#include <stdio.h>
#include <stdarg.h>
#include <locale.h>

int main(void){
	char *s;
	char c;
	double d;
	int i;

	i = 42;
	d = 19;
	c = 22;
	s = "suce";
    printf("First , do this, then \
    do that.");
    
    printf("Hello" " World!"); //自动合成一行
    
	printf("\\1234=\1234 0123=%c  \189 \n", 0123);
	printf("\033[0;32m----------------TEST---------------------\033[0m\n");
	printf("test 0 10(s) = %10s\n", s);
	printf("test 0bis %5%(s) = %5%\n");
	printf("test 1 10.3(s) = %10.3s\n", s);
	printf("test 2 10.5(s) = %10.5s\n", s);
	printf("test 3 .2(s) = %.2s\n", s);
	printf("test 4 0(d) = %0d\n", c);
	printf("test 4bis 0.3(d) = %0.3d\n", c);
	printf("test 5 11.10(d) = %11.10d\n", c);
	printf("test 6 0*(f) = %0*o\n", 5, i);
	printf("test 7 #(x) = %#x\n", c);
	printf("test 8 #(o) = %#o\n", c);
	printf("test 9 #(X) = %#X\n", c);
	printf("test 10 +(d) = %+d\n",c);
	printf("test 11 -(d) = %-d\n",c);
	printf("test 12  (d) = % d\n",c);
	printf("test 13 0(d) = %0d\n",c);
	printf("test 14 (o) = %o\n", c);
	printf("test 14bis #(o) = %#o\n", c);
	printf("test 15 #1(o) = %#1o\n", c);
	printf("test 16 #1.5(o) = %#2.1o\n", c);
	printf("test 17 (o) = %o\n", i);
	printf("test 17bis (o) = %o\n", c);
	printf("test 17ter (o) = %o\n", i);
	printf("test 17ter (o) = %x\n", i);
	return (0);
}