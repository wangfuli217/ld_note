#include<iostream>
using namespace std;
int g=123;
void bar(int a=g,int b=400+56)
{
	cout<<a<<' '<<b<<endl;
}
void foo(int a=123,int b=456)
{
	cout<<a<<' '<<b<<endl;
}
/*void hum(int a,int b=a)
{
}*/
void fun(int x=899);
void fun(int x)
{
	cout <<x<<endl;
}
/*void han(void)
{
	cout<<1<<endl;
}*/
void han(int x=345)
{
	cout<<2<<endl;
}
int main(void)
{
	foo(100,200);
	foo(100);   //foo(100,456);
	foo();		//foo(123,456);
	bar();
	//hum(100);  错误
	fun();
	han();
	return 0;
}
