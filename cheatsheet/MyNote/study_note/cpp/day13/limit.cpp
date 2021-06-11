#include<iostream>
using namespace std;

template<int x> void foo(void)
{
	cout<<x<<endl;
}
template<double x> void foo1(void)
{
	cout<<x<<endl;
}
int main(void)
{
	foo<3>();
	foo1<3.13>();
	return 0;
}
