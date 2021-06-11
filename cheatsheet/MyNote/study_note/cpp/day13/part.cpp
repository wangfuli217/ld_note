#include<iostream>
using namespace std;

template<typename A,typename B>
class X
{
	public:
		static void foo(void)
		{
			cout<<"X<A,B>"<<endl;
		}
};
template<typename A>
class X<A,short>
{
	public:
		static void foo(void)
		{
			cout<<"X<A,short>"<<endl;
		}
};
int main(void)
{
	X<int,int>::foo();
	X<int,short>::foo();
	return 0;
}
