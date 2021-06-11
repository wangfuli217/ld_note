#include <stdio.h>
#include <string>

using namespace std;

int main(int argc, char **argv)
{
	string temp("hello");
	
	printf("len: %d\n", *((char*)&temp - 24));
	return 0;
}
