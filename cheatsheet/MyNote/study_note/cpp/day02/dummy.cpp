#include<iostream>
using namespace std;
void foo(void)
{
	cout<<"Hello,World!"<<endl;
}
//哑元参数
void foo(int)
{
	cout<<"Hello,Linux!"<<endl;
}
int main(void)
{
	foo();
	foo(3);
	return 0;
}
