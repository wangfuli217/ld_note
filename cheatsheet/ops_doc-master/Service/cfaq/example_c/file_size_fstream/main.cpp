#include <stdio.h>
#include <fstream>
#include <stdlib.h>

using namespace std;

static int
__file_size(const char* f)
{
	fstream fs(f, fstream::in | fstream::app); /* 默认打开如果文件不存在不创建新文件 */
	
	fs.seekg(0, ios_base::end); /* fs.end */
	
	streampos ps = fs.tellg();
	
	return ps;
}

int main(int argc, char **argv)
{
	printf("size: %d\n", __file_size("function.js"));
	
	system("pause");
	
	return 0;
}
