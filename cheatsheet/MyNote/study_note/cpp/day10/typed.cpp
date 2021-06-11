#include<iostream>
using namespace std;
#include<typeinfo>

int main(void)
{
	int x;
	cout<<typeid(x).name()<<endl;
	unsigned int y;
	cout<<typeid(y).name()<<endl;
	cout<<typeid(double[5]).name()<<endl;
	cout<<typeid(int (*)(char *,float)).name()<<endl;
	return 0;
}
