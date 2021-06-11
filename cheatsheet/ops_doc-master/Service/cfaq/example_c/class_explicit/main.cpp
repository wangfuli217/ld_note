#include <stdio.h>

class A {
public:
	explicit A(int* p):_data(p) { printf("%s\n", __PRETTY_FUNCTION__); }
	explicit A():_data(NULL) { printf("%s\n", __PRETTY_FUNCTION__); }
	A& operator=(const A& lsh) { printf("%s\n", __PRETTY_FUNCTION__); }
	A(const A& lsh) { *this = lsh; printf("%s\n", __PRETTY_FUNCTION__); }
	~A() {}
	
	int* data() { if (_data == NULL) _data = new int; return _data; }
private:
	//A():_data(NULL) {}
	//A() {}
private:
	int *_data;
};

int main(int argc, char **argv)
{
	//A a;
	A a1;
	//A a2("aaaa");
	// A a1() 这种方式只能编译通过，实际运行的时候不能正确创建对象实例，动态new 生成对象是OK的。
	
	//printf("A: %p\n", &a1);
	
	A *pa = new A();
	
	int *pp = new int();
	
	int *p = pa->data();
	
	*pp = *p;
	
	return 0;
}
