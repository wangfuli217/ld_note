#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include <iostream>

using namespace std;

vector <string> v;

 
int main () {
    for(int i=0; i<1000000; i++) {
		v.push_back("abcdefghijklmn");	
	}

    system("pause");
	// 此时检查内存情况 占用54M
 
    v.clear();
	system("pause");
	// 此时再次检查， 仍然占用54M
 
    cout << "Vector 的 容量为" << v.capacity() << endl;
    // 此时容量为 1048576
 
    vector<string>(v).swap(v);
 
    cout << "Vector 的 容量为" << v.capacity() << endl;
    // 此时容量为0
    system("pause");
    // 检查内存，释放了 10M+ 即为数据内存
    return 0;
}
