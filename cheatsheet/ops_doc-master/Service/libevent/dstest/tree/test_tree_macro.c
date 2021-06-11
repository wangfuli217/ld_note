#include <stdio.h>
#include <stdlib.h>

struct INT {
    int data;
    struct {
        struct INT *spe_left;
        struct INT *spe_right;
    } link;
};
static int cmp (struct INT *x, struct INT *y) {
    return x->data - y->data;
}

struct INT_head {
    struct INT *sph_root;
} root = {
((void *) 0)};

extern void INT_head_SPLAY (struct INT_head *, struct INT *);
extern void INT_head_SPLAY_MINMAX (struct INT_head *, int);
extern struct INT *INT_head_SPLAY_INSERT (struct INT_head *, struct INT *);
extern struct INT *INT_head_SPLAY_REMOVE (struct INT_head *, struct INT *);
static inline struct INT *INT_head_SPLAY_FIND (struct INT_head *head, struct INT *elm) {
    if (((head)->sph_root == ((void *) 0)))
        return ((void *) 0);
    INT_head_SPLAY (head, elm);
    if ((cmp) (elm, (head)->sph_root) == 0)
        return head->sph_root;
    return ((void *) 0);
} static inline struct INT *INT_head_SPLAY_NEXT (struct INT_head *head, struct INT *elm) {

    INT_head_SPLAY (head, elm);
    if ((elm)->link.spe_right != ((void *) 0)) {
        elm = (elm)->link.spe_right;
        while ((elm)->link.spe_left != ((void *) 0))
            elm = (elm)->link.spe_left;
    } else
        elm = ((void *) 0);
    return elm;
}
static inline struct INT *INT_head_SPLAY_MIN_MAX (struct INT_head *head, int val) {
    INT_head_SPLAY_MINMAX (head, val);
    return (head)->sph_root;
};
struct INT *INT_head_SPLAY_INSERT (struct INT_head *head, struct INT *elm) {
    if (((head)->sph_root == ((void *) 0))) {
        (elm)->link.spe_left = (elm)->link.spe_right = ((void *) 0);
    } else {
        int __comp;
        INT_head_SPLAY (head, elm);
        __comp = (cmp) (elm, (head)->sph_root);
        if (__comp < 0) {
            (elm)->link.spe_left = ((head)->sph_root)->link.spe_left;
            (elm)->link.spe_right = (head)->sph_root;
            ((head)->sph_root)->link.spe_left = ((void *) 0);
        } else if (__comp > 0) {
            (elm)->link.spe_right = ((head)->sph_root)->link.spe_right;
            (elm)->link.spe_left = (head)->sph_root;
            ((head)->sph_root)->link.spe_right = ((void *) 0);
        } else
            return (head)->sph_root;
    }
    (head)->sph_root = (elm);
    return ((void *) 0);
} struct INT *INT_head_SPLAY_REMOVE (struct INT_head *head, struct INT *elm) {

    struct INT *__tmp;
    if (((head)->sph_root == ((void *) 0)))
        return ((void *) 0);
    INT_head_SPLAY (head, elm);
    if ((cmp) (elm, (head)->sph_root) == 0) {
        if (((head)->sph_root)->link.spe_left == ((void *) 0)) {
            (head)->sph_root = ((head)->sph_root)->link.spe_right;
        } else {
            __tmp = ((head)->sph_root)->link.spe_right;
            (head)->sph_root = ((head)->sph_root)->link.spe_left;
            INT_head_SPLAY (head, elm);
            ((head)->sph_root)->link.spe_right = __tmp;
        }
        return elm;
    }
    return ((void *) 0);
} void INT_head_SPLAY (struct INT_head *head, struct INT *elm) {

    struct INT __node, *__left, *__right, *__tmp;
    int __comp;
    (&__node)->link.spe_left = (&__node)->link.spe_right = ((void *) 0);
    __left = __right = &__node;
    while ((__comp = (cmp) (elm, (head)->sph_root)) != 0) {
        if (__comp < 0) {
            __tmp = ((head)->sph_root)->link.spe_left;
            if (__tmp == ((void *) 0))
                break;
            if ((cmp) (elm, __tmp) < 0) {
                do {
                    ((head)->sph_root)->link.spe_left = (__tmp)->link.spe_right;
                    (__tmp)->link.spe_right = (head)->sph_root;
                    (head)->sph_root = __tmp;
                } while (0);
                if (((head)->sph_root)->link.spe_left == ((void *) 0))
                    break;
            }
            do {
                (__right)->link.spe_left = (head)->sph_root;
                __right = (head)->sph_root;
                (head)->sph_root = ((head)->sph_root)->link.spe_left;
            } while (0);
        } else if (__comp > 0) {
            __tmp = ((head)->sph_root)->link.spe_right;
            if (__tmp == ((void *) 0))
                break;
            if ((cmp) (elm, __tmp) > 0) {
                do {
                    ((head)->sph_root)->link.spe_right = (__tmp)->link.spe_left;
                    (__tmp)->link.spe_left = (head)->sph_root;
                    (head)->sph_root = __tmp;
                } while (0);
                if (((head)->sph_root)->link.spe_right == ((void *) 0))
                    break;
            }
            do {
                (__left)->link.spe_right = (head)->sph_root;
                __left = (head)->sph_root;
                (head)->sph_root = ((head)->sph_root)->link.spe_right;
            } while (0);
        }
    }
    do {
        (__left)->link.spe_right = ((head)->sph_root)->link.spe_left;
        (__right)->link.spe_left = ((head)->sph_root)->link.spe_right;
        ((head)->sph_root)->link.spe_left = (&__node)->link.spe_right;
        ((head)->sph_root)->link.spe_right = (&__node)->link.spe_left;
    } while (0);
}
void INT_head_SPLAY_MINMAX (struct INT_head *head, int __comp) {
    struct INT __node, *__left, *__right, *__tmp;
    (&__node)->link.spe_left = (&__node)->link.spe_right = ((void *) 0);
    __left = __right = &__node;
    while (1) {
        if (__comp < 0) {
            __tmp = ((head)->sph_root)->link.spe_left;
            if (__tmp == ((void *) 0))
                break;
            if (__comp < 0) {
                do {
                    ((head)->sph_root)->link.spe_left = (__tmp)->link.spe_right;
                    (__tmp)->link.spe_right = (head)->sph_root;
                    (head)->sph_root = __tmp;
                } while (0);
                if (((head)->sph_root)->link.spe_left == ((void *) 0))
                    break;
            }
            do {
                (__right)->link.spe_left = (head)->sph_root;
                __right = (head)->sph_root;
                (head)->sph_root = ((head)->sph_root)->link.spe_left;
            } while (0);
        } else if (__comp > 0) {
            __tmp = ((head)->sph_root)->link.spe_right;
            if (__tmp == ((void *) 0))
                break;
            if (__comp > 0) {
                do {
                    ((head)->sph_root)->link.spe_right = (__tmp)->link.spe_left;
                    (__tmp)->link.spe_left = (head)->sph_root;
                    (head)->sph_root = __tmp;
                } while (0);
                if (((head)->sph_root)->link.spe_right == ((void *) 0))
                    break;
            }
            do {
                (__left)->link.spe_right = (head)->sph_root;
                __left = (head)->sph_root;
                (head)->sph_root = ((head)->sph_root)->link.spe_right;
            } while (0);
        }
    }
    do {
        (__left)->link.spe_right = ((head)->sph_root)->link.spe_left;
        (__right)->link.spe_left = ((head)->sph_root)->link.spe_right;
        ((head)->sph_root)->link.spe_left = (&__node)->link.spe_right;
        ((head)->sph_root)->link.spe_right = (&__node)->link.spe_left;
    } while (0);
};
static int test_splay_tree (void) {
    int i;
    struct INT *x, *y, f;

    for (i = 0; i < 10; i++) {
        x = (struct INT *) calloc (1, sizeof (struct INT));
        x->data = i + 10;
        INT_head_SPLAY_INSERT (&root, x);
    }
    for ((y) = (((&root)->sph_root == ((void *) 0)) ? ((void *) 0) : INT_head_SPLAY_MIN_MAX (&root, -1)); (y) != ((void *) 0); (y) = INT_head_SPLAY_NEXT (&root, y)) {
        printf ("%d \t", y->data);
    }
    printf ("\n\n");
    f.data = 15;
    printf ("before search\n");
    printf ("root %d\n", root.sph_root->data);
    y = INT_head_SPLAY_FIND (&root, &f);
    printf ("root %d\n", root.sph_root->data);
    printf ("%p %p\n", y->link.spe_left, y->link.spe_right);
    y = INT_head_SPLAY_FIND (&root, &f);
    printf ("%p %p\n", y->link.spe_left, y->link.spe_right);
    y = INT_head_SPLAY_FIND (&root, &f);
    y = INT_head_SPLAY_FIND (&root, &f);
    y = INT_head_SPLAY_NEXT (&root, y);
    if (y)
        printf ("\n the next of f is %d\n", y->data);
    else
        printf ("not find next\n");
    y = (((&root)->sph_root == ((void *) 0)) ? ((void *) 0) : INT_head_SPLAY_MIN_MAX (&root, -1));
    printf ("\n min :%d\n", y->data);
    y = (((&root)->sph_root == ((void *) 0)) ? ((void *) 0) : INT_head_SPLAY_MIN_MAX (&root, 1));
    printf ("\nmax:%d\n", y->data);
    if (y == ((void *) 0))
        printf ("elem not find\n");
    printf ("find %d\t", y->data);

    printf ("\n\n");
    for ((y) = (((&root)->sph_root == ((void *) 0)) ? ((void *) 0) : INT_head_SPLAY_MIN_MAX (&root, -1)); (y) != ((void *) 0); (y) = INT_head_SPLAY_NEXT (&root, y)) {
        printf ("%d \t", y->data);
    }

    y = INT_head_SPLAY_REMOVE (&root, &f);

    if (y)
        printf ("\n the next of f is %d\n", y->data);
    else
        printf ("not find next\n");
    y = INT_head_SPLAY_FIND (&root, &f);
    if (y == ((void *) 0))
        printf ("elem not find\n");

    printf ("\n\n");
    return 0;
}

