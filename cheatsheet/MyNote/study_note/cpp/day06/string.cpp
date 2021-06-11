#include <cstring>
#include <iostream>
using namespace std;
class String {
public:
	String (char const* str) :
		m_str (strcpy (new char[
		strlen (str ? str : "") + 1],
		str ? str : "")) {}
	// 支持深拷贝的拷贝构造函数
	String (String const& that) :
		m_str (strcpy (new char[
		strlen (that.m_str) + 1],
		that.m_str)) {}
	// 支持深拷贝的拷贝赋值运算符函数
	String& operator= (
		String const& rhs) {
		// 防止自赋值
		if (&rhs != this) {
			/* 程序员
			// 分配新资源
			char* str = new char[
				strlen(rhs.m_str)+1];
			// 释放旧资源
			delete[] m_str;
			// 拷贝新内容
			m_str = strcpy (str,
				rhs.m_str);
			*/
			// 老油条
			String str = rhs;
			swap (m_str, str.m_str);
		}
		return *this; // 返回自引用
	}
	~String (void) {
		if (m_str) {
			cout << this << ' '
				<< (void*)m_str
				<< endl;
			delete[] m_str;
			m_str = NULL;
		}
	}
	char const* c_str (void) const {
		return m_str;
	}
	char& at (size_t i) {
		return m_str[i];
	}
private:
	char* m_str;
};
int main (void) {
	String str ("Hello, World !");
	cout << str.c_str () << endl;
	str.at (7) = 'w';
	cout << str.c_str () << endl;
	/*
	char* p = NULL;
	// ...
	String str (p);*/
	String s1 = "abcdef";
	cout << s1.c_str () << endl;
	/*
	String s2 = s1; // 拷贝构造
	s1.at(0) = 'A'; 
	cout << s2.c_str () << endl;
	*/
	String s3 = "123456";
	s1 = s3; // 拷贝赋值
//	s1.operator= (s3);
	s3.at (0) = '0';
	cout << s1.c_str () << endl;
	s1 = s1;
//	s1.operator= (s1);
	int a = 1, b = 2, c = 3;
	(a = b) = c;
	cout << a << ' ' << b << ' '
		<< c << endl; // 3 2 3
	String s2 = "xyz";
	(s1 = s2) = s3;
//	s1.operator= (s2).operator= (s3);
	return 0;
}
