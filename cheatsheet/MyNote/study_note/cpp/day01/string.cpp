#include<iostream>
#include<cstring>
#include<string>
using namespace std;
int main(void)
{
	string s1;
	cout<<'['<<s1<<']'<<endl;
	string s2("hello,world!");
	cout<<'['<<s2<<']'<<endl;
	string s3="字面值表示的字符串";
	cout<<s3<<endl;
	char const* ps="字符指针表示的字符串";
	s3=ps;
	cout<<s3<<endl;
	char sa[]="字符数组表示的字符串";
	s3=sa;
	cout<<s3<<endl;
	s3="12345";
	cout<<strlen(s3.c_str())<<endl;
	string s4("ABCDEFGHIGKlsdkjflksjdlfsdfllskdflksldfk");
	s3=s4;
	cout<<s3<<endl;
	s3=s3+"12345";
	cout<<s3<<endl;
	s3+=s1+=s2;
	cout<<s3<<endl;
	string s8="abcd",s9="abCd";
	if(s8>s9)
		cout<<s8<<">"<<s9<<endl;
	string s10="北京",s11="上海";
	cout<<(s10<s11)<<endl;
	s4[1]='3';
	cout<<s4<<endl;
	cout<<s4.size()<<endl;
	s4.resize(10);
	cout<<s4<<endl;
	s4.clear();
	cout<<'['<<s4<<']'<<endl;
	return 0;
}
