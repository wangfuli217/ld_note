
#define _GNU_SOURCE

#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <pthread.h>

#include "zunkfs.h"
#include "chunk-tree.h"
#include "utils.h"

#define children_of(cnode) \
	((struct chunk_node **)(cnode)->_private)

static struct chunk_node *new_chunk_node (struct chunk_tree *ctree, unsigned char *chunk_digest, int leaf) {
    struct chunk_node *cnode;
    int err;

    assert (chunk_digest != NULL);

    cnode = malloc (sizeof (struct chunk_node));
    if (!cnode)
        return ERR_PTR (ENOMEM);

    err = -ENOMEM;
    cnode->_private = NULL;
    if (!leaf) {
        cnode->_private = calloc (DIGESTS_PER_CHUNK, sizeof (void *));
        if (!cnode->_private)
            goto error;
    }

    cnode->ctree = ctree;
    cnode->chunk_digest = chunk_digest;
    cnode->parent = NULL;
    list_head_init (&cnode->dirty_entry);
    cnode->ref_count = 0;

    return cnode;
  error:
    free (cnode);
    return ERR_PTR (-err);
}

static void __put_chunk_node (struct chunk_node *node, int leaf);

static int grow_chunk_tree (struct chunk_tree *ctree) {
    struct chunk_node *new_root;
    struct chunk_node *old_root;

    old_root = ctree->root;

    new_root = new_chunk_node (ctree, old_root->chunk_digest, 0);
    if (IS_ERR (new_root))
        return -PTR_ERR (new_root);

    memset (new_root->chunk_data, 0, CHUNK_SIZE);

    old_root->parent = new_root;
    old_root->chunk_digest = new_root->chunk_data;
    memcpy (old_root->chunk_digest, new_root->chunk_digest, CHUNK_DIGEST_LEN);

    mark_cnode_dirty (new_root);
    new_root->ref_count = 2;    /* old_root & ctree */
    children_of (new_root)[0] = old_root;

    ctree->height++;
    ctree->root = new_root;

    __put_chunk_node (old_root, ctree->height == 1);

    return 0;
}

struct chunk_node *get_nth_chunk (struct chunk_tree *ctree, unsigned chunk_nr) {
    struct chunk_node *parent;
    struct chunk_node *cnode;
    unsigned *path = NULL;
    unsigned *max_path = NULL;
    unsigned nr;
    unsigned char *digest;
    int i, err;

    if (chunk_nr > ctree->nr_leafs)
        return ERR_PTR (EINVAL);

  again:
    path = alloca (sizeof (unsigned *) * ctree->height);
    assert (path != NULL);

    nr = chunk_nr;
    for (i = 0; i < ctree->height; i++) {
        path[i] = nr % DIGESTS_PER_CHUNK;
        nr /= DIGESTS_PER_CHUNK;
    }

    if (nr) {
        err = grow_chunk_tree (ctree);
        if (err)
            return ERR_PTR (-err);
        goto again;
    }

    if (chunk_nr == ctree->nr_leafs) {
        max_path = alloca (sizeof (unsigned *) * ctree->height);
        assert (max_path != NULL);

        nr = ctree->nr_leafs - 1;
        for (i = 0; i < ctree->height; i++) {
            max_path[i] = nr % DIGESTS_PER_CHUNK;
            nr /= DIGESTS_PER_CHUNK;
        }
        ctree->nr_leafs++;
    }

    cnode = ctree->root;
    i = ctree->height;
    while (i--) {
        parent = cnode;

        cnode = children_of (parent)[path[i]];
        if (cnode)
            continue;

        digest = parent->chunk_data + path[i] * CHUNK_DIGEST_LEN;

        cnode = new_chunk_node (ctree, digest, !i);
        if (IS_ERR (cnode))
            return cnode;

        if (max_path && max_path[i] != path[i]) {
            memset (cnode->chunk_data, 0, CHUNK_SIZE);
            mark_cnode_dirty (cnode);
        } else {
            err = ctree->ops->read_chunk (cnode->chunk_data, cnode->chunk_digest);
            if (err < 0) {
                free (cnode);
                return ERR_PTR (-err);
            }
        }

        cnode->parent = parent;
        children_of (parent)[path[i]] = cnode;
        parent->ref_count++;
    }

