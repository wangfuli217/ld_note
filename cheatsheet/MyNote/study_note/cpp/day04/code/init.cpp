#include<iostream>
#include<cstdio>
using namespace std;
class Calc
{
	public:
		Calc(int a,int b):m_a(a),m_b(b)
		{
		}
		int add(void)
		{
			return m_a+m_b;
		}
		int sub(void)
		{
			return m_a-m_b;
		}
	private:
		int m_a;
		int m_b;
};
class Date
{
	public:
		Date(int y=2000,int m=1,int d=1):m_y(y),m_m(m),m_d(d){}
		string toString(void)
		{
			char str[256];
			sprintf(str,"%d年%d月%d日",m_y,m_m,m_d);
			return str;
		}
	private:
	int m_y,m_m,m_d;
};
class Student
{
	public:
		Student(string const& name):m_name(name){}
		Student(string const& name,int y,int m,int d):m_name(name),m_bday(y,m,d){}
		void print(void)
		{
			cout<<"姓名:"<<m_name<<endl;
			cout<<"生日:"<<m_bday.toString()<<endl;
		}
	private:
		string m_name;
		Date m_bday;
};
int main(void)
{
	Calc c1(123,456);
	cout<<c1.add()<<endl;
	cout<<c1.sub()<<endl;
	Student s("张飞");
	s.print();
	Student s2("赵云",1992,3,8);
	s2.print();
	return 0;
}
