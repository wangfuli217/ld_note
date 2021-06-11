#include <err.h>                /* err() */                                                          
#include <stdio.h>              /* printf(), puts() */                                               
#include <stdlib.h>             /* calloc(), free() */                                               
#include <string.h>             /* strcmp() */  

struct cnode {
    struct {
        struct cnode *rbe_left;
        struct cnode *rbe_right;
        struct cnode *rbe_parent;
        int rbe_color;
    } entry;
    char *key;
    int value;
};

static int cnodecmp (struct cnode *a, struct cnode *b) {
    return strcmp (a->key, b->key);
}

struct ctree {
    struct cnode *rbh_root;
};
void ctree_RB_INSERT_COLOR (struct ctree *, struct cnode *);
void ctree_RB_REMOVE_COLOR (struct ctree *, struct cnode *, struct cnode *);
struct cnode *ctree_RB_REMOVE (struct ctree *, struct cnode *);
struct cnode *ctree_RB_INSERT (struct ctree *, struct cnode *);
struct cnode *ctree_RB_FIND (struct ctree *, struct cnode *);
struct cnode *ctree_RB_NFIND (struct ctree *, struct cnode *);
struct cnode *ctree_RB_NEXT (struct cnode *);
struct cnode *ctree_RB_PREV (struct cnode *);
struct cnode *ctree_RB_MINMAX (struct ctree *, int);;
void ctree_RB_INSERT_COLOR (struct ctree *head, struct cnode *elm) {
    struct cnode *parent, *gparent, *tmp;
    while ((parent = (elm)->entry.rbe_parent) != ((void *) 0) && (parent)->entry.rbe_color == 1) {
        gparent = (parent)->entry.rbe_parent;
        if (parent == (gparent)->entry.rbe_left) {
            tmp = (gparent)->entry.rbe_right;
            if (tmp && (tmp)->entry.rbe_color == 1) {
                (tmp)->entry.rbe_color = 0;
                do {
                    (parent)->entry.rbe_color = 0;
                    (gparent)->entry.rbe_color = 1;
                } while (0);
                elm = gparent;
                continue;
            }
            if ((parent)->entry.rbe_right == elm) {
                do {
                    (tmp) = (parent)->entry.rbe_right;
                    if (((parent)->entry.rbe_right = (tmp)->entry.rbe_left) != ((void *) 0)) {
                        ((tmp)->entry.rbe_left)->entry.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_left = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = parent;
                parent = elm;
                elm = tmp;
            }
            do {
                (parent)->entry.rbe_color = 0;
                (gparent)->entry.rbe_color = 1;
            } while (0);
            do {
                (tmp) = (gparent)->entry.rbe_left;
                if (((gparent)->entry.rbe_left = (tmp)->entry.rbe_right) != ((void *) 0))
                    ((tmp)->entry.rbe_right)->entry.rbe_parent = (gparent);
                do {
                } while (0);
                if (((tmp)->entry.rbe_parent = (gparent)->entry.rbe_parent) != ((void *) 0)) {
                    if ((gparent) == ((gparent)->entry.rbe_parent)->entry.rbe_left)
                        ((gparent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                    else
                        ((gparent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                } else
                    (head)->rbh_root = (tmp);
                (tmp)->entry.rbe_right = (gparent);
                (gparent)->entry.rbe_parent = (tmp);
                do {
                } while (0);
                if (((tmp)->entry.rbe_parent))
                    do {
                    } while (0);
            } while (0);
        } else {
            tmp = (gparent)->entry.rbe_left;
            if (tmp && (tmp)->entry.rbe_color == 1) {
                (tmp)->entry.rbe_color = 0;
                do {
                    (parent)->entry.rbe_color = 0;
                    (gparent)->entry.rbe_color = 1;
                } while (0);
                elm = gparent;
                continue;
            }
            if ((parent)->entry.rbe_left == elm) {
                do {
                    (tmp) = (parent)->entry.rbe_left;
                    if (((parent)->entry.rbe_left = (tmp)->entry.rbe_right) != ((void *) 0))
                        ((tmp)->entry.rbe_right)->entry.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_right = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = parent;
                parent = elm;
                elm = tmp;
            }
            do {
                (parent)->entry.rbe_color = 0;
                (gparent)->entry.rbe_color = 1;
            } while (0);
            do {
                (tmp) = (gparent)->entry.rbe_right;
                if (((gparent)->entry.rbe_right = (tmp)->entry.rbe_left) != ((void *) 0)) {
                    ((tmp)->entry.rbe_left)->entry.rbe_parent = (gparent);
                }
                do {
                } while (0);
                if (((tmp)->entry.rbe_parent = (gparent)->entry.rbe_parent) != ((void *) 0)) {
                    if ((gparent) == ((gparent)->entry.rbe_parent)->entry.rbe_left)
                        ((gparent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                    else
                        ((gparent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                } else
                    (head)->rbh_root = (tmp);
                (tmp)->entry.rbe_left = (gparent);
                (gparent)->entry.rbe_parent = (tmp);
                do {
                } while (0);
                if (((tmp)->entry.rbe_parent))
                    do {
                    } while (0);
            } while (0);
        }
    }
    (head->rbh_root)->entry.rbe_color = 0;
}
void ctree_RB_REMOVE_COLOR (struct ctree *head, struct cnode *parent, struct cnode *elm) {
    struct cnode *tmp;
    while ((elm == ((void *) 0) || (elm)->entry.rbe_color == 0) && elm != (head)->rbh_root) {
        if ((parent)->entry.rbe_left == elm) {
            tmp = (parent)->entry.rbe_right;
            if ((tmp)->entry.rbe_color == 1) {
                do {
                    (tmp)->entry.rbe_color = 0;
                    (parent)->entry.rbe_color = 1;
                } while (0);
                do {
                    (tmp) = (parent)->entry.rbe_right;
                    if (((parent)->entry.rbe_right = (tmp)->entry.rbe_left) != ((void *) 0)) {
                        ((tmp)->entry.rbe_left)->entry.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_left = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = (parent)->entry.rbe_right;
            }
            if (((tmp)->entry.rbe_left == ((void *) 0) || ((tmp)->entry.rbe_left)->entry.rbe_color == 0) && ((tmp)->entry.rbe_right == ((void *) 0) || ((tmp)->entry.rbe_right)->entry.rbe_color == 0)) {
                (tmp)->entry.rbe_color = 1;
                elm = parent;
                parent = (elm)->entry.rbe_parent;
            } else {
                if ((tmp)->entry.rbe_right == ((void *) 0) || ((tmp)->entry.rbe_right)->entry.rbe_color == 0) {
                    struct cnode *oleft;
                    if ((oleft = (tmp)->entry.rbe_left) != ((void *) 0))
                        (oleft)->entry.rbe_color = 0;
                    (tmp)->entry.rbe_color = 1;
                    do {
                        (oleft) = (tmp)->entry.rbe_left;
                        if (((tmp)->entry.rbe_left = (oleft)->entry.rbe_right) != ((void *) 0))
                            ((oleft)->entry.rbe_right)->entry.rbe_parent = (tmp);
                        do {
                        } while (0);
                        if (((oleft)->entry.rbe_parent = (tmp)->entry.rbe_parent) != ((void *) 0)) {
                            if ((tmp) == ((tmp)->entry.rbe_parent)->entry.rbe_left)
                                ((tmp)->entry.rbe_parent)->entry.rbe_left = (oleft);
                            else
                                ((tmp)->entry.rbe_parent)->entry.rbe_right = (oleft);
                        } else
                            (head)->rbh_root = (oleft);
                        (oleft)->entry.rbe_right = (tmp);
                        (tmp)->entry.rbe_parent = (oleft);
                        do {
                        } while (0);
                        if (((oleft)->entry.rbe_parent))
                            do {
                            } while (0);
                    } while (0);
                    tmp = (parent)->entry.rbe_right;
                }
                (tmp)->entry.rbe_color = (parent)->entry.rbe_color;
                (parent)->entry.rbe_color = 0;
                if ((tmp)->entry.rbe_right)
                    ((tmp)->entry.rbe_right)->entry.rbe_color = 0;
                do {
                    (tmp) = (parent)->entry.rbe_right;
                    if (((parent)->entry.rbe_right = (tmp)->entry.rbe_left) != ((void *) 0)) {
                        ((tmp)->entry.rbe_left)->entry.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_left = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                elm = (head)->rbh_root;
                break;
            }
        } else {
            tmp = (parent)->entry.rbe_left;
            if ((tmp)->entry.rbe_color == 1) {
                do {
                    (tmp)->entry.rbe_color = 0;
                    (parent)->entry.rbe_color = 1;
                } while (0);
                do {
                    (tmp) = (parent)->entry.rbe_left;
                    if (((parent)->entry.rbe_left = (tmp)->entry.rbe_right) != ((void *) 0))
                        ((tmp)->entry.rbe_right)->entry.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_right = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = (parent)->entry.rbe_left;
            }
            if (((tmp)->entry.rbe_left == ((void *) 0) || ((tmp)->entry.rbe_left)->entry.rbe_color == 0) && ((tmp)->entry.rbe_right == ((void *) 0) || ((tmp)->entry.rbe_right)->entry.rbe_color == 0)) {
                (tmp)->entry.rbe_color = 1;
                elm = parent;
                parent = (elm)->entry.rbe_parent;
            } else {
                if ((tmp)->entry.rbe_left == ((void *) 0) || ((tmp)->entry.rbe_left)->entry.rbe_color == 0) {
                    struct cnode *oright;
                    if ((oright = (tmp)->entry.rbe_right) != ((void *) 0))
                        (oright)->entry.rbe_color = 0;
                    (tmp)->entry.rbe_color = 1;
                    do {
                        (oright) = (tmp)->entry.rbe_right;
                        if (((tmp)->entry.rbe_right = (oright)->entry.rbe_left) != ((void *) 0)) {
                            ((oright)->entry.rbe_left)->entry.rbe_parent = (tmp);
                        }
                        do {
                        } while (0);
                        if (((oright)->entry.rbe_parent = (tmp)->entry.rbe_parent) != ((void *) 0)) {
                            if ((tmp) == ((tmp)->entry.rbe_parent)->entry.rbe_left)
                                ((tmp)->entry.rbe_parent)->entry.rbe_left = (oright);
                            else
                                ((tmp)->entry.rbe_parent)->entry.rbe_right = (oright);
                        } else
                            (head)->rbh_root = (oright);
                        (oright)->entry.rbe_left = (tmp);
                        (tmp)->entry.rbe_parent = (oright);
                        do {
                        } while (0);
                        if (((oright)->entry.rbe_parent))
                            do {
                            } while (0);
                    } while (0);
                    tmp = (parent)->entry.rbe_left;
                }
                (tmp)->entry.rbe_color = (parent)->entry.rbe_color;
                (parent)->entry.rbe_color = 0;
                if ((tmp)->entry.rbe_left)
                    ((tmp)->entry.rbe_left)->entry.rbe_color = 0;
                do {
                    (tmp) = (parent)->entry.rbe_left;
                    if (((parent)->entry.rbe_left = (tmp)->entry.rbe_right) != ((void *) 0))
                        ((tmp)->entry.rbe_right)->entry.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_right = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                elm = (head)->rbh_root;
                break;
            }
        }
    }
    if (elm)
        (elm)->entry.rbe_color = 0;
}
struct cnode *ctree_RB_REMOVE (struct ctree *head, struct cnode *elm) {
    struct cnode *child, *parent, *old = elm;
    int color;
    if ((elm)->entry.rbe_left == ((void *) 0))
        child = (elm)->entry.rbe_right;
    else if ((elm)->entry.rbe_right == ((void *) 0))
        child = (elm)->entry.rbe_left;
    else {
        struct cnode *left;
        elm = (elm)->entry.rbe_right;
        while ((left = (elm)->entry.rbe_left) != ((void *) 0))
            elm = left;
        child = (elm)->entry.rbe_right;
        parent = (elm)->entry.rbe_parent;
        color = (elm)->entry.rbe_color;
        if (child)
            (child)->entry.rbe_parent = parent;
        if (parent) {
            if ((parent)->entry.rbe_left == elm)
                (parent)->entry.rbe_left = child;
            else
                (parent)->entry.rbe_right = child;
            do {
            } while (0);
        } else
            (head)->rbh_root = child;
        if ((elm)->entry.rbe_parent == old)
            parent = elm;
        (elm)->entry = (old)->entry;
        if ((old)->entry.rbe_parent) {
            if (((old)->entry.rbe_parent)->entry.rbe_left == old)
                ((old)->entry.rbe_parent)->entry.rbe_left = elm;
            else
                ((old)->entry.rbe_parent)->entry.rbe_right = elm;
            do {
            } while (0);
        } else
            (head)->rbh_root = elm;
        ((old)->entry.rbe_left)->entry.rbe_parent = elm;
        if ((old)->entry.rbe_right)
            ((old)->entry.rbe_right)->entry.rbe_parent = elm;
        if (parent) {
            left = parent;
            do {
                do {
                } while (0);
            } while ((left = (left)->entry.rbe_parent) != ((void *) 0));
        }
        goto color;
    }
    parent = (elm)->entry.rbe_parent;
    color = (elm)->entry.rbe_color;
    if (child)
        (child)->entry.rbe_parent = parent;
    if (parent) {
        if ((parent)->entry.rbe_left == elm)
            (parent)->entry.rbe_left = child;
        else
            (parent)->entry.rbe_right = child;
        do {
        } while (0);
    } else
        (head)->rbh_root = child;
  color:if (color == 0)
        ctree_RB_REMOVE_COLOR (head, parent, child);
    return old;
}
struct cnode *ctree_RB_INSERT (struct ctree *head, struct cnode *elm) {
    struct cnode *tmp;
    struct cnode *parent = ((void *) 0);
    int comp = 0;
    tmp = (head)->rbh_root;
    while (tmp) {
        parent = tmp;
        comp = (cnodecmp) (elm, parent);
        if (comp < 0)
            tmp = (tmp)->entry.rbe_left;
        else if (comp > 0)
            tmp = (tmp)->entry.rbe_right;
        else
            return tmp;
    }
    do {
        (elm)->entry.rbe_parent = parent;
        (elm)->entry.rbe_left = (elm)->entry.rbe_right = ((void *) 0);
        (elm)->entry.rbe_color = 1;
    } while (0);
    if (parent != ((void *) 0)) {
        if (comp < 0)
            (parent)->entry.rbe_left = elm;
        else
            (parent)->entry.rbe_right = elm;
        do {
        } while (0);
    } else
        (head)->rbh_root = elm;
    ctree_RB_INSERT_COLOR (head, elm);
    return ((void *) 0);
} struct cnode *ctree_RB_FIND (struct ctree *head, struct cnode *elm) {

    struct cnode *tmp = (head)->rbh_root;
    int comp;
    while (tmp) {
        comp = cnodecmp (elm, tmp);
        if (comp < 0)
            tmp = (tmp)->entry.rbe_left;
        else if (comp > 0)
            tmp = (tmp)->entry.rbe_right;
        else
            return tmp;
    }
    return ((void *) 0);
} struct cnode *ctree_RB_NFIND (struct ctree *head, struct cnode *elm) {

    struct cnode *tmp = (head)->rbh_root;
    struct cnode *res = ((void *) 0);
    int comp;
    while (tmp) {
        comp = cnodecmp (elm, tmp);
        if (comp < 0) {
            res = tmp;
            tmp = (tmp)->entry.rbe_left;
        } else if (comp > 0)
            tmp = (tmp)->entry.rbe_right;
        else
            return tmp;
    }
    return res;
}
struct cnode *ctree_RB_NEXT (struct cnode *elm) {
    if ((elm)->entry.rbe_right) {
        elm = (elm)->entry.rbe_right;
        while ((elm)->entry.rbe_left)
            elm = (elm)->entry.rbe_left;
    } else {
        if ((elm)->entry.rbe_parent && (elm == ((elm)->entry.rbe_parent)->entry.rbe_left))
            elm = (elm)->entry.rbe_parent;
        else {
            while ((elm)->entry.rbe_parent && (elm == ((elm)->entry.rbe_parent)->entry.rbe_right))
                elm = (elm)->entry.rbe_parent;
            elm = (elm)->entry.rbe_parent;
        }
    }
    return elm;
}
struct cnode *ctree_RB_PREV (struct cnode *elm) {
    if ((elm)->entry.rbe_left) {
        elm = (elm)->entry.rbe_left;
        while ((elm)->entry.rbe_right)
            elm = (elm)->entry.rbe_right;
    } else {
        if ((elm)->entry.rbe_parent && (elm == ((elm)->entry.rbe_parent)->entry.rbe_right))
            elm = (elm)->entry.rbe_parent;
        else {
            while ((elm)->entry.rbe_parent && (elm == ((elm)->entry.rbe_parent)->entry.rbe_left))
                elm = (elm)->entry.rbe_parent;
            elm = (elm)->entry.rbe_parent;
        }
    }
    return elm;
}
struct cnode *ctree_RB_MINMAX (struct ctree *head, int val) {
    struct cnode *tmp = (head)->rbh_root;
    struct cnode *parent = ((void *) 0);
    while (tmp) {
        parent = tmp;
        if (val < 0)
            tmp = (tmp)->entry.rbe_left;
        else
            tmp = (tmp)->entry.rbe_right;
    }
    return parent;
};

static void color_example (void) {
    struct ctree head = { ((void *) 0) };
    struct cnode n, *np, *op;
    int i;

    puts ("color_example:");

    {
        char *keys[] = { "red", "green", "blue" };
        int values[] = { 0xff0000, 0x00ff00, 0x0000ff };

        for (i = 0; i < 3; i++) {
            if ((np = calloc (1, sizeof np[0])) == ((void *) 0))
                err (1, "calloc");
            np->key = keys[i];
            np->value = values[i];
            ctree_RB_INSERT (&head, np);
        }
    }

    {
        char *keys[] = { "blue", "green", "orange", "red" };

        for (i = 0; i < 4; i++) {
            n.key = keys[i];
            np = ctree_RB_FIND (&head, &n);

            if (np) {
                printf ("\t'%s' has value %06x\n", np->key, np->value);
            } else {
                printf ("\t'%s' is not in tree\n", n.key);
            }
        }
    }

    for (np = ctree_RB_MINMAX (&head, -1); np != ((void *) 0); np = op) {
        op = ctree_RB_NEXT (np);
        ctree_RB_REMOVE (&head, np);
        free (np);
    }
}

struct dnode {
    struct {
        struct dnode *rbe_left;
        struct dnode *rbe_right;
        struct dnode *rbe_parent;
        int rbe_color;
    } entry;
    double key;
    int v_type;

    union {
        double u_num;
        char *u_str;
    } v_union;

};

static int dnodecmp (struct dnode *a, struct dnode *b) {
    double aa = a->key;
    double bb = b->key;
    return (aa < bb) ? -1 : (aa > bb);
}

struct dtree {
    struct dnode *rbh_root;
};
void dtree_RB_INSERT_COLOR (struct dtree *, struct dnode *);
void dtree_RB_REMOVE_COLOR (struct dtree *, struct dnode *, struct dnode *);
struct dnode *dtree_RB_REMOVE (struct dtree *, struct dnode *);
struct dnode *dtree_RB_INSERT (struct dtree *, struct dnode *);
struct dnode *dtree_RB_FIND (struct dtree *, struct dnode *);
struct dnode *dtree_RB_NFIND (struct dtree *, struct dnode *);
struct dnode *dtree_RB_NEXT (struct dnode *);
struct dnode *dtree_RB_PREV (struct dnode *);
struct dnode *dtree_RB_MINMAX (struct dtree *, int);
void dtree_RB_INSERT_COLOR (struct dtree *head, struct dnode *elm) {
    struct dnode *parent, *gparent, *tmp;
    while ((parent = (elm)->entry.rbe_parent) != ((void *) 0) && (parent)->entry.rbe_color == 1) {
        gparent = (parent)->entry.rbe_parent;
        if (parent == (gparent)->entry.rbe_left) {
            tmp = (gparent)->entry.rbe_right;
            if (tmp && (tmp)->entry.rbe_color == 1) {
                (tmp)->entry.rbe_color = 0;
                do {
                    (parent)->entry.rbe_color = 0;
                    (gparent)->entry.rbe_color = 1;
                } while (0);
                elm = gparent;
                continue;
            }
            if ((parent)->entry.rbe_right == elm) {
                do {
                    (tmp) = (parent)->entry.rbe_right;
                    if (((parent)->entry.rbe_right = (tmp)->entry.rbe_left) != ((void *) 0)) {
                        ((tmp)->entry.rbe_left)->entry.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_left = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = parent;
                parent = elm;
                elm = tmp;
            }
            do {
                (parent)->entry.rbe_color = 0;
                (gparent)->entry.rbe_color = 1;
            } while (0);
            do {
                (tmp) = (gparent)->entry.rbe_left;
                if (((gparent)->entry.rbe_left = (tmp)->entry.rbe_right) != ((void *) 0))
                    ((tmp)->entry.rbe_right)->entry.rbe_parent = (gparent);
                do {
                } while (0);
                if (((tmp)->entry.rbe_parent = (gparent)->entry.rbe_parent) != ((void *) 0)) {
                    if ((gparent) == ((gparent)->entry.rbe_parent)->entry.rbe_left)
                        ((gparent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                    else
                        ((gparent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                } else
                    (head)->rbh_root = (tmp);
                (tmp)->entry.rbe_right = (gparent);
                (gparent)->entry.rbe_parent = (tmp);
                do {
                } while (0);
                if (((tmp)->entry.rbe_parent))
                    do {
                    } while (0);
            } while (0);
        } else {
            tmp = (gparent)->entry.rbe_left;
            if (tmp && (tmp)->entry.rbe_color == 1) {
                (tmp)->entry.rbe_color = 0;
                do {
                    (parent)->entry.rbe_color = 0;
                    (gparent)->entry.rbe_color = 1;
                } while (0);
                elm = gparent;
                continue;
            }
            if ((parent)->entry.rbe_left == elm) {
                do {
                    (tmp) = (parent)->entry.rbe_left;
                    if (((parent)->entry.rbe_left = (tmp)->entry.rbe_right) != ((void *) 0))
                        ((tmp)->entry.rbe_right)->entry.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_right = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = parent;
                parent = elm;
                elm = tmp;
            }
            do {
                (parent)->entry.rbe_color = 0;
                (gparent)->entry.rbe_color = 1;
            } while (0);
            do {
                (tmp) = (gparent)->entry.rbe_right;
                if (((gparent)->entry.rbe_right = (tmp)->entry.rbe_left) != ((void *) 0)) {
                    ((tmp)->entry.rbe_left)->entry.rbe_parent = (gparent);
                }
                do {
                } while (0);
                if (((tmp)->entry.rbe_parent = (gparent)->entry.rbe_parent) != ((void *) 0)) {
                    if ((gparent) == ((gparent)->entry.rbe_parent)->entry.rbe_left)
                        ((gparent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                    else
                        ((gparent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                } else
                    (head)->rbh_root = (tmp);
                (tmp)->entry.rbe_left = (gparent);
                (gparent)->entry.rbe_parent = (tmp);
                do {
                } while (0);
                if (((tmp)->entry.rbe_parent))
                    do {
                    } while (0);
            } while (0);
        }
    }
    (head->rbh_root)->entry.rbe_color = 0;
}
void dtree_RB_REMOVE_COLOR (struct dtree *head, struct dnode *parent, struct dnode *elm) {
    struct dnode *tmp;
    while ((elm == ((void *) 0) || (elm)->entry.rbe_color == 0) && elm != (head)->rbh_root) {
        if ((parent)->entry.rbe_left == elm) {
            tmp = (parent)->entry.rbe_right;
            if ((tmp)->entry.rbe_color == 1) {
                do {
                    (tmp)->entry.rbe_color = 0;
                    (parent)->entry.rbe_color = 1;
                } while (0);
                do {
                    (tmp) = (parent)->entry.rbe_right;
                    if (((parent)->entry.rbe_right = (tmp)->entry.rbe_left) != ((void *) 0)) {
                        ((tmp)->entry.rbe_left)->entry.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_left = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = (parent)->entry.rbe_right;
            }
            if (((tmp)->entry.rbe_left == ((void *) 0) || ((tmp)->entry.rbe_left)->entry.rbe_color == 0) && ((tmp)->entry.rbe_right == ((void *) 0) || ((tmp)->entry.rbe_right)->entry.rbe_color == 0)) {
                (tmp)->entry.rbe_color = 1;
                elm = parent;
                parent = (elm)->entry.rbe_parent;
            } else {
                if ((tmp)->entry.rbe_right == ((void *) 0) || ((tmp)->entry.rbe_right)->entry.rbe_color == 0) {
                    struct dnode *oleft;
                    if ((oleft = (tmp)->entry.rbe_left) != ((void *) 0))
                        (oleft)->entry.rbe_color = 0;
                    (tmp)->entry.rbe_color = 1;
                    do {
                        (oleft) = (tmp)->entry.rbe_left;
                        if (((tmp)->entry.rbe_left = (oleft)->entry.rbe_right) != ((void *) 0))
                            ((oleft)->entry.rbe_right)->entry.rbe_parent = (tmp);
                        do {
                        } while (0);
                        if (((oleft)->entry.rbe_parent = (tmp)->entry.rbe_parent) != ((void *) 0)) {
                            if ((tmp) == ((tmp)->entry.rbe_parent)->entry.rbe_left)
                                ((tmp)->entry.rbe_parent)->entry.rbe_left = (oleft);
                            else
                                ((tmp)->entry.rbe_parent)->entry.rbe_right = (oleft);
                        } else
                            (head)->rbh_root = (oleft);
                        (oleft)->entry.rbe_right = (tmp);
                        (tmp)->entry.rbe_parent = (oleft);
                        do {
                        } while (0);
                        if (((oleft)->entry.rbe_parent))
                            do {
                            } while (0);
                    } while (0);
                    tmp = (parent)->entry.rbe_right;
                }
                (tmp)->entry.rbe_color = (parent)->entry.rbe_color;
                (parent)->entry.rbe_color = 0;
                if ((tmp)->entry.rbe_right)
                    ((tmp)->entry.rbe_right)->entry.rbe_color = 0;
                do {
                    (tmp) = (parent)->entry.rbe_right;
                    if (((parent)->entry.rbe_right = (tmp)->entry.rbe_left) != ((void *) 0)) {
                        ((tmp)->entry.rbe_left)->entry.rbe_parent = (parent);
                    }
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_left = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                elm = (head)->rbh_root;
                break;
            }
        } else {
            tmp = (parent)->entry.rbe_left;
            if ((tmp)->entry.rbe_color == 1) {
                do {
                    (tmp)->entry.rbe_color = 0;
                    (parent)->entry.rbe_color = 1;
                } while (0);
                do {
                    (tmp) = (parent)->entry.rbe_left;
                    if (((parent)->entry.rbe_left = (tmp)->entry.rbe_right) != ((void *) 0))
                        ((tmp)->entry.rbe_right)->entry.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_right = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                tmp = (parent)->entry.rbe_left;
            }
            if (((tmp)->entry.rbe_left == ((void *) 0) || ((tmp)->entry.rbe_left)->entry.rbe_color == 0) && ((tmp)->entry.rbe_right == ((void *) 0) || ((tmp)->entry.rbe_right)->entry.rbe_color == 0)) {
                (tmp)->entry.rbe_color = 1;
                elm = parent;
                parent = (elm)->entry.rbe_parent;
            } else {
                if ((tmp)->entry.rbe_left == ((void *) 0) || ((tmp)->entry.rbe_left)->entry.rbe_color == 0) {
                    struct dnode *oright;
                    if ((oright = (tmp)->entry.rbe_right) != ((void *) 0))
                        (oright)->entry.rbe_color = 0;
                    (tmp)->entry.rbe_color = 1;
                    do {
                        (oright) = (tmp)->entry.rbe_right;
                        if (((tmp)->entry.rbe_right = (oright)->entry.rbe_left) != ((void *) 0)) {
                            ((oright)->entry.rbe_left)->entry.rbe_parent = (tmp);
                        }
                        do {
                        } while (0);
                        if (((oright)->entry.rbe_parent = (tmp)->entry.rbe_parent) != ((void *) 0)) {
                            if ((tmp) == ((tmp)->entry.rbe_parent)->entry.rbe_left)
                                ((tmp)->entry.rbe_parent)->entry.rbe_left = (oright);
                            else
                                ((tmp)->entry.rbe_parent)->entry.rbe_right = (oright);
                        } else
                            (head)->rbh_root = (oright);
                        (oright)->entry.rbe_left = (tmp);
                        (tmp)->entry.rbe_parent = (oright);
                        do {
                        } while (0);
                        if (((oright)->entry.rbe_parent))
                            do {
                            } while (0);
                    } while (0);
                    tmp = (parent)->entry.rbe_left;
                }
                (tmp)->entry.rbe_color = (parent)->entry.rbe_color;
                (parent)->entry.rbe_color = 0;
                if ((tmp)->entry.rbe_left)
                    ((tmp)->entry.rbe_left)->entry.rbe_color = 0;
                do {
                    (tmp) = (parent)->entry.rbe_left;
                    if (((parent)->entry.rbe_left = (tmp)->entry.rbe_right) != ((void *) 0))
                        ((tmp)->entry.rbe_right)->entry.rbe_parent = (parent);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent = (parent)->entry.rbe_parent) != ((void *) 0)) {
                        if ((parent) == ((parent)->entry.rbe_parent)->entry.rbe_left)
                            ((parent)->entry.rbe_parent)->entry.rbe_left = (tmp);
                        else
                            ((parent)->entry.rbe_parent)->entry.rbe_right = (tmp);
                    } else
                        (head)->rbh_root = (tmp);
                    (tmp)->entry.rbe_right = (parent);
                    (parent)->entry.rbe_parent = (tmp);
                    do {
                    } while (0);
                    if (((tmp)->entry.rbe_parent))
                        do {
                        } while (0);
                } while (0);
                elm = (head)->rbh_root;
                break;
            }
        }
    }
    if (elm)
        (elm)->entry.rbe_color = 0;
}
struct dnode *dtree_RB_REMOVE (struct dtree *head, struct dnode *elm) {
    struct dnode *child, *parent, *old = elm;
    int color;
    if ((elm)->entry.rbe_left == ((void *) 0))
        child = (elm)->entry.rbe_right;
    else if ((elm)->entry.rbe_right == ((void *) 0))
        child = (elm)->entry.rbe_left;
    else {
        struct dnode *left;
        elm = (elm)->entry.rbe_right;
        while ((left = (elm)->entry.rbe_left) != ((void *) 0))
            elm = left;
        child = (elm)->entry.rbe_right;
        parent = (elm)->entry.rbe_parent;
        color = (elm)->entry.rbe_color;
        if (child)
            (child)->entry.rbe_parent = parent;
        if (parent) {
            if ((parent)->entry.rbe_left == elm)
                (parent)->entry.rbe_left = child;
            else
                (parent)->entry.rbe_right = child;
            do {
            } while (0);
        } else
            (head)->rbh_root = child;
        if ((elm)->entry.rbe_parent == old)
            parent = elm;
        (elm)->entry = (old)->entry;
        if ((old)->entry.rbe_parent) {
            if (((old)->entry.rbe_parent)->entry.rbe_left == old)
                ((old)->entry.rbe_parent)->entry.rbe_left = elm;
            else
                ((old)->entry.rbe_parent)->entry.rbe_right = elm;
            do {
            } while (0);
        } else
            (head)->rbh_root = elm;
        ((old)->entry.rbe_left)->entry.rbe_parent = elm;
        if ((old)->entry.rbe_right)
            ((old)->entry.rbe_right)->entry.rbe_parent = elm;
        if (parent) {
            left = parent;
            do {
                do {
                } while (0);
            } while ((left = (left)->entry.rbe_parent) != ((void *) 0));
        }
        goto color;
    }
    parent = (elm)->entry.rbe_parent;
    color = (elm)->entry.rbe_color;
    if (child)
        (child)->entry.rbe_parent = parent;
    if (parent) {
        if ((parent)->entry.rbe_left == elm)
            (parent)->entry.rbe_left = child;
        else
            (parent)->entry.rbe_right = child;
        do {
        } while (0);
    } else
        (head)->rbh_root = child;
  color:if (color == 0)
        dtree_RB_REMOVE_COLOR (head, parent, child);
    return old;
}
struct dnode *dtree_RB_INSERT (struct dtree *head, struct dnode *elm) {
    struct dnode *tmp;
    struct dnode *parent = ((void *) 0);
    int comp = 0;
    tmp = (head)->rbh_root;
    while (tmp) {
        parent = tmp;
        comp = (dnodecmp) (elm, parent);
        if (comp < 0)
            tmp = (tmp)->entry.rbe_left;
        else if (comp > 0)
            tmp = (tmp)->entry.rbe_right;
        else
            return tmp;
    }
    do {
        (elm)->entry.rbe_parent = parent;
        (elm)->entry.rbe_left = (elm)->entry.rbe_right = ((void *) 0);
        (elm)->entry.rbe_color = 1;
    } while (0);
    if (parent != ((void *) 0)) {
        if (comp < 0)
            (parent)->entry.rbe_left = elm;
        else
            (parent)->entry.rbe_right = elm;
        do {
        } while (0);
    } else
        (head)->rbh_root = elm;
    dtree_RB_INSERT_COLOR (head, elm);
    return ((void *) 0);
} struct dnode *dtree_RB_FIND (struct dtree *head, struct dnode *elm) {

    struct dnode *tmp = (head)->rbh_root;
    int comp;
    while (tmp) {
        comp = dnodecmp (elm, tmp);
        if (comp < 0)
            tmp = (tmp)->entry.rbe_left;
        else if (comp > 0)
            tmp = (tmp)->entry.rbe_right;
        else
            return tmp;
    }
    return ((void *) 0);
} struct dnode *dtree_RB_NFIND (struct dtree *head, struct dnode *elm) {

    struct dnode *tmp = (head)->rbh_root;
    struct dnode *res = ((void *) 0);
    int comp;
    while (tmp) {
        comp = dnodecmp (elm, tmp);
        if (comp < 0) {
            res = tmp;
            tmp = (tmp)->entry.rbe_left;
        } else if (comp > 0)
            tmp = (tmp)->entry.rbe_right;
        else
            return tmp;
    }
    return res;
}
struct dnode *dtree_RB_NEXT (struct dnode *elm) {
    if ((elm)->entry.rbe_right) {
        elm = (elm)->entry.rbe_right;
        while ((elm)->entry.rbe_left)
            elm = (elm)->entry.rbe_left;
    } else {
        if ((elm)->entry.rbe_parent && (elm == ((elm)->entry.rbe_parent)->entry.rbe_left))
            elm = (elm)->entry.rbe_parent;
        else {
            while ((elm)->entry.rbe_parent && (elm == ((elm)->entry.rbe_parent)->entry.rbe_right))
                elm = (elm)->entry.rbe_parent;
            elm = (elm)->entry.rbe_parent;
        }
    }
    return elm;
}
struct dnode *dtree_RB_PREV (struct dnode *elm) {
    if ((elm)->entry.rbe_left) {
        elm = (elm)->entry.rbe_left;
        while ((elm)->entry.rbe_right)
            elm = (elm)->entry.rbe_right;
    } else {
        if ((elm)->entry.rbe_parent && (elm == ((elm)->entry.rbe_parent)->entry.rbe_right))
            elm = (elm)->entry.rbe_parent;
        else {
            while ((elm)->entry.rbe_parent && (elm == ((elm)->entry.rbe_parent)->entry.rbe_left))
                elm = (elm)->entry.rbe_parent;
            elm = (elm)->entry.rbe_parent;
        }
    }
    return elm;
}
struct dnode *dtree_RB_MINMAX (struct dtree *head, int val) {
    struct dnode *tmp = (head)->rbh_root;
    struct dnode *parent = ((void *) 0);
    while (tmp) {
        parent = tmp;
        if (val < 0)
            tmp = (tmp)->entry.rbe_left;
        else
            tmp = (tmp)->entry.rbe_right;
    }
    return parent;
}

static void number_example (void) {
    struct dtree head = { ((void *) 0) };
    struct dnode n, *np, *op;
    int i;

    puts ("number_example:");

    {
        double keys[] = { 2, 3, 4, 5.6 };
        double values[] = { 2.71828, 3.14159, 4.47214, 7.8 };

        for (i = 0; i < 4; i++) {
            if ((np = calloc (1, sizeof np[0])) == ((void *) 0))
                err (1, "calloc");
            np->key = keys[i];
            np->v_type = 0x1;
            np->v_union.u_num = values[i];
            dtree_RB_INSERT (&head, np);
        }
    }
# 133 "rbtree_color.c"
    {
        double keys[] = { 4, 8, 10 };
        char *values[] = { "four", "eight", "ten" };

        for (i = 0; i < 3; i++) {

            n.key = keys[i];
            if ((np = dtree_RB_FIND (&head, &n)) != ((void *) 0)) {
                np->v_type = 0x2;
                np->v_union.u_str = values[i];
            } else if ((np = calloc (1, sizeof np[0])) != ((void *) 0)) {
                np->key = keys[i];
                np->v_type = 0x2;
                np->v_union.u_str = values[i];
                dtree_RB_INSERT (&head, np);
            } else
                err (1, "calloc");
        }
    }

    n.key = 8;
    if ((np = dtree_RB_FIND (&head, &n)) != ((void *) 0))
        dtree_RB_REMOVE (&head, np);

    i = 1;
    for ((np) = dtree_RB_MINMAX (&head, -1); (np) != ((void *) 0); (np) = dtree_RB_NEXT (np)) {
        if (i) {
            printf ("\tall keys: %g", np->key);
            i = 0;
        } else
            printf (", %g", np->key);
    }
    if (i)
        puts ("\tno keys!");
    else
        puts ("");

    {
        double keys[] = { 2, 3, 4, 5.6, 7, 8, 10 };

        for (i = 0; i < 7; i++) {
            n.key = keys[i];
            np = dtree_RB_FIND (&head, &n);

            if (np == ((void *) 0)) {
                printf ("\t%g is not in the tree\n", keys[i]);
            } else if (np->v_type & 0x1) {
                printf ("\t%g has value %g\n", keys[i], np->v_union.u_num);
            } else if (np->v_type & 0x2) {
                printf ("\t%g has value '%s'\n", keys[i], np->v_union.u_str);
            } else {
                printf ("\t%g has invalid value\n", keys[i]);
            }
        }
    }

    for (np = dtree_RB_MINMAX (&head, -1); np != ((void *) 0); np = op) {
        op = dtree_RB_NEXT (np);
        dtree_RB_REMOVE (&head, np);
        free (np);
    }
}

int main (void) {
    color_example ();
    number_example ();
    return 0;
}
