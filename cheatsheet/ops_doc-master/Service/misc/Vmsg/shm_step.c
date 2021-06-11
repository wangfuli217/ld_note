int shmid;          //定义全局变量记录id
void fa(int signo){
    printf("deleting shared memories...\n");
    sleep(3);//其实没用
    int res=shmctl(shmid,IPC_RMID,NULL);
    if(-1==res)
        perror("shmctl"),exit(-1);
    printf("delete success\n");
    exit(0);    //ctrl+C已经不能结束while(1),用exit(0)来终结
}
int main(){
    //获取key
    key_t key=ftok(".",100);    //.就是一个存在且可访问的路径, 100是随便给的
    if(-1==key)
        perror("ftok"),exit(-1);
    printf("key=%#x\n",key);    //打印出进制的标示,即0x
    //创建shared memory
    shmid=shmget(key,4,IPC_CREAT|IPC_EXCL|0664);
    if(-1==shmid)
        perror("shmget"),exit(-1);
    printf("shmid=%d\n",shmid);
    //挂接shm
    void* pv=shmat(shmid,NULL,0);
    if((void*)-1==pv)
        perror("shmat"),exit(-1);
    printf("link shared memory success\n");
    //访问shm
    int* pi=(int*)pv;
    *pi=100;
    //脱接shm
    int res=shmdt(pv);
    if(-1==res)
        perror("shmdt"),exit(-1);
    printf("unlink success\n");
    //如果不再使用,删除shm
    printf("删除共享内存请按Ctrl C...\n");
    if(SIG_ERR==signal(SIGINT,fa))
        perror("signal"),exit(-1);
    while(1);
    return 0;
}