#include<iostream>
using namespace std;

class Array
{
	public:
		void set_desc(string const &desc)
		{
			m_desc=desc;
		}
		void print(void) const
		{
			cout<<m_desc<<":";
			for(size_t i=0;i<5;i++)
				cout<<m_array[i]<<' ';
			cout<<endl;
		}
		int& at(size_t i)
		{
			return m_array[i];
		}
	private:
		string m_desc;
		int m_array[5];
};
void foo(Array const& array)
{
	array.print();
}
int main(void)
{
	Array arr;
	arr.set_desc("成绩");
	arr.print();
	foo(arr);
	arr.at(0)=100;
	arr.at(1)=200;
	arr.at(2)=300;
	arr.at(3)=400;
	arr.at(4)=500;
	arr.print();
	return 0;
}
