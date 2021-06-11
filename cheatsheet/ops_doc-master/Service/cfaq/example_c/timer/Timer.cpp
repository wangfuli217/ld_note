
#include "Timer.h"
#include <iostream>

CTimer::CTimer(void)
{
	m_tv1 = new CLinkList( ebitsize );
	m_tv2 = new CLinkList( sbitsize );
	m_tv3 = new CLinkList( sbitsize );
	m_tv4 = new CLinkList( sbitsize );
	m_tv5 = new CLinkList( sbitsize );
}

CTimer::CTimer(int second)
{
	m_tv1 = new CLinkList( ebitsize );
	m_tv2 = new CLinkList( sbitsize );
	m_tv3 = new CLinkList( sbitsize );
	m_tv4 = new CLinkList( sbitsize );
	m_tv5 = new CLinkList( sbitsize );

	m_mSecond = second;
	Init( m_mSecond );
}

void  CTimer::Init(int second )
{
	m_jeffies = m_Lasttime = GetCurrSystemTime();
	if( second > 0 )
		m_mSecond = second;

	m_tv1->init();
	m_tv2->init();
	m_tv3->init();
	m_tv4->init();
	m_tv5->init();

	g_vecs = new CLinkList * [ lnum ];
	//for( int i = 1 ; i <= lnum ; i++ )
	ListProp(g_vecs,m_tv,1);
	ListProp(g_vecs,m_tv,2);
	ListProp(g_vecs,m_tv,3);
	ListProp(g_vecs,m_tv,4);
	ListProp(g_vecs,m_tv,5);
}

CTimer::~CTimer(void)
{
	SAFE_DELETE( m_tv1 );
	SAFE_DELETE( m_tv2 );
	SAFE_DELETE( m_tv3 );
	SAFE_DELETE( m_tv4 );
	SAFE_DELETE( m_tv5 );

	SAFE_ARR_DELETE( g_vecs);
}

void  CTimer::add_timer(timernode *times)
{
	if ( !check_timer(times) )
		return ;
	
	/// hash到轮子
	uint64_t expires = (times->etime - m_jeffies) / m_mSecond;

	CLinkList* lve = NULL;
	ListNode * lvec= NULL;
	int  idx = 0 ;
	if( expires < ebitsize )
	{
		idx = ( expires + m_tv1->GetIndex() ) & eMask;
		lvec= m_tv1->GetNode( idx );
		lve = m_tv1;
	}
	else if ( expires < ( 1<< (sbits+ebits) ) )
	{
		idx = ( (expires>>ebits) + m_tv2->GetIndex() ) & sMask;
		lvec = m_tv2->GetNode( idx );
		lve = m_tv2;
	}
	else if ( expires < ( 1<< (2*sbits+ebits) ) )
	{
		idx = ( (expires>>(sbits+ebits)) + m_tv3->GetIndex() ) & sMask;
		lvec = m_tv3->GetNode( idx );
		lve = m_tv3;
	}
	else if ( expires < ( 1<< (3*sbits+ebits) ))
	{
		idx = ( (expires>>(2*sbits+ebits)) + m_tv4->GetIndex() ) & sMask;
		lvec = m_tv4->GetNode( idx );
		lve = m_tv4;
	}
	else if ( expires < 0xffffffffUL )
	{
		idx = ( (expires>>(3*sbits+ebits)) + m_tv5->GetIndex() ) & sMask;
		lvec = m_tv5->GetNode( idx );
		m_tv1->insert_tail(&times->tlist , lvec );
		lve = m_tv5;
	}
	if( lve !=NULL && lvec != NULL )
		lve->insert_tail(&times->tlist , lvec );	

}

bool  CTimer::check_timer(timernode *times)
{
	return  times->tlist.next /*== times->tlist.prev */!= NULL;
}

bool  CTimer::delete_timer(CLinkList* list, timernode *times)
{
	if ( !check_timer(times))
		return false;
	list->list_del( &times->tlist );
	init_timer(times);
	return true;
}

void  CTimer::init_timer(timernode *timers)
{
	timers->tlist.next = timers->tlist.prev = NULL;
}


void  CTimer::Cancel(timernode *timers)
{
	//delete_timer( timers );
}

void  CTimer::Expires(uint64_t jeffies)
{
	long Count = ( jeffies - m_jeffies ) / m_mSecond;

	long tCount= Count;
	while ( Count >= 0 )
	{
		ListNode *head ,*curr , *next;
		head = m_tv1->GetNode( m_tv1->GetIndex() );
		curr = head->next;

		while ( curr != head )
		{
			timernode* timer;
			next = curr->next;

			timer= (timernode*)((char*)curr - offsetof(timernode, tlist));
			void* fun = timer->pFun;

			static_cast<CGameEvent*>(fun)->TimeOut( timer->eType );

			/// 定时器触发
			delete_timer(m_tv1,timer);

			/// 如果是循环定时器
			if ( timer->expires > 0)
			{
				/// 重新增加
				/// add_timer( timer );
			}
			else 
			{
				/// 删除
				SAFE_DELETE(timer);
			}
			curr = next;
		}
		Count --;

		if ( m_jeffies + m_mSecond <= jeffies && tCount > 0)
		{
			 m_jeffies +=m_mSecond;
			 m_tv1->SetIndex( (m_tv1->GetIndex() + 1) & eMask );
			
			 /// 旋转一周,更新后面的轮子
			 if ( m_tv1->GetIndex() == 0 )
			 {
				 int n = 1;
				 do 
				 {
					 cascade_timer( g_vecs[n] );
					 std::cout <<" 第 "<< n+1 <<" 个轮子,索引 " << g_vecs[n]->GetIndex() <<" 转动" << std::ends;
				 } while ( g_vecs[n]->GetIndex() == 0 && ++n < lnum);
				 
			 }
		}
	}
}

void  CTimer::cascade_timer(CLinkList* tlist)
{
	ListNode *head ,*curr,*next;

	head = tlist->GetNode( tlist->GetIndex() );
	curr = head->next;

	while ( curr != head )
	{
		timernode* tmp = (timernode*)( (char*)curr - offsetof(timernode,tlist));

		next = curr->next;
		tlist->list_del( curr );

		Mod_timer( tmp );

		curr = next;
	}
	
	tlist->init_list_self( tlist->GetIndex() );
	tlist->SetIndex( ( tlist->GetIndex() + 1 ) & sMask );
}

void CTimer::Mod_timer(timernode *timers)
{
	if ( timers->etime < m_jeffies)
		timers->etime = m_jeffies;
	
	add_timer(timers);
}

