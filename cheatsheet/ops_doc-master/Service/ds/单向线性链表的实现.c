#ifndef LL_DATA_T
#define LL_DATA_T int
#endif      //LL_DATA_T
typedef struct node{
    LL_DATA_T  data;
    struct node* next;
}node_t;
typedef struct linklist{
    node_t* head;
}llist_t;

//创建一个空链表
llist_t* create_llist(){
    llist_t* L=(llist_t*)malloc(sizeof(llist_t));
    L->head=(node_t*)malloc(sizeof(node_t));
    L->head->next=NULL;
    return L;
}

//创建一个有值的链表
llist_t* create_llist_val(){
    llist_t* L=(llist_t*)malloc(sizeof(llist_t));
    L->head=(node_t*)malloc(sizeof(node_t));
    L->head->next=NULL;
    //输入初始数据
    while(1){
        int val;
        printf("Please input an integer\n");
        if(1!=scanf("%d",&val)){
            while(getchar());
        }
        if(-1==val){
            break;
        }
        node_t* tmp=(node_t*)malloc(sizeof(node_t));
        tmp->data=val;
        
        //重新链接
        tmp->next=L->head->next;
        L->head->next=tmp;
    }
    return L;
}
//判断链表是否为空
int is_empty_llist(llist* L){
    return L->head->next==NULL;
}
//显示链表中的数据
int show_llist(llist_t* L){
    node_t* pNode=NULL;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        printf("%d ",pNode->data);
    }
    putchar(10);
    return 0;
}

//向链表中的头节点后插入数据
int insert_llist_head(llist_t* L, LL_DATA_T val){
    //将数据封装到一个node中
    node_t* tmp=(node_t*)malloc(sizeof(node_t));
    tmp->data=val;

    //将node进行链接
    tmp->next=L->head->next;
    L->head->next=tmp;
    return 0; 
}
//向链表中的尾节点前插入数据
int insert_llist_tail(llist_t* L, LL_DATA_T val){
    node_t* tmp=(node_t*)malloc(sizeof(node_t));
    tmp->data=val;
    node_t* pNode=NULL;

    for(pNode=L->head;NULL!=pNode;pNode=pNode->next){
        if(NULL==pNode->next){
            tmp->next=NULL;
            pNode->next=tmp;
            break;
        }
    }
    return 0;
}

//删除头节点之后的节点并返回其值
int take_llist_head(llist_t* L ,LL_DATA_T* data){
    node_t* pNode=NULL;
    pNode=L->head->next;
    L->head->next=L->head->next->next;
    *data=pNode->data;
    free(pNode);
    pNode=NULL;
    return 0;
}

//删除尾节点之前的节点并返回其值
int take_llist_tail(llist_t* L,LL_DATA_T* data){
    node_t* pNode=NULL,*tmp=NULL;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        if(NULL==pNode->next->next){
            tmp=pNode->next;
            pNode->next=NULL;   
            *data=tmp->data;
            free(tmp);
            tmp=NULL;
            break;
        }
    }
    return 0;
}

//根据编号找节点并返回其值
int search_llist_num(llist_t* L, int pos,LL_DATA_T* data){
    node_t* pNode=NULL;
    int cnt=-1;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        cnt++;
        if(cnt==pos){
            *data=pNode->data;
            return 0;
        }
    }
    return -2;
}

//根据值找节点并返回其编号
int search_llist_val(llist_t* L, LL_DATA_T val){
    node_t* pNode=NULL;
    int cnt=-1;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        cnt++;
        if(pNode->data==val){
            return cnt;
        }
    }
    return -2;
}

//根据编号找节点并修改其值
int change_llist(llist_t* L, int pos,LL_DATA_T val){
    node_t* pNode=NULL;
    int cnt=-1;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        cnt++;
        if(cnt==pos){
            pNode->data=val;
            return 0;
        }
    }
    return -2;
}
//根据编号插入节点
int insert_llist_pos(llist_t* L, int pos,LL_DATA_T val){
    node_t* tmp=(node_t*)malloc(sizeof(node_t));
    tmp->data=val;
    tmp->next=NULL;
    int cnt=-1;
    node_t* pNode=NULL;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        cnt=++;
        if(cnt==pos){
            tmp->next=pNode->next;
            pNode->next=tmp;
            return 0;
        }
    }
    return -2;
}


//顺序插入
int insert_llist_sort(llist_t* L,LL_DATA_T data){
    node_t* tmp=(node_t*)malloc(sizeof(node_t));
    tmp->data=data;
    node_t* pNode=NULL;
    for(pNode=L->head;NULL!=pNode;pNode=pNode->next){
        if(NULL==pNode->next||pNode->next->data>tmp->data){
            tmp->next=pNode->next;
            pNode->next=tmp;
            return 0;
        }
    }
    return -1;
}


//链表反转

llist_t* reverse_llist(llist_t* L){
    llist_t* L2=create_llist();
    LL_DATA_T tmp;
    while(L->head->next!=NULL){
        take_llist_head(L,&tmp);
        insert_llist_head(L2,tmp);
    }
    return L2;
}

//查找倒数第k个数据

int search_llist_k(llist_t* L, int k, LL_DATA_T* data){
    node_t* pNode=NULL;
    int cnt=-1; 
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        cnt++;
    }
    int tmp=0;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        tmp++;
        if(tmp==cnt-k){
            *data=pNode->data;
            return 0;
        }
    }
    return -2;
}

//清空链表
int setzero_llist(llist_t* L){
    node_t* pNode=NULL;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
            pNode->data=0;
    }
    return 0;
}
///*
//合并链表
int cat_llist(llist_t* L1, llist_t* L2){
    node_t* pNode=NULL;
    for(pNode=L1->head->next;NULL!=pNode;pNode=pNode->next){
        if(NULL==pNode->next){
            pNode->next=L2->head->next;
            free(L2);
            L2=NULL;
            break;
        }
    }
    return 0;
}
//*/
//统计节点的数目
int length_list(llist_t* L){
    node_t* pNode=NULL;
    int sum=0;
    for(pNode=L->head->next;NULL!=pNode;pNode=pNode->next){
        sum++;
    }
    return sum;
}

//销毁链表
int destroy_llist(llist_t* L){
    node_t* pNode=NULL;
    while(L->head->next!=NULL){
        pNode=L->head->next;
        L->head->next=L->head->next->next;
        free(pNode);    //堆内的指针需要free
        pNode=NULL;
    }
    free(L);
    L=NULL;

    return 0;
}