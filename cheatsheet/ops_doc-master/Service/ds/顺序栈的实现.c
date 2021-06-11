#ifndef SS_DATA_T
#define SS_DATA_T int
#endif      //SS_DATA_T
typedef struct{
    SS_DATA_T* data;    //数据的指针
    int maxlen; //栈的最大数据个数
    int top;    //栈顶索引号,-1表示空
}sstack_t;

//创建空栈
sstack_t* create_sstack(int len){
    sstack_t* S=(sstack_t*)malloc(sizeof(sstack_t));
    S->data=(SS_DATA_T*)malloc(sizeof(len* sizeof(SS_DATA_T)));
    S->top=-1;
    S->maxlen=len;
    return S;
}

//清空栈
void clear_sstack(sstack_t* S){
    S->top=-1;  
}

//销毁栈
void destroy_sstack(sstack_t* S){
    free(S->data);
    S->data=NULL;
    free(S);
    S=NULL;
}
//判断是否栈空
int is_empty_sstack(sstack_t* S){
    return S->top==-1;
}


//判断是否栈满
int is_full_sstack(sstack_t* S){
    return S->top==S->maxlen-1;
}
//元素进栈
int push_sstack(sstack_t* S, SS_DATA_T data){
    S->top++;
    *(S->data+S->top)=data;
    return 0;
}
//元素出栈
SS_DATA_T pop_sstack(sstack_t* S){
    S->top--;
    return *(S->data+S->top+1);

}
//查看栈顶元素
SS_DATA_T get_top(sstack_t* S){
    return *(S->data+S->top);
}