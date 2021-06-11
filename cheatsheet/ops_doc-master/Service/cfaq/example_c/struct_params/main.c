#include <stdio.h>
#include <stdlib.h>
 
#define func(...) myfunc((struct mystru){__VA_ARGS__})
 
struct mystru { const char *name; int number; };
 
void myfunc(struct mystru ms ) {
	printf("%s: %d\n", ms.name ?: "untitled", ms.number);
}
 
int main(int argc, char **argv) {
	func("three", 3);
	func("hello");
	func(.name = "zero");
	func(.number = argc, .name = "argc",);
	func(.number = 42);
	
	system("pause");
	return 0;
}


//宏替换后的效果
/*myfunc((struct mystru){"three", 3});
myfunc((struct mystru){"hello"});
myfunc((struct mystru){.name = "zero"});
myfunc((struct mystru){.number = argc, .name = "argc",});
myfunc((struct mystru){.number = 42});*/
