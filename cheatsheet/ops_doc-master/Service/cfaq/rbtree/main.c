#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rbtree.h"

#define _STR_PATH    "常用汉字简繁对照表.txt"

#define _INT_DICT    (4)

struct dict {
    _HEAD_RBTREE;

    char key[_INT_DICT];
    char value[_INT_DICT];
};

// 需要注册的内容
static void * _dict_new(void * arg) {
    struct dict * node = malloc(sizeof(struct dict));
    if (NULL == node) {
        fprintf(stderr, "_dict_new malloc is error!\n");
        return NULL;
    }

    *node = *(struct dict *)arg;
    return node;
}

static inline int _dict_cmp(const void * ln , const void * rn) {
    return strcmp(((const struct dict *)ln)->key, ((const struct dict *)rn)->key);
}

static inline void _dict_die(void * arg) {
    free(arg);
}

// 创建内容
void dict_create(rbtree_t tree);
// 得到内容
const char * dict_get(rbtree_t tree, const char * key);

/*
 * 这里测试字典数据, 通过红黑树库
 */
int main(int argc, char * argv[]) {
    // 创建字典树, 再读取内容
    rbtree_t tree = rb_new(_dict_new, _dict_cmp, _dict_die);
    if (NULL == tree) {
        fprintf(stderr, "main rb_new rb is error!\n");
        return -1;
    }

    // 为tree填充字典数据
    dict_create(tree);

    // 我们输出一下 '你好'
    printf("你好吗 -> %s%s%s\n", 
        dict_get(tree, "你"), 
        dict_get(tree, "好"),
        dict_get(tree, "吗")
    );

    // 字典书删除
    rb_die(tree);

    getchar();
    return 0;
}

// 创建内容
void 
dict_create(rbtree_t tree) {
    char c;
    struct dict kv;
    // 打开文件内容
    FILE * txt = fopen(_STR_PATH, "rb");
    if (NULL == txt) {
        fprintf(stderr, "main fopen " _STR_PATH " rb is error!\n");
        return;
    }
    
    while ((c = fgetc(txt))!=EOF) {
        memset(&kv, 0, sizeof kv);
        // 读取这一行key, 并设值
        kv.key[0] = c;
        kv.key[1] = fgetc(txt);

        // 去掉\\t
        c = fgetc(txt);
        if(c < 0) {
            kv.key[2] = c;
            fgetc(txt);
        }

        // 再设置value
        kv.value[0] = fgetc(txt);
        kv.value[1] = fgetc(txt);
        
        c = fgetc(txt);
        if (c != '\r') {// 这些SB的代码, 都是解决不同系统版本的编码冲突的
            kv.value[2] = c;
            fgetc(txt);
        }

        // 去掉\n
        fgetc(txt);

        // 插入数据
        rb_insert(tree, &kv);
    }

    // 合法读取内容部分
    fclose(txt);
}

// 得到内容
const char * 
dict_get(rbtree_t tree, const char * key) {
    struct dict kv;
    strncpy(kv.key, key, sizeof(kv.key) / sizeof(char));
    struct dict * pkv = rb_get(tree, &kv);
    return pkv ? pkv->value : NULL;
}