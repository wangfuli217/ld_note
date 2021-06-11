#include "algorithm.h"
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>


char*
strrev2(char* src)
{
	assert(src != NULL);
	
	//char c;
	
	for(int i = 0, j = strlen(src) - 1; i < j ; i++, j--)
	{
		//c = src[i];
		//src[i] = src[j];
		//src[j] = c;
		
		src[i] ^= src[j];
		src[j] ^= src[i];
		src[i] ^= src[j];
	}
	
	return src;
}

void
List_Init(PListItem* list, unsigned int number)
{
	PListItem head, p = *list;
	
	head = p;
	
	p = new ListItem;
	
	*list = p;
	
	p->data = 0;
	p->next = NULL;
		
	for(unsigned int i = 1; i < number ; i++)
	{
		p->next = new ListItem;
		
		p->next->data = i;
		p->next->next = NULL;
		
		p = p->next;
	}
	
	for(unsigned int i = 1; i <= number ; i++)
	{
		
	}
	
}

void
List_Print(PListItem list)
{
	PListItem p = list;
	
	while(p)
	{
		printf("List: %d\n", p->data);
		p = p->next ? p->next : NULL;
	}
}

PListItem*
List_Rev(PListItem* list)
{
	PListItem c, n, old_head, nn;
	
	c = *list;
	old_head = *list;
	
	n = (*list)->next ? (*list)->next : NULL;
	nn = (*list)->next->next ? (*list)->next->next : NULL;
	
	if (n == NULL)
		return list;
	
	while(nn)
	{
		n->next = c;
		c = n;
		n = nn;
		nn = nn->next;
	}
	
	n->next = c;
	
	*list = n;
	
	old_head->next = NULL;
		
	return list;
}

