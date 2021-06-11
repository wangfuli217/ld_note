#include <iostream>
#include <stdio.h>
#include <netinet/in.h>
using namespace std;

int main()
{
	short a = 0x03;

	printf("%0X\n",ntohs(0x03));
	printf("%d\n",ntohs(0x03));
	return 0;
}
