#include <stdio.h>
#include <vector>

using std::vector;

int main(int argc, char **argv)
{
	vector<int> vec;
	
	
	for (int i = 0; i < 10; i++) {
		vec.push_back(i);
	}
	
	vec.resize(0, 0); 
	
	printf("SZ: %d\n", vec.size());
	
	return 0;
}
