#include <stdio.h>
#include <vector>
#include <unistd.h>

using namespace std;

int main(int argc, char **argv)
{
	vector<unsigned int> temp;
	
	for (unsigned int idx = 0; idx < 10000000; idx++) {
		temp.push_back(idx);
	}
	
	printf("capacity: %d\n", temp.capacity());
	
	temp.clear();
	temp.shrink_to_fit();
	
	printf("capacity: %d\n", temp.capacity());
	
	
	sleep(100);
	return 0;
}
