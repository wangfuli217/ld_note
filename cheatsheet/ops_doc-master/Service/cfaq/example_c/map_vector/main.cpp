#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <vector>

using std::map;
using std::vector;

int 
main(int argc, char **argv)
{
	map<int, vector<int> > level_map;
	vector<int>& v = level_map[1]; /* operator [] 默认在key不存在的情况下new 一个新key/value */
	
	v.push_back(10);
	
	printf("v: %d\n", v.size());
	
	system("pause");
	return 0;
}
