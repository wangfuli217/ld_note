#include<iostream>
#include<stdexcept>
#include<cstdio>
using namespace std;

class FileException:public exception
{
	public:
		char const* what(void) const throw ()
		{
			return "文件操作异常!";
		}
};
void foo(void)
{
	FILE *fp=fopen("none","r");
	if(!fp)
		throw FileException();
	char *buf=new char[0xFFFFFFFF];
	delete[] buf;
	fclose(fp);
}
int main(void)
{
	try
	{
		foo();
	}
	catch(exception &ex)
	{
		cout<<ex.what()<<endl;
	}
	return 0;
}
