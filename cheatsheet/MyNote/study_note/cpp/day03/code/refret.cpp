#include<iostream>
using namespace std;

int x=0;
int &foo(void)
{
	return x;
}
int main(void)
{
	foo()=3;
	cout<<x<<endl;
	return 0;
}
