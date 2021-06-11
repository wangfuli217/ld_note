#include<iostream>
using namespace std;

void foo(void) throw (int,double,char const *)
{
//	throw 1;
//	throw 3.14;
	throw "hello,world";
}
int main(void)
{
	try
	{
		foo();
	}
	catch(int &ex)
	{
		cout<<ex<<endl;
	}
	catch(double &ex)
	{
		cout<<ex<<endl;
	}
	catch(char const* &ex)
	{
		cout<<ex<<endl;
	}
	return 0;
}
