#ifndef SL_DATA_T
#define SL_DATA_T  int
#endif      //SL_DARA_T
typedef struct{
    SL_DATA_T* data;
    int maxlen;
    int last;
}slist_t;

//创建顺序表
slist_t* create_slist(int len){
    slist_t* L = (slist_t*)malloc(sizeof(slist_t));
    L->data=(SL_DATA_T*)malloc(len*sizeof(SL_DATA_T));
    L->maxlen=len;
    L->last = -1;
    return L;
}
//清空顺序表
int clear_slist(slist_t* L){
    L->last = -1;
    return 0;
}
//判断是否为空
int is_empty_slist(slist_t* L){
    return L->last == -1;
}
//判断是否为满
int is_full_slist(slist_t* L){
    return L->last == L->maxlen-1;
}
//设置为空
int setzero_slist(slist_t* L){
    int i=0;
    for(i=0;i<=L->last;i++){
        L->data[i]=0;
    }
    return 0;
}
//获取顺序表长度
int get_length_slist(slist_t* L){
    return L->last+1;
}
//显示所有元素
int show_slist(slist_t* L){
    int i=0;
    for(i=0;i<=L->last;i++){
        printf("%d ",L->data[i]);
    }
    putchar(10);
    return 0;
}
//按照位置插入元素
int insert_slist(slist_t* L, SL_DATA_T x, int pos){
    int i=0;
    for(i=L->last;i>=pos;i--){        //插入元素之前应该把上面的元素都移动一下
        L->data[i+1]=L->data[i];
    }
    L->data[pos]=x;
    L->last++;
    return 0;
}
//按照位置删除元素
int delete_slist(slist_t* L,int pos){
    int i=0;
    for(i=pos;i<=L->last;i++){
        L->data[i]=L->data[i+1];
    }
    L->last--;
    return 0;
}

//删除重复数据
int delrep_slist(slist_t* L){
    int i=0,j=0;
    for(i=0;i<L->last;i++){
        for(j=i+1;j<=L->last;j++){
            if(L->data[j]==L->data[i]){
                delete_slist(L,j);
                j--;                //防止漏掉元素
            }
        }
    }
    return 0;
}
//按照位置更改元素
int change_slist(slist_t* L, SL_DATA_T x,int pos){
    L->data[pos]=x;
    return 0;
}

//按照值查找位置
int search_slist(slist_t* L, SL_DATA_T x,int* pos){
    int i=0;
    for(i=0;i<=L->last;i++){
        if(L->data[i]==x){
            *pos=i;
        }
    }
    return -2;
}

//合并表，合并的时候忽略重复元素
int cat_slist(slist_t* L1, slist_t* L2){
    int i=0;
    for(i=0;i<=L2->last;i++){
        int pos;
        int res=search_slist(L1,L2->data[i],&pos);
        if(-2==res){
            insert_slist(L1,L2->data[i],L1->last+1);
        }
    }
    return 0;
}
//销毁顺序表
int destroy_slist(slist_t* L){
    free(L->data);
    L->data=NULL;
    free(L);
    L=NULL;
    return 0;
}