#include <stdlib.h>
#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

static 
void
vector_erase() /* erase 返回是下一个可用的item的iterator, vector删除后回向前移动所有数据*/
{
	vector<int> vec(10, 10);
	std::vector<int>::iterator begin;
	
	for ( begin = vec.begin() ; begin != vec.end() ; /* ++begin */ )
	{
		if ( 10 == *begin )
		{
				begin = vec.erase( begin ) ;
		}
		else
		{
				++begin ;
		}
	}
	
	cout << "Size: " << vec.size() << endl;	
}

static
void
vector_erase_2()
{
	vector<int> vec(10, 10);
	std::vector<int>::iterator begin;
	
	vec.erase(remove(vec.begin(), vec.end(), 10), vec.end()); /* remove类函数，是逻辑上的删除，将被删除的元素移动到容器末尾，然后返回新的末尾，此时容器的size不变化*/
	
	cout << "Size: " << vec.size() << endl;	
}

int main(int argc, char **argv)
{
	vector_erase();
	vector_erase_2();
	
	system("pause");
	
	return 0;
}
	
