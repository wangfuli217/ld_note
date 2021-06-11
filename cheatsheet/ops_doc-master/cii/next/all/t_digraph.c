#include<sys/times.h>
#include<time.h>
#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
#include"digraph.h"

/**
 * 打印参数格式
 */
static void _usage();

/**
 * 打印内存分配状况 检查泄漏
 */
static void _inuse( const void *ptr,
                    ssize_t size,
                    const char *file,
                    const char *func,
                    int line,
                    void *cl);

/**
 * 随机构造连接
 */
static void _dummy_connect (digraph_t digraph);

/**
 * 做全节点连通测试
 */
static void _dummy_check (digraph_t digraph, int threshold);

int
main(int argc, char *argv[])
{
    int count, threshold;
    digraph_t   digraph;

    if(3 != argc){
        _usage();
        return EXIT_FAILURE;
    }


    count     = atoi(argv[1]);
    threshold = atoi(argv[2]);

    /**
     * 新建一个加权有向图
     * 添加count个节点
     */
    digraph = digraph_new(count);
    digraph_add_seg(digraph, count);

    printf("Leaking check 0:\n");
    mem_leak(_inuse, stdout);

    /**
     * 生成一些随机连接
     */
    _dummy_connect(digraph);

    printf("Leaking check 1:\n");
    mem_leak(_inuse, stdout);

    /**
     * 做全节点的联通性测试
     */
    _dummy_check(digraph, threshold);

    printf("Leaking check 2:\n");
    mem_leak(_inuse, stdout);

    /**
     * 释放图对象
     */
    digraph_free(&digraph);

    printf("Leaking check 3:\n");
    mem_leak(_inuse, stdout);

    return EXIT_SUCCESS;
}

static
void
_usage()
{

    printf("Usage: count threshold\n"
           "\tcount for graph node count\n"
           "\tthreshold for path print\n");
}

static 
void 
_inuse(const void *ptr,
        ssize_t size,
        const char *file,
        const char *func,
        int line,
        void *cl)
{
    FILE *log = cl;

    fprintf(log, "**memory in use at %p\n", ptr);
    fprintf(log, "  This block is %zd bytes long and allocated from"
                 " %s (%s:%d)\n", size, func, file, line);
}


static
void
_dummy_connect
(digraph_t digraph)
{
    int count, from, to, i;
    clock_t clock_time;

    count = digraph_count(digraph);
    clock_time = clock();
    srandom((long)clock_time);

    for(i = 0; i < count; i++){
        from = random() % count;
        to   = random() % count;
        /**
         * 单闭环不处理 简化算法
         */
        if(to == from)
            continue;

        /**
         * 注意添加了双向的连接
         * 通常需要添加双向, 单向用于特殊情况
         */
        digraph_connect(digraph, from, to, 1.0);
        digraph_connect(digraph, to, from, 1.0);
    }
}

static
void
_dummy_check
(digraph_t digraph, int threshold)
{
    int count, i, j, k, len;
    double dist;
    count = digraph_count(digraph);
    digraph_sr_t    dsr;
    digraph_path_t  dp;


    for(i = 0; i < count; i++){

        /**
         * 遍历节点, 每次 i 都做全路径搜索得到
         * 搜索结果集合----最短路径生成树
         */
        dsr = digraph_dijkstra(digraph, i);

        /**
         * 遍历节点, 每次 j 都检查和i之间的联通性
         * 把较长的路径打印出来
         */
        for(j = 0; j < count; j++){
            if(digraph_sr_has_path(dsr, j)){
                dist = digraph_sr_dist(dsr, j);
                dp   = digraph_sr_path_to(dsr, j);
                len  = digraph_path_length(dp);
                if(len >= threshold){
                    printf("from:%d to:%d dist:%f pathlen:%d\n", i, j, dist, len);
                    printf("\tstart[%d", digraph_sr_start(dsr));
                    for(k = 0; k < len; k++){
                        printf("->%d", digraph_path_get(dp, k));
                    }
                    printf("]end\n");
                }

                /**
                 * 路径数据需要释放
                 */
                digraph_path_free(&dp);
            }else{
            }
        }

        /**
         * 查询结果 需要释放
         */
        digraph_sr_free(&dsr);
    }
}
