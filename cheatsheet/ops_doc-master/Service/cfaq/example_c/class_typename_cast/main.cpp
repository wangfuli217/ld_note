#include <stdio.h>
#include <string>

#include "data.h"
#include "func.h"



/*
 * 用户自定义的转换函数 类型不能是数组或者函数
 * 
 * */

using namespace std;

typedef string data_str_t; 

int main(int argc, char **argv)
{
	Data data(0);
	char* pid = NULL;
	string sdata;
	
	if (data) {
		printf("data's id is zero\n");
	}
	
	pid = data;
	
	
	printf("Data_Int: %d\n", __add_data(data));
	
	return 0;
}
