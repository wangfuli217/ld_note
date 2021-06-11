int sln_ipc_mq_send(const char *sendbuf, int sendlen, int prio)  
{  
    mqd_t           mqd;  
  
    mqd = mq_open(SLN_IPC_MQ_NAME, O_WRONLY); //客户进程打开消息队列  
    if (mqd < 0) {  
        fprintf(stderr, "mq_open: %s\n", strerror(errno));  
        return -1;  
    }  
  
    if (mq_send(mqd, sendbuf, sendlen, prio) < 0) { //客户进程网消息队列中添加一条消息  
        fprintf(stderr, "mq_send: %s\n", strerror(errno));  
        return -1;  
    }  
  
    return 0;  
}  