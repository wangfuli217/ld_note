#include <iostream>

using namespace std;

class person {
private:
	int age;
public:
	person(int a) {
		this->age = a;
	}
	bool operator ==(const person &ps) const;
};

bool person::operator ==(const person &ps) const {
	if (this->age == ps.age)
		return true;
	return false;
}

int main() {

	person p1(10);
	person p2(20);

	if(p1 == p2)
		cout << "the age is equal !"<< endl;
	else
		cout << "the age isn't equal !"<< endl;
	return 0;

	return 0;
}
