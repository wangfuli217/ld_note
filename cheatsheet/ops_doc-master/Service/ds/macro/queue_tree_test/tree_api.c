struct TNODE{
    int key;
    SPLAY_ENTRY(TNODE) entry;
    ...
};

// 自定义比较函数
int node_cmp(struct TNODE* v1,struct TNODE* v2){
    if( v1->key < v2->key ){
        return -1;
    }
    else if( v1->key == v2->key ){
        return 0;
    }
    else{
        return 1;
    }
}

// 声明一颗伸展树
SPLAY_HEAD(CTX_TREE, TNODE) g_Root =  SPLAY_INITIALIZER(&g_Root);

//生成伸展树代码
SPLAY_GENERATE(CTX_TREE, TNODE, entry, node_cmp);

// 添加一个元素
struct TNODE* obj = SPLAY_INSERT(CTX_TREE, &g_Root, myObj);
if( obj ){
    printf("与现有节点冲突");
}
else{
    printf("添加成功");
}


// 删除一个节点自身
struct TNODE* obj = SPLAY_REMOVE(CTX_TREE, &g_Root, myObj);
if( obj ){
    printf("删除成功");
}
else{
    printf("没找到对应key");
}

// 删除一个key值为123的对象
struct TNODE find;
find.key = 123;
struct TNODE* obj = SPLAY_REMOVE(CTX_TREE, &g_Root, &find);
if( obj ){
    printf("删除成功");
}
else{
    printf("没找到对应key");
}

// 查找key值为123的对象
struct TNODE find;
find.key = 123;
struct TNODE* obj = SPLAY_FIND(CTX_TREE, &g_Root, &find);
if( obj ){
    printf("找到了");
}
else{
    printf("没找到");
}

// 遍历伸展树
for (np = SPLAY_MIN(CTX_TREE, &g_Root); np != NULL; np = SPLAY_NEXT(CTX_TREE, &g_Root, np)){
    printf("node %d\n", np->key);
}

// 伸展树判空
bool bEmpty = SPLAY_EMPTY(&g_Root);

//清空伸展树
for (var = SPLAY_MIN(NAME, head); var != NULL; var = nxt) {
   nxt = SPLAY_NEXT(NAME, head, var);
   SPLAY_REMOVE(NAME, head, var);
   free(var);
}

