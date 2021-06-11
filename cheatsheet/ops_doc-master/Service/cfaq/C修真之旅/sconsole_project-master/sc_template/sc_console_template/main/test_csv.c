#include <schead.h>
#include <sclog.h>
#include <sccsv.h>

#define _STR_PATH "onetime.csv"
// ���� csv�ļ�����
int main(int argc, char* argv[])
{
	sccsv_t csv;
	int i, j;
	int rlen, clen;

	INIT_PAUSE();
	sl_start();

	// ����õ� csv ����
	csv = sccsv_new(_STR_PATH);
	if (NULL == csv)
		CERR_EXIT("open " _STR_PATH " is error!");

	//�����ӡ����
	rlen = csv->rlen;
	clen = csv->clen;
	for (i = 0; i < rlen; ++i) {
		for (j = 0; j < clen; ++j) {
			printf("<%d, %d> => [%s]\n", i, j, sccsv_get(csv, i, j));
		}
	}

	//���� ����Բ���ɹ�
	sccsv_die(&csv);
	return 0;
}