#include <stdio.h>
#include <string.h>
#include <stdlib.h>

static const char *msg[] = {"Sunday", "Monday", 
							"Tuesday", "Wednesday",
							"Thursday", "Friday", "Saturday"
};

char*
get_a_day(int idx)
{
	static char buf[20];
    
	printf("%s %d\n", __FUNCTION__, idx);
	strcpy(buf, msg[idx]);
    
	return buf;
}

int 
main(void)
{
     printf("%s %s\n", get_a_day(0), get_a_day(1)); /* 调用的循序是 get_a_day(1)  get_a_day(0) */
	 
	 system("pause");
	 
     return 0;
}