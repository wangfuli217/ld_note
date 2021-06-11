#include <sys/types.h>
#include <pwd.h>
#include <stdio.h>
#include <unistd.h>

//---------------------�д�ѧϰ-----------------//
//��ʵ�������Ҫ������Ƕ�ȡ�ļ��Ͷ�ȡ�ڴ�
//getpwuid �����û���id����ȡpasswd�е���Ϣ
//getpwnme �����û�����name����ȡpasswd�е���Ϣ

//passwd  ���ݽṹ�к���passwd�ļ��е���Ϣ
int main(void)
{
    uid_t uid;
    gid_t gid;
    struct passwd *pw;

    uid = getuid();
    gid = getgid();

    printf("User is %s\n", getlogin());

    printf("User IDs: uid=%d, gid=%d\n", uid, gid);

    pw = getpwuid(uid);
    printf("UID passwd entry:\n name=%s, uid=%d, gid=%d, home=%s, shell=%s\n",
        pw->pw_name, pw->pw_uid, pw->pw_gid, pw->pw_dir, pw->pw_shell);

    pw = getpwnam("wangfuli");
    printf("root passwd entry:\n");
    printf("name=%s, uid=%d, gid=%d, home=%s, shell=%s\n",
        pw->pw_name, pw->pw_uid, pw->pw_gid, pw->pw_dir, pw->pw_shell);
    exit(0);
}
