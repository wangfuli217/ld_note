#ifndef SQ_DATA_T
#define SQ_DATA_T int
#endf       //SQ_DATA_T
typedef struct{
    SQ_DATA_T* data;
    int maxlen;
    int front,rear; //front下一个待取数据的索引，rear下一个待入数据的索引
}squeue_t;

//创建一个空队列
squeue_t* create_queue(int len){
    squeue_t* Q=(squeue_t*)malloc(sizeof(squeue_t));
    Q->maxlen=len;
    Q->data=(SQ_DATA_T*)malloc(len*sizeof(SQ_DATA_T));
    Q->front = Q->rear = (Q->maxlen -1);
    return Q;

}


//判断队列是否已满
int is_full_queue(squeue_t* Q){
    return (Q->rear+1)%(Q->maxlen) == Q->front; //不能是-1,-1不能用于if判断，if只认0和非0

}
//入队
int in_queue(squeue_t* Q,SQ_DATA_T data){
    
    //判断队列是否已满
    if(is_full_queue(Q)){
        puts("queue is full");
        return -1;
    }
    Q->rear = (Q ->rear+1)%(Q->maxlen);
    *(Q->data+Q->rear)=data;
    return 0;
}

//判断队列是否为空
int is_empty_queue(squeue_t* Q){
    return (Q->rear==Q->front);
}

//出队
int out_queue(squeue_t* Q,SQ_DATA_T* data){
    if(is_empty_queue(Q)){
        puts("queue is empty");
        return -1;
    }
    Q->front = (Q->front+1)%(Q->maxlen);
    *data = *(Q->data+Q->front);
    return 0;
}


//显示队列内容
void show_queue(squeue_t* Q){
    if(is_empty_queue(Q)){
        return;
    }
    //非空时从队头打印数据到对尾
    int i=0;
    for(i=(Q->front+1)%(Q->maxlen);i!=(Q->rear+1)%(Q->maxlen);i=(i+1)%(Q->maxlen)){
        printf("%d ",*(Q->data+i));
    }
    printf("\n");
}
//销毁队列
void destroy_queue(squeue_t* Q){
    free(Q->data);
    Q->data=NULL;
    free(Q);
    Q=NULL;
}