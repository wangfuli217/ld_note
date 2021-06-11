#include<iostream>
using namespace std;

int addsub(int x,int y,int *sub)
{
	*sub=x-y;
	return x+y;
}
int addsub(int x,int y,int &sub)
{
	sub=x-y;
	return x+y;
}
void swap1(int &x,int &y)
{
	int z=x;
	x=y;
	y=z;
}
int main(void)
{
	int sub=0;
	int add=addsub(123,456,&sub);
	cout<<add<<' '<<sub<<endl;
	add=addsub(123,456,sub);
	cout<<add<<' '<<sub<<endl;
	int a=100,b=200;
	swap(a,b);
	cout<<a<<' '<<b<<endl;
	return 0;
}