struct RBINT {
    int data;
    struct {
        struct RBINT *rbe_left;
        struct RBINT *rbe_right;
        struct RBINT *rbe_parent;
        int rbe_color;
    } link;
};
static int rb_cmp (struct RBINT *x, struct RBINT *y) {
    return x->data - y->data;
}

struct RBINT_head {
    struct RBINT *rbh_root;
} root1 = {
((void *) 0)};

void RBINT_head_RB_INSERT_COLOR (struct RBINT_head *, struct RBINT *);
void RBINT_head_RB_REMOVE_COLOR (struct RBINT_head *, struct RBINT *, struct RBINT *);
struct RBINT *RBINT_head_RB_REMOVE (struct RBINT_head *, struct RBINT *);
struct RBINT *RBINT_head_RB_INSERT (struct RBINT_head *, struct RBINT *);
struct RBINT *RBINT_head_RB_FIND (struct RBINT_head *, struct RBINT *);
struct RBINT *RBINT_head_RB_NFIND (struct RBINT_head *, struct RBINT *);
struct RBINT *RBINT_head_RB_NEXT (struct RBINT *);
struct RBINT *RBINT_head_RB_PREV (struct RBINT *);
struct RBINT *RBINT_head_RB_MINMAX (struct RBINT_head *, int);;
void RBINT_head_RB_INSERT_COLOR (struct RBINT_head *head, struct RBINT *elm) {
    struct RBINT *parent, *gparent, *tmp;
    while ((parent = (elm)->link.rbe_parent) != ((void *) 0) && (parent)->link.rbe_color == 1) {
        gparent = (parent)->link.rbe_parent;
        if (parent == (gparent)->link.rbe_left) {
            tmp = (gparent)->link.rbe_right;
            if (tmp && (tmp)->link.rbe_color == 1) {
                (tmp)->link.rbe_color = 0;
                do {
                    (parent)->link.rbe_color = 0;
                    (gparent)->link.rbe_color = 1;
                } while (0);
                elm = gparent;
                continue;
            }
            if ((parent)->link.rbe_right == elm) {
                do {
                    (tmp) = (parent)->link.rbe_right;
                    if (((parent)->link.rbe_right = (tmp)->link.rbe_left) != ((void *) 0)) {
                        ((tmp)->link.rbe_left)->link.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent = (parent)->link.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->link.rbe_parent)->link.rbe_left)
                            ((parent)->link.rbe_parent)->link.rbe_left = (tmp);
                        else
                            ((parent)->link.rbe_parent)->link.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->link.rbe_left = (parent);
                    (parent)->link.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = parent;
                parent = elm;
                elm = tmp;
            }
            do {
                (parent)->link.rbe_color = 0;
                (gparent)->link.rbe_color = 1;
            } while (0);
            do {
                (tmp) = (gparent)->link.rbe_left;
                if (((gparent)->link.rbe_left = (tmp)->link.rbe_right) != ((void *) 0))
                    ((tmp)->link.rbe_right)->link.rbe_parent = (gparent);
                do {
                } while (0);
                if (((tmp)->link.rbe_parent = (gparent)->link.rbe_parent) != ((void *) 0)) {
                    if ((gparent) == ((gparent)->link.rbe_parent)->link.rbe_left)
                        ((gparent)->link.rbe_parent)->link.rbe_left = (tmp);
                    else
                        ((gparent)->link.rbe_parent)->link.rbe_right = (tmp);
                } else
                    (head)->rbh_root = (tmp);
                (tmp)->link.rbe_right = (gparent);
                (gparent)->link.rbe_parent = (tmp);
                do {
                } while (0);
                if (((tmp)->link.rbe_parent))
                    do {
                    } while (0);
            } while (0);
        } else {
            tmp = (gparent)->link.rbe_left;
            if (tmp && (tmp)->link.rbe_color == 1) {
                (tmp)->link.rbe_color = 0;
                do {
                    (parent)->link.rbe_color = 0;
                    (gparent)->link.rbe_color = 1;
                } while (0);
                elm = gparent;
                continue;
            }
            if ((parent)->link.rbe_left == elm) {
                do {
                    (tmp) = (parent)->link.rbe_left;
                    if (((parent)->link.rbe_left = (tmp)->link.rbe_right) != ((void *) 0))
                        ((tmp)->link.rbe_right)->link.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent = (parent)->link.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->link.rbe_parent)->link.rbe_left)
                            ((parent)->link.rbe_parent)->link.rbe_left = (tmp);
                        else
                            ((parent)->link.rbe_parent)->link.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->link.rbe_right = (parent);
                    (parent)->link.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = parent;
                parent = elm;
                elm = tmp;
            }
            do {
                (parent)->link.rbe_color = 0;
                (gparent)->link.rbe_color = 1;
            } while (0);
            do {
                (tmp) = (gparent)->link.rbe_right;
                if (((gparent)->link.rbe_right = (tmp)->link.rbe_left) != ((void *) 0)) {
                    ((tmp)->link.rbe_left)->link.rbe_parent = (gparent);
                }
                do {
                } while (0);
                if (((tmp)->link.rbe_parent = (gparent)->link.rbe_parent) != ((void *) 0)) {
                    if ((gparent) == ((gparent)->link.rbe_parent)->link.rbe_left)
                        ((gparent)->link.rbe_parent)->link.rbe_left = (tmp);
                    else
                        ((gparent)->link.rbe_parent)->link.rbe_right = (tmp);
                } else
                    (head)->rbh_root = (tmp);
                (tmp)->link.rbe_left = (gparent);
                (gparent)->link.rbe_parent = (tmp);
                do {
                } while (0);
                if (((tmp)->link.rbe_parent))
                    do {
                    } while (0);
            } while (0);
        }
    }
    (head->rbh_root)->link.rbe_color = 0;
}
void RBINT_head_RB_REMOVE_COLOR (struct RBINT_head *head, struct RBINT *parent, struct RBINT *elm) {
    struct RBINT *tmp;
    while ((elm == ((void *) 0) || (elm)->link.rbe_color == 0) && elm != (head)->rbh_root) {
        if ((parent)->link.rbe_left == elm) {
            tmp = (parent)->link.rbe_right;
            if ((tmp)->link.rbe_color == 1) {
                do {
                    (tmp)->link.rbe_color = 0;
                    (parent)->link.rbe_color = 1;
                } while (0);
                do {
                    (tmp) = (parent)->link.rbe_right;
                    if (((parent)->link.rbe_right = (tmp)->link.rbe_left) != ((void *) 0)) {
                        ((tmp)->link.rbe_left)->link.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent = (parent)->link.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->link.rbe_parent)->link.rbe_left)
                            ((parent)->link.rbe_parent)->link.rbe_left = (tmp);
                        else
                            ((parent)->link.rbe_parent)->link.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->link.rbe_left = (parent);
                    (parent)->link.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = (parent)->link.rbe_right;
            }
            if (((tmp)->link.rbe_left == ((void *) 0) || ((tmp)->link.rbe_left)->link.rbe_color == 0) && ((tmp)->link.rbe_right == ((void *) 0) || ((tmp)->link.rbe_right)->link.rbe_color == 0)) {
                (tmp)->link.rbe_color = 1;
                elm = parent;
                parent = (elm)->link.rbe_parent;
            } else {
                if ((tmp)->link.rbe_right == ((void *) 0) || ((tmp)->link.rbe_right)->link.rbe_color == 0) {
                    struct RBINT *oleft;
                    if ((oleft = (tmp)->link.rbe_left) != ((void *) 0))
                        (oleft)->link.rbe_color = 0;
                    (tmp)->link.rbe_color = 1;
                    do {
                        (oleft) = (tmp)->link.rbe_left;
                        if (((tmp)->link.rbe_left = (oleft)->link.rbe_right) != ((void *) 0))
                            ((oleft)->link.rbe_right)->link.rbe_parent = (tmp);
                        do {
                        } while (0);
                        if (((oleft)->link.rbe_parent = (tmp)->link.rbe_parent) != ((void *) 0)) {
                            if ((tmp) == ((tmp)->link.rbe_parent)->link.rbe_left)
                                ((tmp)->link.rbe_parent)->link.rbe_left = (oleft);
                            else
                                ((tmp)->link.rbe_parent)->link.rbe_right = (oleft);
                        } else
                            (head)->rbh_root = (oleft);
                        (oleft)->link.rbe_right = (tmp);
                        (tmp)->link.rbe_parent = (oleft);
                        do {
                        } while (0);
                        if (((oleft)->link.rbe_parent))
                            do {
                            } while (0);
                    } while (0);
                    tmp = (parent)->link.rbe_right;
                }
                (tmp)->link.rbe_color = (parent)->link.rbe_color;
                (parent)->link.rbe_color = 0;
                if ((tmp)->link.rbe_right)
                    ((tmp)->link.rbe_right)->link.rbe_color = 0;
                do {
                    (tmp) = (parent)->link.rbe_right;
                    if (((parent)->link.rbe_right = (tmp)->link.rbe_left) != ((void *) 0)) {
                        ((tmp)->link.rbe_left)->link.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent = (parent)->link.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->link.rbe_parent)->link.rbe_left)
                            ((parent)->link.rbe_parent)->link.rbe_left = (tmp);
                        else
                            ((parent)->link.rbe_parent)->link.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->link.rbe_left = (parent);
                    (parent)->link.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                elm = (head)->rbh_root;
                break;
            }
        } else {
            tmp = (parent)->link.rbe_left;
            if ((tmp)->link.rbe_color == 1) {
                do {
                    (tmp)->link.rbe_color = 0;
                    (parent)->link.rbe_color = 1;
                } while (0);
                do {
                    (tmp) = (parent)->link.rbe_left;
                    if (((parent)->link.rbe_left = (tmp)->link.rbe_right) != ((void *) 0))
                        ((tmp)->link.rbe_right)->link.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent = (parent)->link.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->link.rbe_parent)->link.rbe_left)
                            ((parent)->link.rbe_parent)->link.rbe_left = (tmp);
                        else
                            ((parent)->link.rbe_parent)->link.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->link.rbe_right = (parent);
                    (parent)->link.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = (parent)->link.rbe_left;
            }
            if (((tmp)->link.rbe_left == ((void *) 0) || ((tmp)->link.rbe_left)->link.rbe_color == 0) && ((tmp)->link.rbe_right == ((void *) 0) || ((tmp)->link.rbe_right)->link.rbe_color == 0)) {
                (tmp)->link.rbe_color = 1;
                elm = parent;
                parent = (elm)->link.rbe_parent;
            } else {
                if ((tmp)->link.rbe_left == ((void *) 0) || ((tmp)->link.rbe_left)->link.rbe_color == 0) {
                    struct RBINT *oright;
                    if ((oright = (tmp)->link.rbe_right) != ((void *) 0))
                        (oright)->link.rbe_color = 0;
                    (tmp)->link.rbe_color = 1;
                    do {
                        (oright) = (tmp)->link.rbe_right;
                        if (((tmp)->link.rbe_right = (oright)->link.rbe_left) != ((void *) 0)) {
                            ((oright)->link.rbe_left)->link.rbe_parent = (tmp);
                        }
                        do {
                        } while (0);
                        if (((oright)->link.rbe_parent = (tmp)->link.rbe_parent) != ((void *) 0)) {
                            if ((tmp) == ((tmp)->link.rbe_parent)->link.rbe_left)
                                ((tmp)->link.rbe_parent)->link.rbe_left = (oright);
                            else
                                ((tmp)->link.rbe_parent)->link.rbe_right = (oright);
                        } else
                            (head)->rbh_root = (oright);
                        (oright)->link.rbe_left = (tmp);
                        (tmp)->link.rbe_parent = (oright);
                        do {
                        } while (0);
                        if (((oright)->link.rbe_parent))
                            do {
                            } while (0);
                    } while (0);
                    tmp = (parent)->link.rbe_left;
                }
                (tmp)->link.rbe_color = (parent)->link.rbe_color;
                (parent)->link.rbe_color = 0;
                if ((tmp)->link.rbe_left)
                    ((tmp)->link.rbe_left)->link.rbe_color = 0;
                do {
                    (tmp) = (parent)->link.rbe_left;
                    if (((parent)->link.rbe_left = (tmp)->link.rbe_right) != ((void *) 0))
                        ((tmp)->link.rbe_right)->link.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent = (parent)->link.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->link.rbe_parent)->link.rbe_left)
                            ((parent)->link.rbe_parent)->link.rbe_left = (tmp);
                        else
                            ((parent)->link.rbe_parent)->link.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->link.rbe_right = (parent);
                    (parent)->link.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->link.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                elm = (head)->rbh_root;
                break;
            }
        }
    }
    if (elm)
        (elm)->link.rbe_color = 0;
}
struct RBINT *RBINT_head_RB_REMOVE (struct RBINT_head *head, struct RBINT *elm) {
    struct RBINT *child, *parent, *old = elm;
    int color;
    if ((elm)->link.rbe_left == ((void *) 0))
        child = (elm)->link.rbe_right;
    else if ((elm)->link.rbe_right == ((void *) 0))
        child = (elm)->link.rbe_left;
    else {
        struct RBINT *left;
        elm = (elm)->link.rbe_right;
        while ((left = (elm)->link.rbe_left) != ((void *) 0))
            elm = left;
        child = (elm)->link.rbe_right;
        parent = (elm)->link.rbe_parent;
        color = (elm)->link.rbe_color;
        if (child)
            (child)->link.rbe_parent = parent;
        if (parent) {
            if ((parent)->link.rbe_left == elm)
                (parent)->link.rbe_left = child;
            else
                (parent)->link.rbe_right = child;
            do {
            } while (0);
        } else
            (head)->rbh_root = child;
        if ((elm)->link.rbe_parent == old)
            parent = elm;
        (elm)->link = (old)->link;
        if ((old)->link.rbe_parent) {
            if (((old)->link.rbe_parent)->link.rbe_left == old)
                ((old)->link.rbe_parent)->link.rbe_left = elm;
            else
                ((old)->link.rbe_parent)->link.rbe_right = elm;
            do {
            } while (0);
        } else
            (head)->rbh_root = elm;
        ((old)->link.rbe_left)->link.rbe_parent = elm;
        if ((old)->link.rbe_right)
            ((old)->link.rbe_right)->link.rbe_parent = elm;
        if (parent) {
            left = parent;
            do {
                do {
                } while (0);
            } while ((left = (left)->link.rbe_parent) != ((void *) 0));
        }
        goto color;
    }
    parent = (elm)->link.rbe_parent;
    color = (elm)->link.rbe_color;
    if (child)
        (child)->link.rbe_parent = parent;
    if (parent) {
        if ((parent)->link.rbe_left == elm)
            (parent)->link.rbe_left = child;
        else
            (parent)->link.rbe_right = child;
        do {
        } while (0);
    } else
        (head)->rbh_root = child;
  color:if (color == 0)
        RBINT_head_RB_REMOVE_COLOR (head, parent, child);
    return old;
}
struct RBINT *RBINT_head_RB_INSERT (struct RBINT_head *head, struct RBINT *elm) {
    struct RBINT *tmp;
    struct RBINT *parent = ((void *) 0);
    int comp = 0;
    tmp = (head)->rbh_root;
    while (tmp) {
        parent = tmp;
        comp = (rb_cmp) (elm, parent);
        if (comp < 0)
            tmp = (tmp)->link.rbe_left;
        else if (comp > 0)
            tmp = (tmp)->link.rbe_right;
        else
            return tmp;
    }
    do {
        (elm)->link.rbe_parent = parent;
        (elm)->link.rbe_left = (elm)->link.rbe_right = ((void *) 0);
        (elm)->link.rbe_color = 1;
    } while (0);
    if (parent != ((void *) 0)) {
        if (comp < 0)
            (parent)->link.rbe_left = elm;
        else
            (parent)->link.rbe_right = elm;
        do {
        } while (0);
    } else
        (head)->rbh_root = elm;
    RBINT_head_RB_INSERT_COLOR (head, elm);
    return ((void *) 0);
} struct RBINT *RBINT_head_RB_FIND (struct RBINT_head *head, struct RBINT *elm) {

    struct RBINT *tmp = (head)->rbh_root;
    int comp;
    while (tmp) {
        comp = rb_cmp (elm, tmp);
        if (comp < 0)
            tmp = (tmp)->link.rbe_left;
        else if (comp > 0)
            tmp = (tmp)->link.rbe_right;
        else
            return tmp;
    }
    return ((void *) 0);
} struct RBINT *RBINT_head_RB_NFIND (struct RBINT_head *head, struct RBINT *elm) {

    struct RBINT *tmp = (head)->rbh_root;
    struct RBINT *res = ((void *) 0);
    int comp;
    while (tmp) {
        comp = rb_cmp (elm, tmp);
        if (comp < 0) {
            res = tmp;
            tmp = (tmp)->link.rbe_left;
        } else if (comp > 0)
            tmp = (tmp)->link.rbe_right;
        else
            return tmp;
    }
    return res;
}
struct RBINT *RBINT_head_RB_NEXT (struct RBINT *elm) {
    if ((elm)->link.rbe_right) {
        elm = (elm)->link.rbe_right;
        while ((elm)->link.rbe_left)
            elm = (elm)->link.rbe_left;
    } else {
        if ((elm)->link.rbe_parent && (elm == ((elm)->link.rbe_parent)->link.rbe_left))
            elm = (elm)->link.rbe_parent;
        else {
            while ((elm)->link.rbe_parent && (elm == ((elm)->link.rbe_parent)->link.rbe_right))
                elm = (elm)->link.rbe_parent;
            elm = (elm)->link.rbe_parent;
        }
    }
    return elm;
}
struct RBINT *RBINT_head_RB_PREV (struct RBINT *elm) {
    if ((elm)->link.rbe_left) {
        elm = (elm)->link.rbe_left;
        while ((elm)->link.rbe_right)
            elm = (elm)->link.rbe_right;
    } else {
        if ((elm)->link.rbe_parent && (elm == ((elm)->link.rbe_parent)->link.rbe_right))
            elm = (elm)->link.rbe_parent;
        else {
            while ((elm)->link.rbe_parent && (elm == ((elm)->link.rbe_parent)->link.rbe_left))
                elm = (elm)->link.rbe_parent;
            elm = (elm)->link.rbe_parent;
        }
    }
    return elm;
}
struct RBINT *RBINT_head_RB_MINMAX (struct RBINT_head *head, int val) {
    struct RBINT *tmp = (head)->rbh_root;
    struct RBINT *parent = ((void *) 0);
    while (tmp) {
        parent = tmp;
        if (val < 0)
            tmp = (tmp)->link.rbe_left;
        else
            tmp = (tmp)->link.rbe_right;
    }
    return parent;
};
static int test_rb_tree (void) {
    int i;
    struct RBINT *x, *y, f;

    for (i = 0; i < 10; i++) {
        x = (struct RBINT *) calloc (1, sizeof (struct RBINT));
        x->data = i + 10;
        RBINT_head_RB_INSERT (&root1, x);
    }
    for ((y) = RBINT_head_RB_MINMAX (&root1, -1); (y) != ((void *) 0); (y) = RBINT_head_RB_NEXT (y)) {
        printf ("%d \t", y->data);
    }
    printf ("\n\n");
    f.data = 15;
    printf ("before search\n");
    printf ("root %d\n", root1.rbh_root->data);
    y = RBINT_head_RB_FIND (&root1, &f);
    printf ("root %d\n", root1.rbh_root->data);
    printf ("%p %p\n", y->link.rbe_left, y->link.rbe_right);
    y = RBINT_head_RB_FIND (&root1, &f);
    printf ("%p %p\n", y->link.rbe_left, y->link.rbe_right);
    y = RBINT_head_RB_FIND (&root1, &f);
    y = RBINT_head_RB_FIND (&root1, &f);
    y = RBINT_head_RB_NEXT (y);
    if (y)
        printf ("\n the next of f is %d\n", y->data);
    else
        printf ("not find next\n");
    y = RBINT_head_RB_MINMAX (&root1, -1);
    printf ("\n min :%d\n", y->data);
    y = RBINT_head_RB_MINMAX (&root1, 1);
    printf ("\nmax:%d\n", y->data);
    if (y == ((void *) 0))
        printf ("elem not find\n");
    printf ("find %d\t", y->data);

    printf ("\n\n");
    for ((y) = RBINT_head_RB_MINMAX (&root1, -1); (y) != ((void *) 0); (y) = RBINT_head_RB_NEXT (y)) {
        printf ("%d \t", y->data);
    }

    y = RBINT_head_RB_MINMAX (&root1, 1);
    y = RBINT_head_RB_REMOVE (&root1, y);

    if (y)
        printf ("\n the next of f is %d\n", y->data);
    else
        printf ("not find next\n");
    f.data = 19;
    y = RBINT_head_RB_FIND (&root1, &f);
    if (y == ((void *) 0))
        printf ("elem not find\n");

    printf ("\n\n");
    return 0;
}
int main (void) {
    test_splay_tree ();
    test_rb_tree ();
    return 0;
}
