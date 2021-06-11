#include <stdio.h>
#include <stdlib.h>
#include <string>

using std::string;

string& 
operator << (string& a, const string& b)
{
    a += b;
    
    return a;
}


int main(int argc, char **argv)
{
	string a("hello"), b("world");
    
    a << b;
    
    printf("a: %s\n", a.c_str());
    
    system("pause");
	return 0;
}