    cnode->ref_count++;
    return cnode;
}

static inline unsigned __chunk_nr (const struct chunk_node *cnode) {
    const struct chunk_node *parent = cnode->parent;
    unsigned nr;
    assert (parent != NULL);
    nr = (cnode->chunk_digest - parent->chunk_data) / CHUNK_DIGEST_LEN;
    assert (nr < DIGESTS_PER_CHUNK);
    return nr;
}

unsigned chunk_nr (const struct chunk_node *cnode) {
    if (cnode == cnode->ctree->root)
        return 0;

    return DIGESTS_PER_CHUNK * chunk_nr (cnode->parent) + __chunk_nr (cnode);
}

static int flush_chunk_node (struct chunk_node *cnode) {
    int err;

    if (is_cnode_dirty (cnode)) {
        err = cnode->ctree->ops->write_chunk (cnode->chunk_data, cnode->chunk_digest);
        if (err < 0)
            return err;
        if (cnode->parent)
            mark_cnode_dirty (cnode->parent);
        list_del_init (&cnode->dirty_entry);
    }

    return 0;
}

static void __put_chunk_node (struct chunk_node *cnode, int leaf) {
    struct chunk_tree *ctree = cnode->ctree;
    struct chunk_node *parent;
    int err;

    for (;;) {
        if (--cnode->ref_count)
            break;

        err = flush_chunk_node (cnode);
        if (err < 0) {
            WARNING ("flush_chunk_node(%p): %s\n", cnode, strerror (-err));
        }

        if (cnode->_private) {
            if (leaf)
                ctree->ops->free_private (cnode->_private);
            else
                free (cnode->_private);
        }

        parent = cnode->parent;
        assert (parent != NULL);

        children_of (parent)[__chunk_nr (cnode)] = NULL;
        free (cnode);

        cnode = parent;
        leaf = 0;
    }
}

void put_chunk_node (struct chunk_node *cnode) {
    __put_chunk_node (cnode, 1);
}

int init_chunk_tree (struct chunk_tree *ctree, unsigned nr_leafs, unsigned char *root_digest, struct chunk_tree_operations *ops) {
    struct chunk_node *root;
    int err;

    if (!root_digest)
        return -EINVAL;

    list_head_init (&ctree->dirty_list);

    ctree->ops = ops;
    ctree->nr_leafs = nr_leafs;
    ctree->height = 0;

    nr_leafs -= !!nr_leafs;

    /* fls(x) ~= log2(x) + 1 */
    ctree->height = (fls (nr_leafs) - 1) / (fls (DIGESTS_PER_CHUNK) - 1);
    ctree->height += !!nr_leafs;

    root = new_chunk_node (ctree, root_digest, !ctree->height);
    if (IS_ERR (root))
        return -PTR_ERR (root);

    err = ctree->ops->read_chunk (root->chunk_data, root_digest);
    if (err < 0) {
        free (root);
        return err;
    }

    root->ref_count++;
    ctree->root = root;

    return 0;
}

void free_chunk_tree (struct chunk_tree *ctree) {
    struct chunk_node *croot = ctree->root;

    assert (croot->ref_count == 1);
    if (is_cnode_dirty (croot))
        flush_chunk_node (croot);
    if (croot->_private)
        free (croot->_private);
    free (croot);
}

int flush_chunk_tree (struct chunk_tree *ctree) {
    struct chunk_node *cnode;
    int error;

    while (!list_empty (&ctree->dirty_list)) {
        cnode = container_of (ctree->dirty_list.next, struct chunk_node, dirty_entry);
        error = flush_chunk_node (cnode);
        if (error)
            return error;
    }

    return 0;
}
