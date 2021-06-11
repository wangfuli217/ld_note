#include<iostream>
using namespace std;
class Student
{
	public:
		//缺省构造函数,决定了对象的缺省标志,无参构造函数
		Student(void){
			m_name="没想好";
			m_age=0;
		}
		Student(string const &name)
		{
			m_name=name;
			m_age=0;
		}
		Student(string const&name,int age)
		{
			m_name=name;
			m_age=age;
		}
		void setName(string const &name)
		{
			if(name!="二")
				m_name=name;
			else
				m_name="习近平";
		}
		void setAge(int age)
		{
			if(age>0)
				m_age=age;
		}
		void who(void)
		{
			cout<<"我是"<<m_name<<",今年"<<m_age<<"岁"<<endl;
		}
	private:
		string m_name;
		int m_age;
};
int main(void)
{
	Student s1;
	s1.setName("二");
	s1.setAge(25);
	s1.who();
	Student s2("李白",34);
	s2.who();
	Student sa[3]={Student("关羽",40),Student("刘备",50),Student("曹操",60)};
	sa[0].who();
	sa[1].who();
	sa[2].who();
	Student *ps=new Student[3]{Student("黄忠",45),Student("马超",55),Student("孔明",65)};
	ps[0].who();
	ps[1].who();
	ps[2].who();
	delete[] ps;
	Student s3;
	s3.who();
	Student s4("李二");
	s4.who();
	return 0;
}
