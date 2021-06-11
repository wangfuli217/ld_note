#include <stdio.h>
#include <iostream>
#include <stdlib.h>

using namespace std;

class Base {
public:
	virtual void f() { cout << "Base::f" << endl; }
	virtual void g() { cout << "Base::g" << endl; }
	virtual void h() { cout << "Base::h" << endl; }
 
};

typedef void (*F)(void);
typedef F** farray_t;

static void
vtable_test_2()
{
	Base        b;
	farray_t    ft;
    
	int** pvt = (int**)&b; // vtable address是一个二维数组，数组元素是函数指针
	ft = (farray_t)&b;
    
	printf("vtable address: %p\n", pvt);
	printf("function: %p\n", *(pvt + 0) + 0);
	printf("function: %p\n", *(pvt + 0) + 1);
	printf("function: %p\n", *(pvt + 0) + 2);
    
    printf("function: %p\n", *(ft + 0) + 0);
	printf("function: %p\n", *(ft + 0) + 1);
	printf("function: %p\n", *(ft + 0) + 2);
	
	F f = (F)(*(*(pvt + 0) + 0)); // pvt[0][0]
	f();
	
	F g = (F)(*(*(pvt + 0) + 1));
	g();
	
	F h = (F)(*(*(pvt + 0) + 2));
	h();
}

int main(int argc, char **argv)
{
	typedef void(*Fun)(void);

	Base b;

	Fun pFun = NULL;

	cout << "vtable address：" << (int*)(&b) << endl; /* vtable 是一个指向函数指针数组的指针 */
	cout << "vtable function address：" << (int*)*(int*)(&b) << endl; /* 获取虚函数的函数指针数组的首地址 */

	// Invoke the first virtual function 
	pFun = (Fun)*(int*)*(int*)&b; // (Fun)(int*)*(int*)(&b)[0]
	pFun();
	
	Fun g = (Fun)(((int*)*(int*)(&b))[1]); //(Fun)*((int*)*(int*)&b + 1); // 
	g();
	
	
	vtable_test_2();
	
	system("pause");
	
	return 0;
}
