#include<iostream>
#include<cstring>
using namespace std;

class String
{
	public:
		String(char const* str):m_str(strcpy(new char[strlen(str?str:"")+1],str?str:"")){}
		char const* c_str(void) const
		{
			return m_str;
		}
		char &at(size_t i)
		{
			return m_str[i];
		}
		~String(void)
		{
			if(m_str)
			{
				delete[] m_str;
				m_str=NULL;
			}
		}
	private:
		char  *m_str;
};
int main(void)
{
	String str("hello,world!");
	cout<<str.c_str()<<endl;
	str.at(6)='9';
	cout<<str.c_str()<<endl;
//	String str(NULL);
	return 0;
}
