#include <stdio.h>
#include <stdlib.h>

#define __SELF__ 	printf("%s\n", __PRETTY_FUNCTION__)
#define __ID__(obj) 	printf("ID: %d\n", obj.getId())

class Father {
public:
	Father(int _id):id(_id) {}
	Father():id(1) {}
	virtual ~Father() {}
	
	virtual void name() { __SELF__; }
	int getId() const { __SELF__; return id; }
protected:
	int id;
	
	void show() {} 
};

class Son : public Father {
public:
	Son(int _id):Father(_id + 1000), id(_id) {}
	virtual ~Son() {}
public:
	bool compare(const Son& f) 
	{
		return f.id == id;
	}
	
	int get_father_id() { __SELF__; return Father::id; }
	int getId() const { __SELF__; return id; }
protected:
	int id;
	virtual void name() { printf("Son\n"); }

};

class Son_2 : public Father {
public:
	Son_2(int _id):Father(_id + 1000), id(_id) {}
	virtual ~Son_2() {}
public:
	bool compare(const Father& f) 
	{
		//return f.id > id; 
		__SELF__;
		return f.getId() > id;
		/* 这里的代码只能访问本对象实例的基类的protected成员，不能访问其他对象实例的基类的保护成员
		 * 访问Father::id,也就是该实例对象的继承的基类的protected成员, 也就是说对象实例也没有权限访问protected 成员;
		 * */
	}
	
	bool compare(const Son_2& rsh) { // 同为Son_2 类的
		return id > rsh.id;
	}
	
	int get_father_id() { return Father::id; }
protected:
	int id;
};


int main(int argc, char **argv)
{
	Father 	f(100);
	Son		s(1000);
	Son		s1(1001);
	Son_2   s2(1002);
	
	//f.show(); /* 对象实例也不能访问protected类型的成员 这里主要看调用者的权限，这种调用者的权限是main函数，所以没有权限*/
	
	s.compare(s1);
	s2.compare(f);
	s2.compare(s1);
	
	printf("father: %d\n", s1.get_father_id());
	
	__ID__(f);
	__ID__(s);
	__ID__(s1);
	
	//int id = f->id;  //这里不允许，类的对象也没有访问protected 成员的权限，只有类的成员函数和友元函数才有权限
	
	Father *pf;
	
	pf = new Son(1000);
	pf->name();
	
#ifdef _WIN32	
	system("pause");
#endif
	return 0;
}
