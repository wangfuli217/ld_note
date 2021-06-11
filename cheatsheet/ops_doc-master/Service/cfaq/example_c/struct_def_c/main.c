#include <stdio.h>
typedef struct tagTItem *PTItem;
typedef struct tagTItem
{
	struct tagTItem* next;
	int value;
}TItem;

typedef struct
{
	int value;
}X;

typedef struct tagTItem2
{
	struct tagTItem2* next;
	int value;
}TItem2, *pTItem2;


typedef struct tagTItem3 *PTItem3;
typedef struct tagTItem3
{
	PTItem3 next;
	int value;
}TItem3;

int main(int argc, char **argv)
{
	X x = {0};
	
	return 0;
}
