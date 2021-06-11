/** 
 *	@brief: 定时器管理类,管理定时器的五个轮子
 *          实现方式参考linux的中断处理，每次触发只触发第一个轮子的结点。
 *
 *  @Author:Expter
 *	@Date : 03/02/2010
 */


#include "LinkList.h"
#include <stdint.h>

#define  ListProp(g, tv,n)\
	g[n-1] = tv##n

#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)

#define container_of(ptr, type, member) ({            		\
    const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
    (type *)( (char *)__mptr - offsetof(type,member) );})

///
/// 定时器管理类,管理定时器的五个轮子
/// 
class CTimer
{
public:	
	///
	///  构造函数如下
	/// 
	CTimer(void);

	CTimer( int second);

	~CTimer(void);

public:
	///
	/// 初始化定时器管理类
	///
	void  Init(int Second = 0);

	///
	/// 增加一个定时器
	///
	void  add_timer(timernode *times );

	///
	///	检测定时器是否存在
	///
	/// @return  如果存在返回true,否则为false
	/// 
	bool  check_timer(timernode* times);

	///
	///	删除定时器
	///
	/// @return  如果删除成功返回true,否则为false
	///
	bool  delete_timer(CLinkList* list, timernode *times);

	///
	/// 重新初始化一个定时器
	///
	void  init_timer(timernode* timers);

	///
	/// 定时器的迁移，也即将一个定时器从它原来所处的定时器向量迁移到另一个定时器向量中。
	///
	void  cascade_timer(CLinkList* timers);

	///
	/// 执行当前已经到期的定时器,所有小于jeffies的定时器
	///
	void  Expires( uint64_t  jeffies);

	///
	/// 重新初始化一个定时器
	///
	void  Cancel(timernode* timers);

	///
	/// 重新计算一个定时器
	///
	void  Mod_timer(timernode* timers);

private:
	/// 5个轮子
	CLinkList*    m_tv1;
	CLinkList*    m_tv2;
	CLinkList*    m_tv3;
	CLinkList*    m_tv4;
	CLinkList*    m_tv5;
	CLinkList**   g_vecs;

	/// 定时器全局tick
	uint64_t		  m_jeffies;
    /// 上次运行时间
 	uint64_t		  m_Lasttime;
	/// 精确到毫秒
	uint64_t		  m_mSecond;
};
