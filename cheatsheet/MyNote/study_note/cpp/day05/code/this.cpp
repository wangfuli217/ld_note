#include<iostream>
using namespace std;

class User
{
	public:
		User(string const& name,int age):m_name(name),m_age(age)
		{
			cout<<"构造函数"<<this<<endl;
		}
	private:
		string m_name;
		int m_age;
};
int main(void)
{
	User user("hahaha",32);
	cout<<"main函数"<<&user<<endl;
	return 0;
}
