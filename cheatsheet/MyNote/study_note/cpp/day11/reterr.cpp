#include<iostream>
#include<cstdio>
using namespace std;

int fun3(char const* path)
{
	FILE* fp=fopen(path,"r");
	if(!fp)
		return -1;
	fclose(fp);
	return 0;
}
int fun2(char const* path)
{
	if(fun3(path)==-1)
			return -1;
	return 0;
}
int fun1(char const* path)
{
	if(fun2(path)==-1)
		return -1;
	return 0;
}
int main(int argc,char *argv[])
{
	if(argc<=1)
		return -1;
	if(fun1(argv[1])==-1)
	{
		cout<<"文件打开失败"<<endl;
		return -1;
	}
	return 0;
}
