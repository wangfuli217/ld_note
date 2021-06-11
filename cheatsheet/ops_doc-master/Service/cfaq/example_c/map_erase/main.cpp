#include <stdio.h>
#include <map>
#include <stdlib.h>

int main(int argc, char **argv) {
	std::map<int, int> list;
	std::map<char, int> list_2;
	
	list_2['1'] = 10;
	
	list_2.erase('1');
	
	printf("size2: %d\n", list_2.size());
	
	list[1] = 11;
	
	//list.erase(11);
	
	std::map<int, int>::iterator it = list.find(1);
	
	list.erase(it);
	
	printf("list[1]: %d\n", list[1]);
	
//	std::map<int, int>::iterator it;
	
	printf("list size: %d\n", list.size());
	
	for (it = list.begin(); it != list.end(); it++) {
		printf("list[%d]: %d\n", it->first, it->second);
	}
	
	system("pause");
	return 0;
}
