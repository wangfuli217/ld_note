#include <iostream>

using namespace std;
class person {
private:
	int age;
public:
	person(int a) {
		this->age = a;
	}
	//友元函数，这样才能调用该类私有成员
	friend bool operator==(person const &p1, person const & p2);
};

//满足要求，做操作数的类型被显示指定
bool operator==(person const &p1, person const & p2) {
	if (p1.age == p2.age)
		return true;
	return false;
}

int main() {

	person rose(18);
	person jack(23);

	if(rose==jack)
		cout << "the age is equal !"<< endl;
	else
		cout << "the age isn't equal !"<< endl;

	return 0;

}
