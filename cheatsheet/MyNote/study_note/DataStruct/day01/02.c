#include<stdio.h>
#include<time.h>
int main()
{
	time_t t=0;
	time(&t);
	gmtime(&t);
	printf("%s\n",asctime(&t));
	return 0;
}
