#include<sys/types.h>
#include<sys/ipc.h>
#include<signal.h>
#include<stdio.h>
#include<stdlib.h>
typedef struct{
    long mtype;     //消息的类型
    char buf[20];       //消息的内容
}Msg;
int msqid;          //使用全局变量,这样就可以在fa中使用msqid了
void fa(int signo){
    printf("deleting..\n");
    sleep(3);
    int res=msgctl(msqid,IPC_RMID,NULL);
    if(-1==res)
        perror("msgctl"),exit(-1);
    exit(0);
}
int main(){
    //ftok()
    key_t key=ftok(".",150);
    if(-1==key)
        perror("ftok"),exit(-1);
    printf("key%#x\n",key);
    //msgget()
    msqid=msgget(key,IPC_CREAT|IPC_EXCL|0664);
    if(-1==msqid)
        perror("msgget"),exit(-1);
    printf("msqid%d\n",msqid);
    //msgsnd()
    Msg msg1={1,"hello"};//消息的类型是1,内容是hello
    Msg msg2={2,"world"};
    int res=msgsnd(msqid,&msg2,sizeof(msg2.buf),0);
    if(-1==res)
        perror("msgsnd"),exit(-1);
    res=msgsnd(msqid,&msg1,sizeof(msg1.buf),0);
    if(-1==res)
        perror("msgsnd"),exit(-1);
    //msgctl()
    //Ctrl+C delete msq
    printf("Press CTRL+C to delete msq\n");
    if(SIG_ERR==signal(SIGINT,fa))
        perror("signal"),exit(-1);
    while(1);
    return 0;
}