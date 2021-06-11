#ifndef CL_DATA_T
#define CL_DATA_T int 
#endif //CL_DATA_T
typedef struct node_t{
    CL_DATA_T data;
    struct node_t* next;
}node_t;
typedef struct{
    node_t* head;
}clist_t;

//创建空链表
clist_t* create_clist(){
    clist_t* L=(clist_t*)malloc(sizeof(clist_t));
    L->head=(node_t*)malloc(sizeof(node_t));
    L->head->next=L->head;
    return L;
}
//头插
int insert_clist_head(clist_t* L,CL_DATA_T data){
    tmp->data=data;
    tmp->next=L->head->next;
    L->head->next=tmp;
    return 0;
}
//显示数据
int show_clist(clist_t* L){
    node_t* pNode=NULL;
    for(pNode=L->head->next;pNode!=L->head;pNode=pNode->next){
        printf("%d ",pNode->data);
    }
    putchar(10);
    return 0;
}
//去头
node_t* del_clist_head(clist_t* L){
    node_t* pNode=NULL;
    for(pNode=L->head->next;pNode!=L->head;pNode=pNode->next){
        if(pNode->next==L->head){
            pNode->next=pNode->next->next;
            free(L->head);
            L->head=NULL;
            return pNode->next;
        }
    }
    return NULL;
}
//显示去头后链表
int show_clist_afdel(clist_t* L){
    node_t* pNode=NULL;
    for(pNode=L->head;pNode->next!=L->head;pNode=pNode->next){
        printf("%d ",pNode->data);
    }
    printf("%d \n",pNode->data);
    return 0;
}