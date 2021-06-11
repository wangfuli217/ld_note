#ifndef BT_DATA_T
#define BT_DATA_T int
#endif        //BT_DATA_T
typedef struct node{
    BT_DATA_T data;
    int num;                //节点编号
    struct node* lchild;
    struct node* rchild;
}bitree_t;

//创建二叉树
bitree_t* create_bt(int sum,int num){
    bitree_t* root=(bitree_t*)malloc(sizeof(bitree_t));
    root->num=num;
    if(2*num<=sum){     //有左子树
        root->lchild=create_bt(sum,2*num);
    }else{
        root->lchild= NULL;
    }
    if(2*num+1<=sum){   //有右子树
        root->rchild=create_bt(sum,2*num+1);
    }else{
        root->rchild= NULL;
    }
    return root;
}
//先续遍历
int pre_order_bt(bitree_t* root){
    if(NULL==root){
        return -1;
    }
    printf("%d ",root->num);
    pre_order_bt(root->lchild);
    pre_order_bt(root->rchild);
    return 0;
}

//中续遍历
int in_order_bt(bitree_t* root){
    if(NULL==root){
        return -1;
    }
    in_order_bt(root->lchild);
    printf("%d ",root->num);
    in_order_bt(root->rchild);
    return 0;
}
//后续遍历
int post_order_bt(bitree_t* root){
    if(NULL==root){
        return -1;
    }
    post_order_bt(root->lchild);
    post_order_bt(root->rchild);
    printf("%d ",root->num);
    return 0;
}

//层次遍历
int breadth_order_bt(bitree_t* root){
    lq_t* Q=create_lqueue();
    in_lqueue(Q,root);
    while(!is_empty_lqueue(Q)){
        data_t  tmp;
        out_lqueue(Q,&tmp);
        printf("%d ",tmp->num);

        if(NULL!=tmp->lchild){
            in_lqueue(Q,tmp->lchild);
        }

        if(NULL!=tmp->rchild){
            in_lqueue(Q,tmp->rchild);
        }
    }
    return 0;
}