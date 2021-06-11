#ifndef LS_DATA_T
#define LS_DATA_T int
#endf   //LS_DATA_T
typedef struct node_t{
    LS_DATA_T data;
    struct node_t* next;
}node_t;
typedef struct{
    node_t* top;
}lstack_t;

//创建空栈
lstack_t* create_lstack(){
    lstack_t* S=(lstack_t*)malloc(sizeof(lstack_t));
    S->top=(node_t*)malloc(sizeof(node_t));
    S->top->next=NULL;
    return S;
}

//判断是否是空栈
int is_empty_lstack(lstack_t* S){
    return S->top->next==NULL; 
}

//入栈
int push_lstack(lstack_t* S,LS_DATA_T data){
    //封装节点
    node_t* tmp=(node_t*)malloc(sizeof(node_t));
    tmp->data=data;
    
    //链接
    tmp->next=S->top->next;
    S->top->next=tmp;   
    return 0;
}

//出栈
int pop_lstack(lstack_t* S,LS_DATA_T* data){
    node_t* pNode=S->top->next;
    S->top->next=S->top->next->next;
    *data=pNode->data;
    free(pNode);    //操作堆空间的数据的时候一定要注意内存泄漏
    pNode=NULL;
    return 0;
}
//查看栈顶元素
int get_top(lstack_t* S,LS_DATA_T* data){
    *data=S->top->next->data;
    return 0;
}
//清空
int clear_lstack(lstack_t* S){
    node_t* pNode=NULL;
    for(pNode=S->top->next;pNode!=NULL;pNode=pNode->next){
        pNode->data=0;
    }
    return 0;
}
//销毁栈
void destroy_lstack(lstack_t* S){
    while(S->top->next!=NULL){
        node_t* pNode=NULL;
        pNode=S->top->next;
        S->top->next=S->top->next->next;
        free(pNode);
        pNode=NULL;
    }
}