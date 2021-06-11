#include <stdio.h>
#include <StringBuilder.h>
#include <iostream>
#include <vector>

using namespace std;

int main(int argc, char **argv)
{
	StringBuilder<char> str;
	
	vector<int> vec = {1, 2, 3, 4};
	
	str.Append("hello").Append("world");
	cout << str.ToString() << endl;
	
	int i;
	
	cin >> i;
	
	return 0;
}
