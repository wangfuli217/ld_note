#include <stdio.h>
#include <stdlib.h>

class A {
public:
	int operator int() { return i; }
private:
	int i;
};

int main(int argc, char **argv)
{
	A a;
	
	(int)a;
	
	system("pause");
	
	return 0;
}
