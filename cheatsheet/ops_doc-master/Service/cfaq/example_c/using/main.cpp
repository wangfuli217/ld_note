#include <stdio.h>
#include <iostream>

//using out = std::cout;
//using end = std::endl;

class Father {
public:
	Father():id(100) {}
	~Father() {}
private:
	int id;
};

class Son : public Father {
public:
	Son() {}
	~Son() {}
	int getId() { return id; }
	using Father::id;
};

int main(int argc, char **argv)
{
	//out << "hello" << end;
	
	
	return 0;
}
