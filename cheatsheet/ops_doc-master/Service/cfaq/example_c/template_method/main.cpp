#include <stdio.h>
#include "template.h"


int main(int argc, char **argv)
{
	Add(1, 2);
	
	Add<float>(1.2, 1.2);
	
	int i, j;
	
	i=j=1;
	
	Add(&i, &j);
	
	int ii;
	
	cin >> ii;

	return 0;
}
