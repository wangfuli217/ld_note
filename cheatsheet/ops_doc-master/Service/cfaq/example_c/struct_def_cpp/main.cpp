#include <stdio.h>

typedef struct tagTItem *PTItem;
typedef struct tagTItem
{
	tagTItem* next;
	int value;
public:
	tagTItem():next(NULL), value(0) {}
}TItem;


struct AA 
{
	int a;
};


struct _X
{
	_X() {}
 
	int value;
};

_X x;


int main(int argc, char **argv)
{
	AA* p = NULL;
	
	p = new AA();
	
	p->a = 1;
	
	printf("hello world\n");
	return 0;
}


