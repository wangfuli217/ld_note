#include<cstdlib>
#include<cstring>
#include<iostream>
#include<typeinfo>
using namespace std;

//两个任意类型对象的最大值
template<typename T>
T const& max(T const& x,T const &y)
{
	cout<<"1"<<' '<<typeid(x).name()<<endl;
	return x<y?y:x;
}
//两个任意类型指针所指向的目标对象的最大值
template<typename T>
T* const& max(T* const& x,T* const& y)
{
	cout<<"2"<<' '<<typeid(x).name()<<endl;
	return *x<*y?y:x;
}
//两个C风格字符串的最大值
char const* const& max(char const* const& x,char const* const& y)
{
	cout<<"3"<<' '<<typeid(x).name()<<endl;
	return strcmp(x,y)<0?y:x;
}
int main(void)
{
	char const* x="abc";
	char const* y="ab";
	char const* z="a";
	cout<<::max(x,y)<<endl;   //3
	cout<<::max(100,200)<<endl; //1
	//通过模板参数表告知编译器使用函数模板,类型针对性强的版本优先
	cout<<::max<>(y,x)<<endl;   //2
	return 0;
}
