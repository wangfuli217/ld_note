#include <stdio.h>
#include <stdlib.h>
#include <string>

using std::string;

typedef struct order_data_s order_data_t;
struct order_data_s {
	unsigned long 	id;
	string 			url;
	string			table;
	int				times;
};


int main(int argc, char **argv)
{
	order_data_t *o = (order_data_t*)malloc(sizeof(order_data_t));
    
    
    o->url = "chenbo"; //  这里不能使用，malloc只创建了内存并没有调用string的构造函数
    
    system("pause");
    
	return 0;
}
