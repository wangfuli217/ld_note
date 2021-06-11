#include "Base.h"
#include <iostream>

using namespace std;

CBase::CBase(int _i)
	:i(_i)
{

}

CBase::~CBase()
{
	cout << "~CBase()" << endl;
}

void
CBase::Show()
{
	showme();
	name(); // base.name();
}

void
CBase::show_i()
{
	cout << "is base" << endl;
	cout << "i: " << i << endl;
}

void
CBase::showme()
{
	cout << "Is Base." << endl;
	cout << "I: " << i << endl;
}

void
CBase::version()
{
	cout << "CBase is big" << endl;
}

CDev::CDev(int _i, int _bi)
	:CBase(_bi),
	i(_i)
{

}

CDev::~CDev()
{
	cout << "~CDev()" << endl;
}

void
CDev::show_i()
{
	cout << "invoke base method: " << endl;
	CBase::show_i();
	cout << "is dev" << endl;
	cout << "i: " << i << endl;
}

void
CDev::showme()
{
	cout << "Is Dev" << endl;
	cout << "I: " << i << endl;
	cout << "I: " << CBase::i << endl; //调用基类的数据成员
}
