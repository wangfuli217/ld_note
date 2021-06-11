#include<iostream>
using namespace std;
void foo(void)
{
	cout<<1<<endl;
}
void foo(double x)
{
	cout<<4<<endl;
	return 0;
}
void const* foo(double x,int y)
{
	return 0;
}
int main(void)
{
	void const* (*pfoo) (double x,int y)=foo;
	return 0;
}
