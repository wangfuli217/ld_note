#include<iostream>
using namespace std;
class A{
	public:
		/*A(int data)
		{
			m_data=data;
		}*/
		int m_data;
		string m_str;
};
int main(void)
{
	A a;
	cout<<a.m_data<<'['<<a.m_str<<']'<<endl;
	return 0;
}
