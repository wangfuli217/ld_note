#include<iostream>
using namespace std;

class Human
{
	public:
		Human(string const& name,int age):m_name(name),m_age(age)
		{
			cout<<"Human构造:"<<this<<endl;
			cout<<"m_name:"<<&m_name<<endl;
			cout<<"m_age:"<<&m_age<<endl;
		}
		void who(void) const
		{
			cout<<"我是一个叫"<<m_name<<"的人,今年"<<m_age<<"岁"<<endl;
		}
		void eat(string const &food) const
		{
			cout<<"我在吃"<<food<<"......"<<endl;
		}
		void sleep(void)
		{
			cout<<"我在睡觉..."<<endl;
		}
	protected:
		string m_name;
		int m_age;
};
class Student : public Human
{
	public:
		Student(string const& name,int age,int no):Human(name,age),m_no(no) 
		{
			cout<<"Student构造:"<<this<<endl;
		}
		void learn(string const& course) const
		{
			cout<<"我在学习"<<course<<"..."<<endl;
		}
		void who(void) const
		{
			cout<<"我是一个叫"<<m_name<<"的学生,今年"<<m_age<<"岁,"<<"我的学号是"<<m_no<<endl;
		}
	private:
		int m_no;
};
int main(void)
{
	cout<<"Humang的字节数:"<<sizeof(Human)<<endl;
	cout<<"Student的字节数:"<<sizeof(Student)<<endl;
	Student s1("张飞",25,1001);
	s1.who();
	s1.eat("盖饭");
	s1.sleep();
	s1.learn("C++");
	Human *ph=&s1;   //向上
	ph->who();
	ph->eat("KFC");
	ph->sleep();
	Student *ps=static_cast<Student*>(ph);  //向下
	ps->learn("UNIX");
	ps->who();
	Human h1=s1; //对象截切
	h1.who();
	h1.eat("饺子");
	h1.sleep();
	return 0;
}
