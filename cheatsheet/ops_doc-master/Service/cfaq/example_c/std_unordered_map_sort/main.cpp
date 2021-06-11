#include <stdio.h>
#include <tr1/unordered_map>
#include <algorithm>

using namespace std;
using namespace std::tr1;

//static bool 
//asc_compare(int a, int b)
//{
//	return a > b;
//}

int main(int argc, char **argv)
{
	unordered_map<int, int> imap;
	
	for (int i = 0; i < 100; i++) {
		imap.insert(pair<int,int>(i, i));
	}
	
	sort(imap.begin(), imap.end());
	
	
	
	return 0;
}
