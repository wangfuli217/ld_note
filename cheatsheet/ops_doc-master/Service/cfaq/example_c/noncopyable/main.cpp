#include <stdio.h>
#include <stdlib.h>

class noncopyable {
protected:
	noncopyable() {}
	~noncopyable() { printf(__FUNCTION__); }
private:
	noncopyable(const noncopyable& r);
	const noncopyable& operator=(const noncopyable& r);
};

class A : public noncopyable {
public:
	A(int _i):i(_i) {}
	~A() {}
public:
	void show() { printf("I: %d\n", i); }
private:
	int i;
};

class B : public noncopyable { /* 子类定了自己的拷贝构造和operator=后，可以绕过这个限制 */
public:
	B(int _i):i(_i) {}
	~B() {}
public:
	B(const B& r) 
	{
		this->i = r.i;
	}
	
	const B& operator=(const B& r) 
	{
		this->i = r.i;
		
		return *this;
	}

	void show() { printf("I: %d\n", i); }
private:
	int i;
};

int main(int argc, char **argv)
{
	{
		A a(100);
	}
	
	A a(100);
//	A b(a); /* 这里error */
	A b = a; /* 这里error */

	A *p = new A(99);
	p->show();
	
	delete p;
	
	{
		B b(99);
		B bb(100);
		b = bb;
	}
	
	
	system("pause");
	
	return 0;
}
