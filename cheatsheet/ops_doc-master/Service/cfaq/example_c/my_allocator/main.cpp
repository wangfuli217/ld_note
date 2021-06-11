#include "cb_allocator.h"

#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <list>
#include <map>

using namespace std;

int main(int argc, char **argv)
{
	vector<int, cb_allocator<int> > ivec(10, 100);
	
	for (int i = 0; i < 10; i++) {
		printf("V[%d]: %d\n", i, ivec[i]);
	}
	
	list<int, cb_allocator<int> > ilist;
	map<int, int, cb_allocator<pair<int, int> > > imap;
	
	system("pause");
	
	return 0;
}
