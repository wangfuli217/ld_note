#include <stdio.h>


class Data {
public:
	Data(int id, int age):_id(id), _age(age) {}
	~Data() {}
public:
	void CopyFrom(const Data& rsh) { //方法可以访问其他对象的private和protected的成员
		_age = rsh._age;
		_id = rsh._id;
	}
	
	void toString() {
		printf("id[%d] age[%d]\n", _id, _age);
	}
	
	static void swap(Data& lsh, Data& rsh) {
		lsh._id = rsh._id;
		lsh._age = rsh._age;
		rsh.inc_id();
	}
protected:
	int _age;
private:
	void inc_id() {
		_id *= 2;
	}
private:
	int _id;
};



int main(int argc, char **argv)
{
	Data data1(100, 29), data2(200, 39), data3(300, 49);
	
	data1.toString();
	data1.CopyFrom(data2);
	data1.toString();
	
	Data::swap(data1, data3);
	data1.toString();
	data3.toString();
	
	
	return 0;
}
