#include <stdio.h>
#include <vector>

using namespace std;

int 
main(int argc, char **argv)
{
	vector<char> vc(10, 'h');
	
	printf("vc: %s\n", &*vc.begin());
	printf("vc: %c\n", *(&vc[1]));
	
	int i;
	
	scanf("%d", &i);
	
	return 0;
}
