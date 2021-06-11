#ifndef DIGRAPH_INCLUDE
#define DIGRAPH_INCLUDE


/**
 * 加权有向图对象
 * 邻接表实现
 * 适用于稀疏图
 */


#define T digraph_t
typedef struct T *T;

/**
 * 图搜索结果数据集对象
 * 在指定的图中, 以指定的节点为起点
 * 维护一颗单源点最短路径树
 * 这颗树维护着该节点到其他所有节点的连通性
 * 和连接权重, 后续使用者可以快速的查询
 * 该节点是否可以到达其他节点
 * 以及路径上的权重之和(距离)
 */
typedef struct digraph_sr_t     *digraph_sr_t;

/**
 * 路径数据集对象
 */
typedef struct digraph_path_t   *digraph_path_t;

/**
 * 新建图对象, hint是图包含节点数目的一个推测值
 * 以助于提高内存分配效率
 */
extern T                digraph_new         (int hint);

/**
 * 释放图对象
 */
extern void             digraph_free        (T *digraph);

/**
 * 新增图节点index从0 开始
 * 当前节点数为n时, 传入不等于n的index是已检查的异常
 */
extern void             digraph_add         (T digraph, int index);

/**
 * 新增一系列节点, 段长度为len
 */
extern void             digraph_add_seg     (T digraph, int len);


/**
 * 返回图的节点数
 */
extern int              digraph_count       (T digraph);

/**
 * 告知图对象 from 节点 和 to 节点 连通 权重为weight
 * from 和 to 小于0 或者 超出范围
 * 或者from to相等(避免单闭环)
 * 都是已检查的异常
 */
extern void             digraph_connect     (T digraph, int from, int to, double weight);

/**
 * 判断两节点是否联通
 * from 和 to 小于0 或者 超出范围
 * 或者from to相等(避免单闭环)
 * 都是已检查的异常
 */
extern int              digraph_is_connect  (T digraph, int from, int to);


/**
 * 采用经典算法 dijkstra
 * start 超出图索引范围 是已检查的异常
 * 以start节点为起点构造一颗单源点最短路径树
 * 这颗树维护着该节点到其他所有节点的连通性
 * 和连接权重, 后续使用者可以快速的查询
 * 该节点是否可以到达其他节点
 * 以及路径上的权重之和(距离)
 */
extern digraph_sr_t     digraph_dijkstra    (T digraph, int start);


/**
 * 释放搜索结果数据集对象
 */
extern void             digraph_sr_free     (digraph_sr_t *dsr);

/**
 * 获取搜索结果数据集对象的起点
 */
extern int              digraph_sr_start    (digraph_sr_t dsr);

/*
 * 判断是否连通到end节点
 * end 超出图索引范围 是已检查的异常
 */
extern int              digraph_sr_has_path (digraph_sr_t dsr, int end);

/**
 * 查询start点到end节点的权重和(距离)
 * end 超出图索引范围 是已检查的异常
 */
extern double           digraph_sr_dist     (digraph_sr_t dsr, int end);


/**
 * 查询start点到end节点的路径数据集对象
 * end 超出图索引范围 是已检查的异常
 * 如果不可达会返回NULL
 */
extern digraph_path_t   digraph_sr_path_to  (digraph_sr_t dsr, int end);

/**
 * 释放路径数据集合
 */
extern void             digraph_path_free   (digraph_path_t *dp);

/**
 * 查询所含路径长度(跳数)
 */
extern int              digraph_path_length (digraph_path_t dp);

/**
 * 查询某跳的to 节点
 * pos 超出路径长度范围 是已检查的异常
 */
extern int              digraph_path_get     (digraph_path_t dp, int pos);

#undef T

#endif /*DIGRAPH_INCLUDE*/
