#include <stdio.h>
#include <algorithm>
#include <vector>


int main(int argc, char **argv)
{
	std::vector<int> 	v1;
	int 				ia[] = {1, 2, 3, 4, 5};
	std::vector<int> 	v2;
	
	v1.resize(sizeof ia / sizeof(int)); // 这里必须保证目的verctor有足够的空间，copy不会自动增加verctor的空间
	std::copy(ia, ia + 5, v1.begin()); // input_last 是最后一个元素+1的位置，类似end()的概念，copy的范围是start ~ last - 1
	v2.resize(v1.size());
	std::copy(v1.begin(), v1.begin() + v1.size(), v2.begin());
	//std::copy(v1.begin(), v1.end(), v2.begin());
	
	for (unsigned int idx = 0; idx < v1.size(); idx++) {
		printf("v1[%u]:%d ", idx, v1[idx]);
	}
	printf("\n");

	for (unsigned int idx = 0; idx < v2.size(); idx++) {
		printf("v2[%u]:%d ", idx, v2[idx]);
	}
	printf("\n");
	
	return 0;
}
