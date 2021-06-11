// PointerArray.cpp : 定义控制台应用程序的入口点。
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <iostream>

using namespace std;

struct B
{
	int i;
};


struct A
{
	B b[10];

	virtual void show()
	{
		cout << "Is a." << endl;
	}
};


int 
main(int argc, char* argv[])
{
	typedef void (A::*FUNC)();

	typedef void(*FUNC2)();

	B (A::*pName)[10] = &A::b;

	FUNC p1;
	FUNC2 p2;

	A aa;

	B* pb = aa.b;
	A* pAa = &aa;
	
	//p2 = &A::show;
	p1 = &A::show;

	(aa.*p1)();
	(pAa->*p1)();
	

	cout << "Name: " << (aa.*pName)[1].i << endl;
	cout << "i: " << (pb + 1)->i << endl;
	cout << "Name: " << ((aa.*pName + 1))->i << endl;


	char a[4][3][2] = {
		{{'a', 'b'}, {'c', 'd'}, {'e', 'f'}},
		{{'g', 'h'}, {'i', 'j'}, {'k', 'l'}},
		{{'m', 'n'}, {'o', 'p'}, {'q', 'r'}},
		{{'s', 't'}, {'u', 'v'}, {'w', 'x'}}
	};

	char b[2][2] = {{'1', '2'}, {'3', '4'}};
    

	char (*pppa)[2] = b; //也可以用&b[0]
    char(*ppppa)[2][2] = &b; //(char (*)[2][2])b
    
	char **ba = (char **)b; //ba 等同于 b

	char** bba = new char*[2];

	*(bba) = new char[3];
	*(bba + 1) = new char[3];

	strncpy(*(bba), "12", strlen("12") + 1);
	strncpy(*(bba + 1), "34", strlen("34") + 1);

	char (*pa)[2] = &a[1][0];//(char (*)[2])a // 指向 {'g', 'h''}  a[1][0] --> char*

	char (*ppa)[3][2] = &a[1];//也可以使用 a  或&a[0]// 指向 	{{'g', 'h'}, {'i', 'j'}, {'k', 'l'}}
    char (*pppppa)[4][3][2] =&a;


	char* p = new char[7];

	char (*ll)[3] = new char[2][3];


	printf("The Char : %c\n", *((*pa) +11));//*(*pa) 指向'g'，也就是a[1][0][0], *pa 就是数组名{'g', 'h'}
	
	//printf("The Char : %c\n", *(*(aa + 2)));

	//pa 指向 {'g', 'h'}   pa + 5 指向 {'q', 'r'}   *(pa + 5) 指向 'q' 地址也是代表{'q', 'r'}本身  *( pa + 5) + 1 指向 'r' 地址
	printf("A:%c\n", (*(*(pa + 5) + 1)));
	
	printf("B:%c\n", *(b[0] + 0));

	printf("The Char : %d\n", &a[2]);

	printf("The Cahr: %d*%c\n", &a[2][2][1], a[2][2][1]);

	printf("The Char:%c\n", *(*(*ppa) +11) );  //*(*ppa) 指向'g'地址
	printf("The Char:%c\n", *(*(*(ppa + 1 ) + 2) + 1)); //ppa 指向 {{'g', 'h'}, {'i', 'j'}, {'k', 'l'}}  ppa + 1 指向 {{'m', 'n'}, {'o', 'p'}, {'q', 'r'}}, *(ppa + 1) 指向 {'m', 'n'}  *(ppa + 1)  +2 指向 {'q', 'r'} *( *(ppa + 1) +2)指向 'q' 即 a[2][2][0],  *( *(ppa + 1 ) + 2 ) + 1 指向 'r'

	printf("A:%c\n", *( *( *ppa + 5 )  + 1)); 

	printf("The Char:%c\n", ***a);

	printf("b:%c\n", **b);//指向b[0][0]
	printf("b:%s\n", *b);//指向b[0][0]

	printf("B:%c\n", (*(pppa + 1))[0]);

	printf("B:%c\n", *(*(pppa) + 1)); //pppa {'1', '2'} 指向   *pppa指向 '1'  

	printf("B:%c\n", *(*(pppa + 1)));// *(pppa + 1) 类型为 char*

	printf("B:%c\n", *(*(*ppppa + 1))); // ppppa 就是 b   *ppppa 指向 {'1', '2'}  *ppppa + 1 指向 {'3', '4'}    *(*ppppa + 1) 指向 '3'

	printf("B:%c\n", *( *( *ppppa) + 2));

	printf("A--pppppa:%c\n", *( *(*(*pppppa + 2) + 2) + 1) ); //pppppa 就是a  *pppppa 指向 {{'a', 'b'}, {'c', 'd'}, {'e', 'f'}}

	printf("A--pppppa:%c\n", *( *(*(*pppppa)) + 17 ));

	printf("B:%c\n", *ba + 1);
	printf("B:%s\n", ba + 1);
	
	printf("bba:%s\n", *(bba + 1));
	
	return 0;
}


