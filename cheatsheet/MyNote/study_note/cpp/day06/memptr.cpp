#include <string.h>
#include <iostream>
using namespace std;
class A {
public:
	A (void) {}
	A (int a, int b, int c, int d) :
		m_a (a), m_b (b), m_c (c),
		m_d (d) {}
	int m_a; // 4
	int m_b; // 4
	int m_c;
	int m_d;
private:
	int foo (int x) {
		return (m_a + m_b + m_c +
			m_d) * x;
	}
public:
	typedef int (A::*PFN) (int);
	static PFN bar (void) {
		return &A::foo;
	}
};
int main (void) {
	int A::*p1 = &A::m_d;
	int i;
	memcpy (&i, &p1, 4);
	cout << i << endl;
	A a1, a2, *pa;
	a1.*p1 = 10;
//	*(&a1+p1) = 10;
	a2.*p1 = 20;
//	*(&a2+p1) = 20;
	cout << a1.m_d << endl; // 10
	cout << a2.m_d << endl; // 20
	pa = &a1;
	++(pa->*p1);
//	++(*(pa+p1));
	cout << a1.m_d << endl; // 11
	pa = &a2;
	(pa->*p1)--;
//	(*(pa+p1))--;
	cout << a2.m_d << endl; // 19
//	int (A::*pfn) (int) = &A::foo;
	int (A::*pfn) (int) = A::bar ();
	memcpy (&i, &pfn, 4);
	cout << hex << showbase << i
		<< endl;
	A a3 (1, 2, 3, 4);
	cout << dec << (a3.*pfn) (5) << endl;
//	pfn (&a3, 5)
	A* a4 = new A (10, 20, 30, 40);
	cout << (a4->*pfn) (50) << endl;
//	pfn (a4, 50)
	return 0;
}
