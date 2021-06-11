#ifndef __ALGORITHM_H_
#define __ALGORITHM_H_

//字符串颠倒
extern char* strrev2(char* src);

typedef unsigned int ListData;

typedef struct ListItem
{
	ListItem*	next;
	ListData	data;
}ListItem, *PListItem;

extern PListItem* List_Rev(PListItem* list);
extern void List_Init(PListItem* list, unsigned int number);
extern PListItem List_Destory(PListItem list);
extern void List_Print(PListItem list);

#endif