#ifndef _H_SCCSV
#define _H_SCCSV

/*
 *  ������һ������ csv �ļ��� �򵥽�����.
 * ���ܹ����������з��ļ�����,������������.
 */
struct sccsv {		//�ڴ�ֻ���ڶ���
	int rlen;		//��������,����[0, rlen)
	int clen;		//��������,����[0, clen)
	const char* data[];	//��������һά����,ϣ�����Ƕ�ά�� rlen*clen
};

typedef struct sccsv* sccsv_t;

/*
 * ���ļ��й���csv����, �����Ҫ���� sccsv_die �ͷ�
 * path		: csv�ļ�����
 *			: ���ع����õ� sccsv_t ����
 */
extern sccsv_t sccsv_new(const char* path);

/*
 * �ͷ���sccsv_new�����Ķ���
 * pcsv		: ��sccsv_new ���ض���
 */
extern void sccsv_die(sccsv_t* pcsv);

/*
 * ��ȡĳ��λ�õĶ�������,������� �Ƽ�����Ϊ������, window�ϲ�֧��
 * csv		: sccsv_t ����, new���ص�
 * ri		: ���ҵ������� [0, csv->rlen)
 * ci		: ���ҵ������� [0, csv->clen)
 *			: ������һ��������,��������� atoi, atof, str_dup �ȴ�����...
 */
extern inline const char* sccsv_get(sccsv_t csv, int ri, int ci);

#endif // !_H_SCCSV