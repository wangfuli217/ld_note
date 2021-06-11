#include <stdio.h>

#define COND_A 1
#define COND_B 0

#if COND_A
struct A { 
	A(const char *s) { 
	} 
};

extern int ecc(const A &);
#endif


#if COND_B
extern int ecc(const char *);
#endif



int main(int argc, char **argv) {
	
	#if COND_A
	ecc("Hello World"); // 这里ecc没有定义与声明，g++报不能编译的错误
	#endif
	
	#if COND_B 
	ecc("Hello World");
	#endif
	
	return 0;
}
