/*receive.c */
#include <stdio.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

#define MSGKEY 1024

struct msgstru {
    long msgtype;
    char msgtext[5];
};

/*子进程，监听消息队列*/
void childproc() {
    struct msgstru msgs;
    int msgid, msglen,ret_value;
    char str[512];
    msglen =  sizeof(struct msgstru);
    printf("msglen = %d.\n", msglen);
    while (1) {
        msgid = msgget(MSGKEY, IPC_EXCL);/*检查消息队列是否存在 */
        if (msgid < 0) {
            printf("pid=[%d], msq not existed! errno=%d [%s]\n", getpid(), errno, strerror(errno));
            sleep(2);
            continue;
        }

        /*接收消息队列*/
        //获取 消息msgtype 不等于5
//        ret_value = msgrcv(msgid, &msgs, msglen, 5, MSG_NOERROR|MSG_EXCEPT);
        //获取 消息msgtype 等于5
//        ret_value = msgrcv(msgid, &msgs, msglen, 5, MSG_NOERROR);
        //获取 消息msgtype 小于 等于-5绝对值
        ret_value = msgrcv(msgid, &msgs, msglen, -6, MSG_NOERROR);
        printf("ret_value = %d.\n", ret_value);
        printf("mtype = %d, mtext=[%s] pid=[%d]\n", msgs.msgtype, msgs.msgtext, getpid());
    }
    return;
}

int main() {
    int i, cpid;

    /* create 5 child process */
    for (i = 0; i < 1; i++) {
        cpid = fork();
        if (cpid < 0)
            printf("fork failed\n");
        else if (cpid == 0) /*child process*/
            childproc();
    }

    while(1)
        sleep(100);
    return 0;
}
