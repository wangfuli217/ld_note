#include <iostream>
#include <stdio.h>
#include "Base.h"

using namespace std;

//动态绑定与多态只能使用类的指针和类的引用才能实现，普通的类对象不能使用动态绑定

int main(int argc, char **argv)
{
	CBase* pBase = new CDev(2, 9); // base : 2 dev: 9

	pBase->Show();
	pBase->show_i(); /* 虚函数 调用子类的方法 */
	pBase->age(); /* 非虚函数不是动态绑定，调用基类的方法 */

	delete pBase;

	printf("**************************1\n");

	CDev* pDev = new CDev(2, 9);
	pDev->age(); // 子类的Age 方法，静态绑定
	pDev->Show();
	pDev->show_i();

	delete pDev;

	printf("**************************2\n");

	pBase = new CBase(1);

	pBase->Show();
	pBase->show_i(); /* 调用基类的方法 */
	pBase->age(); /* 非虚函数不是动态绑定，调用基类的方法 */

	delete pBase;

	printf("\n");

	CDev dev(2, 10);

	dev.age();

	CBase::version();

	int i;

	cin >> i;
}
