#include <iostream>

using namespace std;
class person {
private:
	int age;
public:
	person(int a) {
		this->age = a;
	}
	//��Ԫ�������������ܵ��ø���˽�г�Ա
	friend bool operator==(person const &p1, person const & p2);
};

//����Ҫ���������������ͱ���ʾָ��
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
