#include<stdio.h>
int main(void)
{
	printf("%s\n",__FILE__);
	printf("%s\n",__BASE_FILE__);
	printf("%d\n",__LINE__);
	printf("%s\n",__FUNCTION__);
	printf("%s\n",__TIME__);
	printf("%s\n",__DATE__);
	return 0;
}
