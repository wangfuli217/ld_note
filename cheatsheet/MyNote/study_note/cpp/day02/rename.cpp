#include<iostream>
using namespace std;

void foo(int i)
{
	cout<<i<<endl;
}
void foo(int i,double d)
{
	cout<<i<<' '<<d<<endl;
}
int main(void)
{
	foo(1);
	foo(1,2.);
	return 0;
}
