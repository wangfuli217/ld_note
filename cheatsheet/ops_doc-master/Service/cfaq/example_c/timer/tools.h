#ifndef __TOOLS_H_
#define __TOOLS_H_

#include <stdint.h>
#include <time.h>
#include <sys/time.h>

/// 得到当前时间，精确到毫秒
inline  uint64_t GetCurrSystemTime()
{
	struct timeval t;
	
	gettimeofday(&t, NULL);
	
	return t.tv_sec * 1000 + t.tv_usec * 0.001;
}

/// 定时器指针结点
struct ListNode
{
	ListNode *next,*prev;
};

///
/// 定时器类型
/// 
enum eTimerType
{
	eTimer1 = 10,
	eTimer2 ,
	eTimer3 
};

/// 
/// 定时器结点,tlist表示结点的指针,expires循环周期时间
/// etime 触发周期时间,pFun触发函数.
/// 
struct timernode
{
	ListNode    tlist;
	uint64_t       expires;
	uint64_t       etime;
	void        *pFun;
	enum eTimerType  eType;
};


/// 游戏事件基类
class   CGameEvent
{
public:
	virtual  long  TimeOut( eTimerType type) = 0;
};

#endif 