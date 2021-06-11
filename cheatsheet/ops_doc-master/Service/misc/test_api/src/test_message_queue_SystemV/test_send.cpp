/*send.c*/
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
    char msgtext[10];
};

/*
struct msqid_ds
{
    struct ipc_perm msg_perm;
    struct msg *msg_first;       first message on queue,unused
    struct msg *msg_last;        last message in queue,unused
    __kernel_time_t msg_stime;   last msgsnd time
    __kernel_time_t msg_rtime;   last msgrcv time
    __kernel_time_t msg_ctime;   last change time
    unsigned long  msg_lcbytes;  Reuse junk fields for 32 bit
    unsigned long  msg_lqbytes;  ditto
    unsigned short msg_cbytes;   current number of bytes on queue
    //msg�ĸ���
    unsigned short msg_qnum;     number of messages in queue
    //msg����Ϣ�峤��
    unsigned short msg_qbytes;   max number of bytes on queue
    __kernel_ipc_pid_t msg_lspid;    pid of last msgsnd
    __kernel_ipc_pid_t msg_lrpid;    last receive pid
};

// one msg structure for each message
struct msg {
    //��һ����Ϣ
    struct msg *msg_next;   next message on queue
    //��Ϣ����
    long  msg_type;
    //��Ϣ�忪ʼλ��ָ��
    char *msg_spot;         message text address
    time_t msg_stime;       msgsnd time
    //��Ϣ�峤��
    short msg_ts;           message text size
};

*/
int main()
{
    struct msgstru msgs;
    int msg_type;
    char str[10];
    int ret_value;
    int msqid;

    msqid=msgget(MSGKEY,IPC_EXCL); /*�����Ϣ�����Ƿ����*/
    if(msqid < 0) {
        msqid = msgget(MSGKEY,IPC_CREAT|0666);/*������Ϣ����*/
        if(msqid <0) {
            printf("failed to create msq | errno=%d [%s]\n",errno,strerror(errno));
            exit(-1);
        }
    }

    struct msqid_ds msqinfo;
    memset(&msqinfo, 0, sizeof(msqinfo));
    if( -1 == msgctl(msqid, IPC_STAT, &msqinfo) )
    {
        printf("failed to create msq | errno=%d [%s]\n",errno,strerror(errno));
        exit(-1);
    }
    memset(&msqinfo, 0, sizeof(msqinfo));
    msqinfo.msg_qbytes = 1024*1024;
    if( -1 == msgctl(msqid, IPC_SET, &msqinfo) )
    {
        printf("failed to create msq | errno=%d [%s]\n",errno,strerror(errno));
        exit(-1);
    }

#if 1
    //int i = 2;
    printf("sizeof(struct msgstru) = %d.\n", sizeof(struct msgstru));

    for(int i = 10; i>0; --i)
    {
        msg_type = i;
        if (msg_type == 0)
            exit(-1);
        snprintf(str, sizeof(str), "%d sdfdsafsadfasfasfasd", i);
        msgs.msgtype = msg_type;
        strcpy(msgs.msgtext, str);

        printf("mtype = %d, mtext=[%s] pid=[%d]\n", msgs.msgtype, msgs.msgtext, getpid());

        /* ������Ϣ���� */
        ret_value = msgsnd(msqid,&msgs,sizeof(struct msgstru),IPC_NOWAIT);
        if ( ret_value < 0 ) {
            printf("msgsnd() write msg failed,errno=%d[%s]\n",errno,strerror(errno));
            exit(-1);
        }
    }


    while(1)
        sleep(1222);
#else
    while (1) {
        printf("input message type(end:0):");
        scanf("%d",&msg_type);
        if (msg_type == 0)
        break;
        printf("input message to be sent:");
        scanf ("%s",str);
        msgs.msgtype = msg_type;
        strcpy(msgs.msgtext, str);
        /* ������Ϣ���� */
        ret_value = msgsnd(msqid,&msgs,sizeof(struct msgstru),IPC_NOWAIT);
        if ( ret_value < 0 ) {
            printf("msgsnd() write msg failed,errno=%d[%s]\n",errno,strerror(errno));
            exit(-1);
        }
    }
#endif
    msgctl(msqid,IPC_RMID,0); //ɾ����Ϣ����

    return 0;
}
