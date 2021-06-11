#include<iostream>
using namespace std;
void foo(int i)
{
	cout<<1<<endl;
	if(i==0)
		throw "出错啦";
	cout<<2<<endl;
}
void bar(void)
{
	cout<<3<<endl;
//	foo(1);   //5312467
	foo(0);   //531出错啦7
	cout<<4<<endl;
}
int main(void)
{
	try
	{
		cout<<5<<endl;
		bar();
		cout<<6<<endl;
	}
	catch(char const *ex)
	{
		cout<<ex<<endl;
	}
	cout<<7<<endl;
	return 0;
}
