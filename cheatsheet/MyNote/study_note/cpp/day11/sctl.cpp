#include<iostream>
#include<cmath>
#include<iomanip>

using namespace std;

int main(void)
{
	cout<<cout.precision()<<endl;
	cout<<sqrt(200)<<endl;
	cout<<setprecision(10)<<sqrt(200)<<endl;
	cout.setf(ios::scientific,ios::floatfield);
	cout<<sqrt(200)<<endl;
	cout.width(10);
	cout.fill('-');
	cout.setf(ios::showpos);
	cout.setf(ios::internal,ios::adjustfield);
	cout<<12345<<endl;
	return 0;
}
