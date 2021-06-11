#include <stdio.h>
#include <map>

using namespace std;

int 
main(int argc, char **argv)
{
    map<int, int> temp;
    
    for (int idx = 0; idx < 1; idx++) {
        temp.insert(make_pair<int, int>(idx, idx));
    }
    
	for (map<int, int>::iterator it = temp.begin(); it != temp.end();it++) {
		printf("key: %d value: %d  \n", it->first, it->second);
	}
	
    printf("sz: %zu\n", temp.size());
	return 0;
}
