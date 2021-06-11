#include <stdio.h>//printf snprintf
#include <unistd.h>//read close

#include <fcntl.h>//open O_RDONLY

#include <dirent.h>//opendir
#include <errno.h>//errno
#include <string.h>//strerror
/*
 * VOS_Process.cpp VOS_Process::Kill
 * */
int main() {
    DIR* pProcDir = opendir("/proc");

    for (struct dirent * pDirEntity; (pDirEntity = readdir(pProcDir));) {
        //d_name��һ���ַ� �� '1' ��  '9' ֮����ļ�������
        if (*pDirEntity->d_name < '1' || *pDirEntity->d_name > '9') {
            continue;
        }
        printf("d_name = %s\n", pDirEntity->d_name);

        char buf[512];
        snprintf(buf, 64, "/proc/%s/stat", pDirEntity->d_name); //����Stat�ļ�

        int fd = ::open(buf, O_RDONLY, 0);
        if (fd == -1) {
            if (errno != ENOENT) {
                printf("VOS_Process::Kill open %s fail, errno(%s)", buf,
                        strerror(errno));
            }
            continue;
        }

        int number = ::read(fd, buf, sizeof(buf) - 1);
        close(fd);
        if (number < 32) {
            printf("VOS_Process::Kill %s is too short", buf);
            continue;
        }

        printf("info = %s\n", buf);
        //����buf������û��Ӧ��������  (������)
        //kill
        //kill( pDirEntity->d_name, SIGKILL );
    }

    ::closedir(pProcDir);

    return 0;
}
