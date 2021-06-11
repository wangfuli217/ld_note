#include <stdio.h>
#include <stdlib.h>

#define __DEBUG__(lv, fmt, ...) { 											\
	if (lv >= 3) {															\
		printf("[%s:%d] %s "fmt"\n", __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__);	\
	}																			\
}

#define __FATAL__(lv, fmt, args...) {	\
	if (lv >= 2) {																\
		printf("[%s:%d] %s "fmt"\n", __FILE__, __LINE__, __FUNCTION__, ##args);	\
	}																			\
}

#define __PPPP__(fmt, ...) printf(fmt, args)

int main(int argc, char **argv)
{
	__DEBUG__(3, "%s", "chenbo");
	__FATAL__(3, "%s", "chenbo");
	__FATAL__(3, "chenbo");
	__PPPP__("chenbo\n")
	
	return 0;
}
