#include <stdio.h>
#include <stdlib.h>

#define NOCOPYABLE 1

// 拷贝构造函数设置为private后，该类不能进行复制操作和拷贝构造

class nocopyable {
private:
	nocopyable(const nocopyable& n) {}
	nocopyable(const nocopyable* n) {}
public:
	nocopyable() {}
	~nocopyable() {}
};

class A : public nocopyable {
public:
	A(const int _i):i(_i) {}
	A():i(99) {}

#if NOCOPYABLE == 1
private:
#endif
	A(A& a) 
	{
		printf("copy new \n");
		//if (*this == a) return *this;
		
		this->i = a.get_i();
	}
	
	A(A* a) 
	{
		printf("copy new *\n");
		if (this == a) return;
		
		this->i = a->get_i();
	}
	
public:	
	~A() {}
	
	int get_i() { return i; }
	void set_i(const int& _i) { i = _i; }
	
public: 
	A& operator=(A* rhs) 
	{
		if (rhs) {
			this->i = rhs->get_i();
			
			return *this;
		}
	}
	
private:
	int i;
};

int 
main(int argc, char **argv)
{
	A a, a_1(999);

	A a_2 = a_1;
	
	A* pa = new A(1000);
	
	A a_3(pa);
	
	a_3 = pa; /*a_3.operator=(pa)*/
	
	a_3.operator=(pa);
	
	system("pause");
	
	return 0;
}
