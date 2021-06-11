#include <stdio.h>
#include <stdlib.h>

// 创建子类实例时，构造函数调用次序由基类开始到子类，析构函数反之

class Base {
public:
	Base() {}
	
	virtual ~Base() { printf("Base Freeed.\n"); }
	
	int val(int v = 1024) { printf("Base return val: %d\n", v); return v; }
protected:
	virtual int version() = 0;
};

class Dev : public Base {
public:
	Dev() {}
	 
	~Dev() { printf("Dev Freeed.\n");} // dev 作为中间基类可以有virtual，也可以不使用virtual 子类都可以正确释放
	
	/* 这里的virtual 可以不用添加，因为c++ 规定子类中和基本类声明一样的函数自动定义为virtual */
	int val(int v = 2048) { printf("Dev return val: %d\n", v); return v; } /* 这里不加virtual Dev类型的指针使用Son实例赋值后，只能调用Dev的val */
private:
	int version() { return 0; }
};


class Son : public Dev {
public:
	Son() {}
	~Son() { printf("Son Freeed\n"); }
	
	int val(int v = 4096) { printf("Son return val: %d\n", v); return v; }
};


class Base_1 {
public:
	Base_1() {}
protected:
	virtual ~Base_1() {}
};

class Dev_1 : Base_1 {
public:
	~Dev_1() {}
};

#define RN() printf("\n")

int
main(int argc, char **argv)
{
	{
		Dev d; /* 普通继承类的对象 基类如果没有虚析构函数也能正确释放 */
	}
		
	RN();
	
	{ // 基类指针指向子类对象时，如果基类没有虚析构函数的话，子类对象就不能正确释放
		Base* pb = new Dev; /* 这里出现问题如果基类的析构函数没有声明为virtual，这里不能正确释放Dev的对象部分, 就是使用基类的指针操作子类的对象时 */
		delete pb;
	}
	
	RN();
	
	{
		Dev* pd = new Dev;
		delete pd;
	}
	
	RN();
	//验证虚函数的默认参数
	{
		Base* pb  = new Dev;
		
		pb->val(); /* 这里的参数默认值是1024，函数的调用时动态的，但是参数的赋值是静态的，这里默认参数采用Base::val的1024进行赋值 */
		
		Dev* pd = new Dev;
		
		pd->val();
		
		delete pb;
		delete pd;
	}
	
	RN();	
	/* 虚拟函数继承了“调用者所属类类型”  调用者是当前函数，所以没有权限调用析构函数 */
	{
//		Base_1* pd = new Dev_1;
//		1
//		delete pd;
	}

	RN();	
	{
		Base* pb = new Son;
		pb->val();
		
		delete pb;
	}
	
	RN();
	{
		Dev* pd = new Son; // Dev 没有虚析构函数的话也能正确释放子类对象；
		pd->val();
		
		delete pd;			
	}
	
	system("pause");
	
	return 0;
}
