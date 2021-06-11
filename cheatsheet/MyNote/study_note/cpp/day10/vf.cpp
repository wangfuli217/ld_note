#include<iostream>
using namespace std;
int calc(int x,int y,int (*fun)(int,int))
{
	return fun(x,y);
}
int add(int x,int y)
{
	return x+y;
}
int sub(int x,int y)
{
	return x-y;
}
class Calc
{
	public:
		virtual int calc(int x,int y)=0;
};
class Add:public Calc
{
	public:
		int calc(int x,int y)
		{
			return x+y;
		}
};
class Sub:public Calc
{
	public:
		int calc(int x,int y)
		{
			return x-y;
		}
};
int calc(int x,int y,Calc &c)
{
	return c.calc(x,y);
}
int main(void)
{
	cout<<calc(123,456,add)<<endl;
	cout<<calc(456,123,sub)<<endl;
	cout<<calc(123,456,Add())<<endl;
	cout<<calc(123,456,Sub())<<endl;
	return 0;
}
