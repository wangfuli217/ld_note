#ifndef _H_RBTREE
#define _H_RBTREE

struct rbnode {
    unsigned long    parent_color;
    struct rbnode * right;
    struct rbnode * left;
};

typedef void * (* new_f)(void *);
typedef int (* cmp_f)(const void *, const void *);
typedef void (* die_f)(void *);

typedef struct {
    struct rbnode * root;
    new_f new;
    cmp_f cmp;
    die_f die;
} * rbtree_t;

/*
 * 每个想使用红黑树的结构, 需要在头部插入下面宏. 
 * 例如 :
    struct person {
        _HEAD_RBTREE;
        ... // 自定义信息
    };
 */
#define _HEAD_RBTREE    struct rbnode __node

/*
 * 创建一颗红黑树头结点 
 * new        : 注册创建结点的函数
 * cmp        : 注册比较的函数
 * die        : 注册程序销毁函数
 *            : 返回创建好的红黑树结点
 */
extern rbtree_t rb_new(new_f new, cmp_f cmp, die_f die);

/*
 * 插入一个结点, 会插入 new(pack)
 * tree        : 红黑树头结点
 * pack        : 待插入的结点当cmp(x, pack) 右结点
 */
extern void rb_insert(rbtree_t tree, void * pack);

/*
 * 删除能和pack匹配的结点
 * tree        : 红黑树结点
 * pack        : 当cmp(x, pack) 右结点
 */
extern void rb_remove(rbtree_t tree, void * pack);

/*
 * 得到红黑树中匹配的结点
 * tree        : 匹配的结点信息
 * pack        : 当前待匹配结点, cmp(x, pack)当右结点处理
 */
extern void * rb_get(rbtree_t tree, void * pack);

/*
 * 销毁这颗二叉树
 * tree        : 当前红黑树结点
 */
extern void rb_die(rbtree_t tree);

#endif /* _H_RBTREE */