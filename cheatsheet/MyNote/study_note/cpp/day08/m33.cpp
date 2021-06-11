#include<iostream>
#include<iomanip>
using namespace std;

class M33
{
	public:
		M33(void)
		{
			for(int i=0;i<3;i++)
				for(int j=0;j<3;j++)
					m_a[i][j]=0;
		}
		M33(int a[][3])
		{
			for(int i=0;i<3;i++)
				for(int j=0;j<3;j++)
					m_a[i][j]=a[i][j];
		}
		friend ostream & operator<<(ostream &os,M33 const& m)
		{
			for(int i=0;i<3;i++)
			{
				for(int j=0;j<3;j++)
					os<<setw(4)<<m.m_a[i][j];
				os<<endl;
			}
			return os;
		}
		M33 const operator+(M33 const& m) const
		{
			int a[3][3];
			for(int i=0;i<3;i++)
				for(int j=0;j<3;j++)
					a[i][j]=m_a[i][j]+m.m_a[i][j];
			return a;
		}
	private:
		int m_a[3][3];
};
int main(void)
{
	M33 m1;
	cout<<m1<<endl;
	int a1[3][3]={1,2,3,4,5,6,7,8,9};
	m1=a1;
	cout<<m1<<endl;
	int a2[3][3]={9,8,7,6,5,4,3,2,1};
	M33 m2(a2);
	cout<<m2<<endl;
	cout<<m1+m2<<endl;
	return 0;
}
