#define N 9
typedef struct{
    int V[N];
    int R[N][N];
}graph_t;

int visited[N]={0}; //一个点是否被访问过的标志
//创建一个图
graph_t* create_graph(){
    graph_t* G=(graph_t*)calloc(1,sizeof(graph_t));
    if(NULL==G){
        puts("calloc error");
        return NULL;
    }
    //输入节点
    int i=0,j=0;
    for(i=0;i<5;i++){
        G->V[i]=i;
    }
    //输入关系
    while(2==scanf("v%d v%d",&i,&j/*,&val*/)){  //输入有关系的节点，及他们之间的关系
        getchar();
        G->R[i][j]=G->R[j][i]=1;
    }
    return G;
}

//显示图
int show_graph(graph_t* G){
    int i=0,j=0;
    putchar('\t');
    for(i=0;i<N;i++){
        printf("v%d\t",i);
    }
    putchar(10);

    for(i=0;i<N;i++){
        printf("v%d\t",i);
        for(j=0;j<N;j++){
            printf("%d\t",G->R[i][j]);
        }
        putchar(10);
    }
    return 0;
}
//深度优先搜索
void DFS(graph_t* G,int v){
    visited[v]=1;
    printf("%d ",v);
    int i=0;
    for(i=0;i<N;i++){
        if(0==visited[i]&&0!=G->R[v][i]){
            DFS(G,i);
        }
    }
}

//广度优先搜索
int BFS(graph_t* G, int v){ //用队列进行入对出队
    int i=0;
    lq_t* Q=create_lqueue();
    in_lqueue(Q,v);
    visited[v]=1;
    while(!is_empty_lqueue(Q)){
        data_t tmp;
        out_lqueue(Q,&tmp);
        printf("v%d ",tmp);
        for(i=0;i<N;i++){
            if(0==visited[i]&&0!=G->R[tmp][i]){
                in_lqueue(Q,i);
                visited[i]=1;
            }
        }
    }
    return 0;
}
