#ifndef _H_SIMPLEC_SCFILE
#define _H_SIMPLEC_SCFILE

#include <schead.h>

//
// file_mtime - �õ��ļ�����޸�ʱ��
// path     : �ļ�����
// return   : -1 ��ʾ��ȡ����, �������ʱ���
//
extern time_t file_mtime(const char * path);

//
// file_set - ������Ҫ���µ��ļ�����
// path     : �ļ�·��
// func     : ע��ִ�е���Ϊ func(arg, path -> cnf)
// arg      : ע��Ķ������
// return   : void
//
void 
file_set_(const char * path, void (* func)(void * arg, FILE * cnf), void * arg);
#define file_set(path, func, arg) \
        file_set_(path, (void (*)(void *, FILE *))func, (void *)(intptr_t)arg)

//
// file_update - ����ע�����ý����¼�
// return   : void
//
extern void file_update(void);

//
// file_delete - ����Ѿ�ע���, ��Ҫ�� update ֮ǰ����֮��
// return   : void
//
void file_delete(void);

#endif//_H_SIMPLEC_SCFILE
