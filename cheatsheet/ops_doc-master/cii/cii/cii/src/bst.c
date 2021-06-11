#include"mem.h"
#include"assert.h"
#include"bst.h"

#define T bst_t

struct T{
    T left,right, parent;
    void *key;
};


static int      _cmp_simple(const void *x, const void *y);
static T        _bst_remove_child(T bst, T child);
static T        _bst_replace_child(T bst, T child, T node);
static void    *_bst_set_key(T bst, void *key);

T   
bst_new
(void *key)
{
    return bst_insert(NULL, key, NULL);
}

void *
bst_get_key
(T bst)
{
    return bst->key;
}

T
bst_minimum
(T bst)
{
    assert(bst);
    while(bst->left)
        bst = bst->left;

    return bst;
}


T
bst_maximum
(T bst)
{
    assert(bst);

    while(bst->right)
        bst = bst->right;

    return bst;
}


T
bst_successor
(T bst)
{
    T x, y;

    assert(bst);
    if(NULL != bst->right)
        return bst_minimum(bst->right);

    x = bst;
    y = x->parent;
    while(NULL != y && (x = y->right)){
        x = y;
        y = y->parent; 
    }

    return y;
}


T
bst_predecessor
(T bst)
{
    T x, y;

    assert(bst);
    if(NULL != bst->left)
        return bst_maximum(bst->left);

    x = bst;
    y = x->parent;
    while(NULL != y && (x = y->left)){
        x = y;
        y = y->parent; 
    }

    return y;
}

T
bst_find
(T bst, void *key, 
    int(*cmp)(const void *x, const void *y))
{
    int flag;

    assert(key);
    if(NULL == bst)
        return NULL;

    if(NULL == cmp)
        cmp = _cmp_simple;
    flag = cmp(key, bst->key);
    if(0 == flag)
        return bst;
    if(flag < 0){
        return bst_find(bst->left, key, cmp);
    }else{
        return bst_find(bst->right, key, cmp);
    }

}

/*

T
bst_insert
(T bst, void *key,
    int(*cmp)(const void *x, const void *y))
{

    T tree;
    int flag;
    
    assert(key);
    tree = bst;
    if(NULL == tree){
        NEW(tree);
        tree->key = key;
        tree->left = tree->right = NULL;
        return tree;
    }

    if(NULL == cmp)
        cmp = _cmp_simple;
    flag = cmp(key, tree->key);
    if(0 == flag)
        return tree;
    if(flag < 0){
        return bst_insert(tree->left, key, cmp);
    }else{
        return bst_insert(tree->right, key, cmp);
    }
}*/

T
bst_insert
(T bst, void *key,
    int(*cmp)(const void *x, const void *y))
{
    /** use iterative version to solve parent node*/
    T *tree, parent;
    int flag;

    if(NULL == cmp)
        cmp = _cmp_simple;
    tree = &bst;
    parent = NULL;
    while(NULL != *tree){
        
        parent = *tree;
        flag = cmp(key, (*tree)->key);

        if(0 == flag)
            return *tree;
        else if(flag < 0)
            tree = &((*tree)->left);
        else
            tree = &((*tree)->right);
    }

    NEW(*tree); 
    (*tree)->parent = parent;
    (*tree)->key = key;
    (*tree)->left = (*tree)->right = NULL;
    return *tree;
}


T
bst_delete
(T bst)
{
    T parent, successor;
    assert(bst);
    parent = bst->parent;
    if(NULL == bst->left && NULL == bst->right){
        return _bst_remove_child(parent, bst);
    }else if(NULL != bst->right && NULL != bst->left){
        successor = bst_successor(bst);
        _bst_remove_child(successor->parent, successor);
        _bst_set_key(bst, bst_get_key(successor));
    }
    else if(NULL != bst->right){
        return _bst_replace_child(parent, bst, bst->right);
    }else if(NULL != bst->left){
        return _bst_replace_child(parent, bst, bst->left);
    }
}


void
bst_traverse
(T bst, 
    void (*apply)(const void *key, void *cl),
    void *cl)
{
    
    if(NULL != bst){
        bst_traverse(bst->left, apply, cl);
        apply(bst->key, cl);
        bst_traverse(bst->right, apply, cl);
    }
}


static
int 
_cmp_simple
(const void *x, const void *y)
{
    if(x == y)
        return 0;
    if(x < y)
        return -1;
    if(x > y )
        return 1;
}

static
T
_bst_remove_child
(T bst, T child)
{
    assert(child->parent == bst);
    
    if(NULL == bst){
        return child;
    }else if(bst->left == child){
        bst->left = NULL;
    }else if(bst->right == child){
        bst->right = NULL; 
    }
    child->parent = NULL;

    return child;
}


static 
T
_bst_replace_child
(T bst, T child, T node)
{
    assert(child->parent = bst);
    assert(bst->left == child || bst->right == child);

    node->parent = NULL;

    if(NULL == bst){
        return node;
    }else if(bst->left == child){
        bst->left = node;
    }else if(bst->right == child){
        bst->right = node;
    }
    node->parent = bst;

    return node;
}


static
void *
_bst_set_key
(T bst, void *key)
{
    assert(bst);
    bst->key = key;
}
