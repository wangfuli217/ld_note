#include <stdio.h>
#include <vector>
#include <string>
#include <stdlib.h>

using namespace std;

static void
list_vec(const vector<string>& list) // list 这里是是常量容器，iterator 必须使用const_iterator
{
    vector<string>::const_iterator itr;
    
    for (itr = list.begin(); itr !=list.end(); itr++) {
        printf("STR: %s\n", itr->c_str());
    }
}

static void
list_vec_int(vector<int>& list)
{

}

int main(int argc, char **argv)
{
	vector<string> list;
    
    for (int i = 0; i < 10; i++) {
        list.push_back("h");
    }   
    
    list_vec(list);
    
    
    system("pause");
    
	return 0;
}
