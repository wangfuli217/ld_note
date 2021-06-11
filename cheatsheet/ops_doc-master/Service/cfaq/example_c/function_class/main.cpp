#include <stdio.h>
#include <stdlib.h>

class _min {
public:
	bool operator()(int a, int b) 
	{
		return a < b;
	}
};

int main(int argc, char **argv)
{
	_min __min;
	
	bool result = __min(1, 2);
	
	if (result) {
		printf("true\n");
	} else {
		printf("false\n");
	}
	
	return 0;
}
