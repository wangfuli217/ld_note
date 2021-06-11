#include<iostream>
using namespace std;
struct User
{
	//成员变量
	char name[256];
	int age;
	//成员函数
	void who(void)
	{
		cout<<name<<' '<<age<<endl;
	}
};
int main(void)
{
    User user={"zhangfei",25},*puser=&user;
	cout<<user.name<<' '<<user.age<<endl;
	cout<<puser->name<<' '<<puser->age<<endl;
	user.who();
	puser->who();
	cout<<sizeof(user)<<' '<<endl;
	return 0;
}
