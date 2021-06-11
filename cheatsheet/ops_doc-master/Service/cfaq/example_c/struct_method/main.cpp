#include <stdio.h>

struct Father {
	int id;
	int age;
public:
	int self() { printf("is father\n"); }
};

struct Son : Father {
public:
	int self() { Father::self(); printf("is son\n"); }
};

int main(int argc, char **argv)
{
	Son son;
	
	son.self();
	
	
	return 0;
}
