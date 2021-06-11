#include<iostream>
using namespace std;
template<typename T>
class A
{
	public:
		static void print(void)
		{
			cout<<&m_t<<endl;
		}
	private:
		static T m_t;
};
template<typename T>
T A<T>::m_t;
int main(void)
{
	A<int> ai1,ai2;
	A<double> ad1,ad2;
	ai1.print();
	ai2.print();
	ad1.print();
	ad2.print();
	return 0;
}
