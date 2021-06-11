#include <stdio.h>
#include <stdlib.h>
#include <string>

using namespace std;

int
main()
{
    string a = "hello";
    string b = "world";

    string c = b;

    sprintf((char*)c.c_str(), "%s", "1234567");
    printf("a:%s\n", a.c_str());
    printf("b:%s   %p\n", b.c_str(), b.c_str());
    printf("c:%s   %p\n", c.c_str(), c.c_str());

    sprintf((char*)b.c_str(), "%s", "7654321");
    printf("a:%s\n", a.c_str());
    printf("b:%s   %p\n", b.c_str(), b.c_str());
    printf("c:%s   %p\n", c.c_str(), c.c_str());


    b.assign("hello");
    //c = "hello,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,";
    c.assign("111111111111111111111111111111111");
    printf("a:%s\n", a.c_str());
    printf("b:%s   %p\n", b.c_str(), b.c_str());
    printf("c:%s   %p\n", c.c_str(), c.c_str());

	system("pause");
	getc(0);
	
    return 0;
}