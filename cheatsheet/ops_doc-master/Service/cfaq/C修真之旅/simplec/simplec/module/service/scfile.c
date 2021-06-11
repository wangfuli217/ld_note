#include <scfile.h>
#include <tstr.h>

//
// file_mtime - �õ��ļ�����޸�ʱ��
// path     : �ļ�����
// return   : -1 ��ʾ��ȡ����, �������ʱ���
//
inline time_t 
file_mtime(const char * path) {
#ifdef _MSC_VER
    WIN32_FILE_ATTRIBUTE_DATA wfad;
    if (!GetFileAttributesEx(path, GetFileExInfoStandard, &wfad))
        return -1;
    // ���� winds x64 sizeof(long) = 4
    return *(time_t *)&wfad.ftLastWriteTime;
#endif

#ifdef __GNUC__
    struct stat ss;
    // ���������޸�ʱ��
    return stat(path, &ss) ? -1 : ss.st_mtime;
#endif
}

struct files {
    char * path;            // �ļ�ȫ·��
    void * arg;             // ����Ĳ���
    void (* func)(void * arg, FILE * cnf);
    
    unsigned hash;          // �ļ�·�� hash ֵ
    time_t mtime;           // �ļ��������޸�ʱ���

    struct files * next;    // �ļ���һ�����
};

static struct files * _fu;

// �ҵ��ض����, ������ hash ֵ
static struct files * _files_get(const char * p, unsigned * hh) {
    struct files * fu = _fu;
    unsigned h = *hh = tstr_hash(p);
    
    while(fu) {
        if (fu->hash == h && strcmp(fu->path, p) == 0)
            break;
        fu = fu->next;
    }

    return fu;
}

// �����ض����
static void _files_add(const char * p, unsigned h, 
                       void * arg, void (* func)(void *, FILE *)) {
    struct files * fu;
    time_t mtime = file_mtime(p);
    if (mtime == -1)
        RETURN(NIL, "file_mtime path error = %s.", p);

    // ��ʼ��������
    fu = malloc(sizeof(struct files));
    if (NULL == fu) 
        RETURN(NIL, "malloc struct files is error!");
    fu->path = tstr_dup(p);
    fu->hash = h;
    fu->func = func;
    fu->arg = arg;
    fu->mtime = -1;

    fu->next = _fu;
    _fu = fu;
}

//
// file_set - ������Ҫ���µ��ļ�����
// path     : �ļ�·��
// func     : ע��ִ�е���Ϊ func(arg, path -> cnf)
// arg      : ע��Ķ������
// return   : void
//
void 
file_set_(const char * path, 
    void (* func)(void * arg, FILE * cnf), void * arg) {
    unsigned hash;
    assert(path || func);
    struct files * fu = _files_get(path, &hash);
    // ��Ӳ��� or �޸Ĳ���
    if (!fu)
        _files_add(path, hash, arg, func);
    else {
        fu->func = func;
        fu->arg = arg;
        fu->mtime = -1;   
    }
}

//
// file_update - ����ע�����ý����¼�
// return   : void
//
void 
file_update(void) {
    for (struct files * fu = _fu; fu ; fu = fu->next) {
        time_t mtime = file_mtime(fu->path);
        if (mtime != fu->mtime && mtime != -1) {
            // �����߳�����, ��������, ҵ����֧�ֶ�д
            FILE * cnf = fopen(fu->path, "rb+");
            if (NULL == cnf) {
                CERR("fopen path wb error = %s.", fu->path);
                continue;
            }
            fu->mtime = mtime;
            fu->func(cnf, fu->arg);
            fclose(cnf);
        }
    }
}

//
// file_delete - ����Ѿ�ע���, ��Ҫ�� update ֮ǰ����֮��
// return   : void
//
void 
file_delete(void) {
    struct files * fu = _fu;
    _fu = NULL;
    while (fu) {
        struct files * next = fu->next;
        free(fu->path);
        free(fu);
        fu = next;
    }
}