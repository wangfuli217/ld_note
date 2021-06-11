#include"tree.h"
int main(void)
{
	Tree tree={};
	insertData(&tree,50);
	travelData(&tree);
	insertData(&tree,70);
	modifyData(&tree,70,30);
	travelData(&tree);
	insertData(&tree,20);
	node **p=findData(&tree,30);
	if(*p==NULL)
		printf("没有找到\n");
	else
		printf("找的值为%d\n",(*p)->data);
	clear(&tree);
	travelData(&tree);
	return 0;
}
