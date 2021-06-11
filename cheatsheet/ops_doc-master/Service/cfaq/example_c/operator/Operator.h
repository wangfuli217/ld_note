#ifndef __OPERATOR_H_
#define __OPERATOR_H_

#include <iostream>
#include <string>
#include <stdio.h>

using namespace std;

class COperator
{
public:
	COperator();
	~COperator();
	
	COperator(int value):i(value) { s = "chenbo"; }
	
	COperator& operator =(const COperator& rh); /* 成员函数类型的操作符函数，一个隐式的参数this指针 */
	COperator& operator =(const int& value);
	
	COperator& operator*() { return *this;}
	string* operator->() { return &(this->s); }
	
	//fornt
	COperator& operator ++() { ++(this->i); return *this; }
	COperator& operator --() { ++(this->i); return *this; }
	
	//below 
	COperator& operator ++(int i) { this->i++; return *this; }
	COperator& operator --(int i) { this->i--; return *this; }
	
	COperator& operator +=(const COperator& rh) { this->i += rh.i; return *this; }
	COperator& operator -=(const COperator& rh) { this->i -= rh.i; return *this; }
	
	int operator()(int value) {this->i = value; return this->i; }
	
	COperator& operator << (const COperator& r) { this->i += r.i; return *this; }
	COperator& operator >> (COperator& r) {r.i += this->i; return r; }
	
	friend COperator operator +(const COperator& lh, const COperator& rh);
	friend COperator operator -(const COperator& lh, const COperator& rh);
	
	friend ostream& operator << (ostream& out, const COperator& r) { out << r.i; return out;}
	int Show() const { return i;} 
	
	operator int() { return i; } /* 类型转换操作符 */
	
	char& operator[](unsigned int i) { return this->s[i]; }  /* 这里返回引用可以对s的值按照索引进行改写 */
	
	string& operator()() { return this->s; }
	
	operator bool() const { return i ? true : false; }
	
	/* 必须定义为static 方法 new / delete 但是这里类的方法好像也可以，需要验证*/
	void* operator new(size_t size, const char* func) /* 重载类的new 操作符 只影响该类*/
	{
		printf("func: %s\n", func);
		return ::operator new(size);
	}
	
	void* operator new(size_t size, const std::nothrow_t& t) throw()
	{
		printf("func: %s\n", "nothrow");
		
		return ::operator new(size);
	}
	
	void* operator new(size_t size) /* 必须重载这个默认的new 否则 new class的时候会出错 */
	{
		printf("func: %s\n", __FUNCTION__);
		return ::operator new(size);
	}
	
	void* operator new[](size_t size, const char* func)
	{
		printf("func: %s\n", func);
		return ::operator new[](size);
	}
	
	void* operator new[](size_t size)
	{
		printf("func: %s\n", __FUNCTION__);
		return ::operator new[](size);		
	}
	
	void operator delete(void* ptr) /* 重载类的delete 操作符 只影响该类*/ 
	{
		printf("func: %s\n", __FUNCTION__);
		
		::operator delete(ptr);
	}
	
	void operator delete(void* ptr, const char* func) /* 这种形式无法实现调用,c++ 本身不支持这种调用，但是必须对应new实现 */
	{
		printf("func: %s\n", func);
		::operator delete(ptr);		
	}
	
	void operator delete(void* ptr, const std::nothrow_t& t) throw()
	{
		printf("func: %s\n", __FUNCTION__);
		::operator delete(ptr);		
	}
	
	void operator delete[](void* ptr) 
	{
		printf("func: %s\n", __FUNCTION__);
		::operator delete[](ptr);
	}
	
	void operator delete[](void* ptr, const char* func) 
	{
		printf("func: %s\n", __FUNCTION__);
		::operator delete[](ptr);
	}
public: /* 类的静态方法也可以 完成 new 重载 */
//	static void* operator new(size_t size, const char* func) /* 重载类的new 操作符 只影响该类*/
//	{
//		printf("func: %s\n", func);
//		::operator new(size);
//	}
//	
//	static void* operator new(size_t size) 
//	{
//		printf("func: %s\n", __FUNCTION__);
//		::operator new(size);
//	}
//	
//	static void operator delete(void* ptr) /* 重载类的delete 操作符 只影响该类*/ 
//	{
//		printf("func: %s\n", __FUNCTION__);
//		
//		::operator delete(ptr);
//	}
//	
//	static void operator delete(void* ptr, const char* func)
//	{
//		printf("func: %s\n", func);
//		::operator delete(ptr);		
//	}
	
private:
	int i;
	string s;
};

extern COperator operator +(const COperator& lh, const COperator& rh);
extern COperator operator -(const COperator& lh, const COperator& rh);

#endif