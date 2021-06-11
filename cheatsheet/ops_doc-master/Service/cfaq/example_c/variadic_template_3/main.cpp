#include <stdio.h>
#include <iostream>
#include <stdexcept>
#include <exception>
#include <stdlib.h>

using namespace std;

void 
Printf(const char* s) 
{
	cout << "begin" << endl;
	while (*s) {
		if (*s == '%' && *++s != '%') {
			// cerr << "invalid format string: missing arguments" << endl;
			throw runtime_error("invalid format string: missing arguments");
		}
		
		cout << *s++;
	}
}

template<class T, class... Args> void
Printf(const char* s, T value, Args... args)
{
	cout << "first: " << sizeof...(args) << endl;
	
	while (*s) {
		if (*s == '%' && *++s != '%') {
			cout << value;
			
			return Printf(++s, args...);
		}
		cout << *s++;
	}
	
	throw runtime_error("extra argumnets provided to Printf");
}


int 
main(int argc, char **argv)
{
	Printf("hello %s\n", "world");
	
	system("pause");
	
	return 0;
}
