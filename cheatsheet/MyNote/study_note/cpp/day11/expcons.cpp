#include<iostream>
#include<cstdio>
using namespace std;

class A
{
	public:
		A(void)
		{
			cout<<"A构造"<<endl;
		}
		~A(void)
		{
			cout<<"A析构"<<endl;
		}
};
class B
{
	public:
		B(void)
		{
			cout<<"B构造"<<endl;
			FILE *fp=fopen("none","r");
			if(!fp)
				throw -2;
			fclose(fp);
		}
		~B(void)
		{
			cout<<"B析构"<<endl;
		}
};
int main(void)
{
	try
	{
		B b;
	}
	catch(int &ex)
	{
		cout<<ex<<endl;
	}
	return 0;
}
