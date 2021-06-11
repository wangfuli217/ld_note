#include<stdio.h>
#include<stdlib.h>
typedef struct node
{
	struct node* p_next;
	int num;
}node,*p_node;
typedef struct
{
	p_node p_head;
	p_node p_tail;
}liba;
void Insert_Head(liba *p_liba,const int num)
{
	if(!(p_liba->p_head))  
	{
		p_liba->p_head=p_liba->p_tail=(p_node)malloc(sizeof(node));
		p_liba->p_head->num=num;
		p_liba->p_head->p_next=p_liba->p_tail;
	}
	else
	{
		p_node p_temp=p_liba->p_head;
		p_liba->p_head=(p_node)malloc(sizeof(node));
		p_liba->p_head->p_next=p_temp;
		p_liba->p_head->num=num;
	}
}
void Print_Head(const liba *p_liba)
{
	p_node p_temp=p_liba->p_head;
	for(;;p_temp=p_temp->p_next)
	{
		if(p_temp==p_liba->p_tail)
		{
			printf("%d ",p_temp->num);
			break;
		}
		printf("%d ",p_temp->num);
	}
	printf("\n");
}
int main()
{
	liba libao={};
	Insert_Head(&libao,3);
	Insert_Head(&libao,4);
	Insert_Head(&libao,5);
	Insert_Head(&libao,6);
	Insert_Head(&libao,7);
	Print_Head(&libao);
	return 0;
}
