#include <iostream>
using namespace std;
class Singleton {
public:
	static Singleton& getInstance (
		void) {
		return s_instance;
	}
private:
	Singleton (int data) :
		m_data (data) {}
	Singleton (
		Singleton const& that) {}
	static Singleton s_instance;
	int m_data;
};
Singleton Singleton::s_instance (1);
int main (void) {
//	Singleton singleton;
	Singleton& s1 =
		Singleton::getInstance ();
	cout << &s1 << endl;
	Singleton& s2 =
		Singleton::getInstance ();
	cout << &s2 << endl;
//	Singleton s3 = s2;
	return 0;
}
