#include "LinkList.h"

CLinkList::CLinkList(void)
{
	m_List = NULL;
	m_index= m_Size = 0;
}

CLinkList::CLinkList( int size )
{
	m_List = new ListNode[ size ];
	m_Size= size;
	m_index=0;
}

CLinkList::~CLinkList(void)
{
	SAFE_ARR_DELETE( m_List );
	m_index = m_Size= 0;
}

void  CLinkList::init()
{
	for ( int i = 0 ; i < m_Size ; i++ )
	{
		init_list_self( i );
	}
}

void CLinkList::init_list_self(int idx)
{
	m_List[idx].next = m_List[idx].prev = &m_List[idx];
}

void CLinkList::insert_listnode(ListNode *news, ListNode *prev, ListNode *next)
{
	next->prev = news;
	news->next = next;
	news->prev = prev;
	prev->next = news;
}

void CLinkList::insert_head( ListNode* news , ListNode* head )
{
	insert_listnode( news, head , head->next);
}

void CLinkList::insert_tail(ListNode *news, ListNode *head)
{
	insert_listnode( news, head->prev , head );
}

void CLinkList::list_del(ListNode* list)
{
	list->next->prev = list->prev;
	list->prev->next = list->next;
}

ListNode*  CLinkList::GetNode(int index) const 
{
	if ( m_Size > index )
		return &m_List[ index ];
	return NULL;
}

