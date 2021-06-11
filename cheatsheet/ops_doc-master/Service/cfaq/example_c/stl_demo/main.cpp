#include <stdio.h>
#include <stdlib.h>
#include <map>

using namespace std;

int main(int argc, char **argv)
{
	map<int, char*> temp;
	
	char name[10] = {"chenbo"};
	
	temp[1] = name;
	
	printf("temp: %s\n", temp[2]);
	
	system("pause");
	return 0;
}
