#include <stdio.h>
#include <string>

using std::string;

struct Data {
	int 		id;
	string 		name;
	mutable int age;
};

int 
main(int argc, char **argv)
{
	const Data d1 = {id : 1, name : "chenbo", age : 38};
	
	d1.id = 2;              // error
	d1.name = "chenbo2";    // error
	d1.age = 39;            // yes
	
	return 0;
}
