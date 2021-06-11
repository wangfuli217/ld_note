#include<iostream>
using namespace std;
int main(void)
{
	int a=10;
	int &b=a;
	int &c=b;
	cout<<&a<<endl<<&b<<endl<<&c<<endl;
	++b;
	c++;
	cout<<a<<endl;
	int const &d=c;
	cout<<&d<<endl;
	const int &r=10;
	//int &f=a+b;   将亡右值,错误
	return 0;
}
