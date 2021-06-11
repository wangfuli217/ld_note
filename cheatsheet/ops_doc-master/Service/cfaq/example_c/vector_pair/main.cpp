#include <stdio.h>
#include <vector>
#include <utility>
#include <string>

using namespace std;

typedef vector<pair<string, string> > list_t;

int main(int argc, char **argv)
{
	list_t  list(1, make_pair("chenbo", "chenbo"));
    
    printf("hello world\n");
	return 0;
}
