/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __SINGLELINKEDLIST_H
#define __SINGLELINKEDLIST_H
/* Includes ------------------------------------------------------------------*/
/* Exported types ------------------------------------------------------------*/
typedef int ElemType;      //数据元素的类型，假设是int型的

typedef struct Node{
	ElemType elem;  //存储空间
	struct Node *next;
}Node;

typedef struct SingleLinkedList{
	Node *This;
	void (*clear)(struct SingleLinkedList *This);
	int (*isEmpty)(struct SingleLinkedList *This);
	int (*length)(struct SingleLinkedList *This);
	void (*print)(struct SingleLinkedList *This);
	int (*indexElem)(struct SingleLinkedList *This, ElemType* x);
	int (*getElem)(struct SingleLinkedList *This, int index, ElemType *e);
	int (*modifyElem)(struct SingleLinkedList *This, int index, ElemType* e);
	int (*deleteElem)(struct SingleLinkedList *This, int index, ElemType* e);
	int (*appendElem)(struct SingleLinkedList *This, ElemType *e);
	int (*insertElem)(struct SingleLinkedList *This, int index, ElemType *e);
	int (*popElem)(struct SingleLinkedList *This, ElemType* e);
	int (*reverseList1)(struct SingleLinkedList *This);
	int (*reverseList2)(struct SingleLinkedList *This);
}SingleLinkedList;

/* Exported macro ------------------------------------------------------------*/
SingleLinkedList *InitSingleLinkedList();
void DestroySingleLinkedList(SingleLinkedList *L);

#endif