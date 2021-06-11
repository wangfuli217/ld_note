#ifndef __SHARED_PTR_H_
#define __SHARED_PTR_H_

#include <memory>
#include <stdio.h>

using namespace std;

#define __CONSOLE__(fmt, args...) printf(fmt, ##args) 

class A {
public:
	A(int id):_id(id) {}
	~A() { __CONSOLE__("%s\n", __func__); }
	int ID() { return _id; }
private:
	int _id;
};

static void 
__A_deleter(A* pa) 
{
	__CONSOLE__("destory A\n");
	delete pa;
}

class Deleter {
public:
	//Deleter(Deleter&) { __CONSOLE__("is refenec %s\n", __func__); }
	//Deleter(Deleter&&) { __CONSOLE__("is moved %s\n", __func__); }
	Deleter() {}
	~Deleter() {}
	
	void operator() (A* pa) { __CONSOLE__("destory A\n"); delete pa; }
};

static void 
__shared_ptr()
{ 
	A *pa = new A(100);
	
	shared_ptr<A> sp(pa);
	__CONSOLE__("assign sp.\n");
	{
		#if 0 //不能通过指针对两个shared_ptr进行初始化，只能初始化一个，并通过shared_ptr间的赋值操作完成, 下面的操作将引发重复释放pa
		shared_ptr<A> sp2(pa);
		#else
		shared_ptr<A> sp2(sp);
		#endif
		__CONSOLE__("assign sp2.\n");
	}
	
	__CONSOLE__("ID: %d\n", sp->ID());
}

static void 
__shared_ptr_2()
{
	A a(100);
	
	shared_ptr<A> sp(&a); // 不用使用stack上的对象指针初始化shared_ptr
}


static void
__shared_ptr_3()
{
	shared_ptr<A> sp(new A(100), __A_deleter);
	shared_ptr<A> sp2(new A(100), Deleter());
}

#endif

