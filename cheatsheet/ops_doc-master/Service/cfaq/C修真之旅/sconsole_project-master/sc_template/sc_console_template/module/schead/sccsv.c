#include <schead.h>
#include <sccsv.h>
#include <sclog.h>
#include <tstring.h>

//���ļ��ж�ȡ csv�ļ�����
char* __get_csv(FILE* txt, int* prl, int* pcl)
{
	int c, n;
	int cl = 0, rl = 0;
	TSTRING_CREATE(ts);
	while((c=fgetc(txt))!=EOF){
		if('"' == c){ //������������
			while((c=fgetc(txt))!=EOF){
				if('"' == c) {
					if((n=fgetc(txt)) == EOF) { //�ж���һ���ַ�
						SL_WARNING("The CSV file is invalid one!");
						free(ts.str);
						return NULL;
					}
					if(n != '"'){ //��Ч�ַ��ٴ�ѹ��ջ
						ungetc(n, txt);
						break;
					}
				}
				//���ǺϷ��ַ� ��������
				if (_RT_OK != tstring_append(&ts, c)) {
					free(ts.str);
					return NULL;
				}
			}
			//�����ж�,ֻ����c == '"' �Ż�����,�����Ǵ��
			if('"' != c){
				SL_WARNING("The CSV file is invalid two!");
				free(ts.str);
				return NULL;
			}
		}
		else if(',' == c){
			if (_RT_OK != tstring_append(&ts, '\0')) {
				free(ts.str);
				return NULL;
			}
			++cl;
		}
		else if('\r' == c)
			continue;
		else if('\n' == c){
			if (_RT_OK != tstring_append(&ts, '\0')) {
				free(ts.str);
				return NULL;
			}
			++cl;
			++rl;
		}
		else {//�����������ֻ������ݾͿ�����
			if (_RT_OK != tstring_append(&ts, c)) {
				free(ts.str);
				return NULL;
			}
		}
	}
	
	if(cl % rl){ //��� , ���Ǹ����Ƿ�����
		SL_WARNING("now csv file is illegal! need check!");
		return NULL;
	}
	
	// ������������
	*prl = rl;
	*pcl = cl;
	return ts.str;
}

// �� __get_csv �õ����������¹�������, ִ�����������Ϊ�﷨��ⶼ��ȷ��
sccsv_t __get_csv_new(const char* cstr, int rl, int cl)
{
	int i = 0;
	sccsv_t csv = malloc(sizeof(struct sccsv) + sizeof(char*)*cl);
	if(NULL == csv){
		SL_FATAL("malloc is error one !");
		return NULL;
	}
	
	// ���￪ʼ����������
	csv->rlen = rl;
	csv->clen = cl / rl;
	do {
		csv->data[i] = cstr;
		while(*cstr++) //�ҵ���һ��λ�ô�
			;
	}while(++i<cl);
	
	return csv;
}

/*
 * ���ļ��й���csv����, �����Ҫ���� sccsv_die �ͷ�
 * path		: csv�ļ�����
 *			: ���ع����õ� sccsv_t ����
 */
sccsv_t 
sccsv_new(const char* path)
{
	FILE* txt;
	char* cstr;
	int rl, cl;
	
	DEBUG_CODE({
		if(!path || !*path){
			SL_WARNING("params is check !path || !*path .");
			return NULL;
		}
	});
	// ���ļ�����
	if((txt=fopen(path, "r")) == NULL){
		SL_WARNING("fopen %s r is error!", path);
		return NULL;
	}
	// ������� csv �ļ�����ʧ��ֱ�ӷ���
	cstr = __get_csv(txt, &rl, &cl);
	fclose(txt);

	// �������ս��
	return cstr ? __get_csv_new(cstr, rl, cl) : NULL;
}

/*
 * �ͷ���sccsv_new�����Ķ���
 * pcsv		: ��sccsv_new ���ض���
 */
void 
sccsv_die(sccsv_t* pcsv)
{
	if (pcsv && *pcsv) { // ���� ��ʼ�ͷ�
		free(*pcsv);
		*pcsv = NULL;
	}
}

/*
 * ��ȡĳ��λ�õĶ�������
 * csv		: sccsv_t ����, new���ص�
 * ri		: ���ҵ������� [0, csv->rlen)
 * ci		: ���ҵ������� [0, csv->clen)
 *			: ������һ��������,��������� atoi, atof, str_dup �ȴ�����...
 */
inline const char*
sccsv_get(sccsv_t csv, int ri, int ci)
{
	DEBUG_CODE({
		if(!csv || ri<0 || ri>=csv->rlen || ci<0 || ci >= csv->clen){
			SL_WARNING("params is csv:%p, ri:%d, ci:%d.", csv, ri, ci);
			return NULL;
		}
	});
	// �������ս��
	return csv->data[ri*csv->clen + ci];
}