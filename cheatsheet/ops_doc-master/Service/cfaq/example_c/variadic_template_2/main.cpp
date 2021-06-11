//=====================================
// Name        : CppPrimer.cpp
// Author      : Caroline
// Version     : 1.0
// Description : Example, UTF-8
//=====================================

/*eclipse cdt, gcc 4.8.1*/

#include <iostream>
#include <sstream>
#include <stdlib.h>

using namespace std;

//返回bug信息
template <typename T> std::string debug_rep (const T& t)
{
	std::ostringstream ret;
	ret << t;
	cout << t << endl;
	cout << ret.str() << endl;
	
	return ret.str();
}

//非可变参数模板
template<typename T>
std::ostream &print(std::ostream &os, const T &t)
{
	//std::cout << "This is nonvariadic function! ";
	return os << t;
}

//可变参数模板, "..."是包扩展(Pack Expansion)
template <typename T, typename... Args>
std::ostream &print(std::ostream &os, const T &t, const Args&... rest)
{
//	cout << "begin" << endl;
//	cout << "T: " << t; // t 就是每次unpack的参数
	cout << "size: " << sizeof...(rest) << endl;
	
	os << t << ", ";
	return print(os, rest...);
}

//函数模板的包扩展
template <typename... Args>
std::ostream &errorMsg(std::ostream &os, const Args&... rest)
{
	return print(os, debug_rep(rest)...); //使用模板的包扩展
}

int main()
{
	int 		i(10); 
	std::string s("girls");
	
	//print(std::cout, i, s, 42);
	errorMsg(std::cout, i, s, 10, "ladies");

	system("pause");
	return 0;
}
