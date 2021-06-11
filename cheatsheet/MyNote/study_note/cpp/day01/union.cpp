#include<iostream>
#include<cstdio>
using namespace std;
int main(void)
{
	union   //匿名联合
	{
		int n;
		char c[sizeof(n)];
	};
	n=0x12345678;
	printf("%#x %#x %#x %#x\n",c[0],c[1],c[2],c[3]);
	swap(c[0],c[3]);
	swap(c[1],c[2]);
	cout<<hex<<showbase<<n<<endl;
	return 0;
}
