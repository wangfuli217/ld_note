#include <schead.h>
#include <sclog.h>
#include <sccsv.h>

#define _STR_PATH "onetime.csv"
// 解析 csv文件内容
int main(int argc, char* argv[])
{
	sccsv_t csv;
	int i, j;
	int rlen, clen;

	INIT_PAUSE();
	sl_start();

	// 这里得到 csv 对象
	csv = sccsv_new(_STR_PATH);
	if (NULL == csv)
		CERR_EXIT("open " _STR_PATH " is error!");

	//这里打印数据
	rlen = csv->rlen;
	clen = csv->clen;
	for (i = 0; i < rlen; ++i) {
		for (j = 0; j < clen; ++j) {
			printf("<%d, %d> => [%s]\n", i, j, sccsv_get(csv, i, j));
		}
	}

	//开心 测试圆满成功
	sccsv_die(&csv);
	return 0;
}