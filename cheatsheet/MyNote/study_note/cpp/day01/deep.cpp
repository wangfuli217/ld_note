#include<iostream>
using namespace std;
namespace ns1
{
	namespace ns2
	{
		namespace ns3
		{
			extern int var;
			void fun(void);
			/*int var=123;
			void fun(void)
			{
				cout <<"fun"<<endl;
			}*/
		}
	}
}
int ns1::ns2::ns3::var=123;
namespace ns123=ns1::ns2::ns3;
void ns123::fun(void)
{
	cout<<"fun"<<endl;
}
int main(void)
{
	cout << ns123::var << endl;
	ns1::ns2::ns3::fun();
	using namespace ns1::ns2::ns3;
	cout<<var<<endl;
	fun();
	return 0;
}
