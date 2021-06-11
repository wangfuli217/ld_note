#ifndef LQ_DATA_T
#define LQ_DATA_T int
#endif //LQ_DATA_T
typedef struct node_t{
    LQ_DATA_T data;
    struct node_t* next;
}node_t;
typedef struct{
    node_t* head;
    node_t* front, *rear;
}lqueue_t;

//创建队列
lqueue_t* create_lqueue(){
    lqueue_t* Q=(lqueue_t*)malloc(sizeof(lqueue_t));
    Q->head=(node_t*)malloc(sizeof(node_t));
    Q->head->next=NULL;
    Q->front=Q->head;
    Q->rear=Q->head;
    return Q;
}

//入队
int in_lqueue(lqueue_t* Q, LQ_DATA_T data){
    node_t* pNode=(node_t*)malloc(sizeof(node_t));
    pNode->data=data;
    pNode->next=NULL;
    Q->rear->next=pNode;
    Q->rear=Q->rear->next;
    return 0;   
}

//判断队列是否为空
int is_empty_lqueue(lqueue_t* Q){
    return Q->front==Q->rear;
}
//出队
int out_lqueue(lqueue_t* Q,LQ_DATA_T* data){
    node_t* pNode=pNode=Q->front->next;
    Q->front->next=pNode->next;
    *data=pNode->data;
    free(pNode);
    pNode=NULL;

    if(NULL==Q->front->next){
        Q->rear=Q->front;
    }
    return 0;   
}

//销毁队列
int destroy_lqueue(lqueue_t* Q){
//  free(Q->head);
//  Q->head=NULL;
    free(Q->front);
    Q->front=NULL;
    free(Q->rear);
    Q->rear=NULL;
    free(Q);
    Q=NULL;
    return 0;
}