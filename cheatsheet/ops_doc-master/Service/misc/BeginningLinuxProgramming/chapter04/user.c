#include <sys/types.h>
#include <pwd.h>
#include <stdio.h>
#include <unistd.h>

//---------------------有待学习-----------------//
//其实程序的主要任务就是读取文件和读取内存
//getpwuid 根据用户的id来获取passwd中的信息
//getpwnme 根据用户名称name来获取passwd中的信息

//passwd  数据结构中含有passwd文件中的信息
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
