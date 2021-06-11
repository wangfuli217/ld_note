#include <stdio.h>
#include <string>

// macos 这里不能实现

using namespace std;

static void
__pass_str(const string str);

static void 
__pass_str_2(const string str);

#define __PTR__(p) printf("0x%p----->0x%p\n", &p, p.c_str())

int main(int argc, char **argv)
{
	string str1("hello");
	__PTR__(str1);
	string str2(str1);
	string str3(str2);
	__PTR__(str2);
	__PTR__(str3);
	
	__pass_str(str1);
	
	printf("StringSz: %zu\n", sizeof(string));
	
	return 0;
}

void
__pass_str(const string str)
{
	__PTR__(str);
	__pass_str_2(str);
}

void
__pass_str_2(const string str)
{
	__PTR__(str);
}