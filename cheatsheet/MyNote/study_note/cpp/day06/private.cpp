#include <iostream>
using namespace std;
class Integer {
public:
	Integer (int i = 0) :
		m_i (new int (i)) {}
	/*
	Integer (Integer const& that) :
		m_i (new int (*that.m_i)) {}
	Integer& operator= (
		Integer const& rhs) {
		*m_i = *rhs.m_i;
		return *this;
	}
	*/
	~Integer (void) {
		delete m_i;
	}
	int const & get (void) const {
		return *m_i;
	}
	void set (int const& i) {
		*m_i = i;
	}
private:
	Integer (Integer const&);
	Integer& operator= (
		Integer const&);
	int* m_i;
};
int main (void) {
	Integer i1 (100), i2 = i1;
	cout << i1.get () << endl;
	cout << i2.get () << endl;
	i2.set (200);
	i1 = i2;
	cout << i1.get () << endl;
	return 0;
}
