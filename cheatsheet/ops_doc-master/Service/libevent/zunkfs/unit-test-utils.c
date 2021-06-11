
#define _GNU_SOURCE
#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include <sys/stat.h>

#include "zunkfs.h"
#include "zunkfs-tests.h"
#include "chunk-tree.h"
#include "dir.h"

#define cnode_array(cnode) \
	((struct chunk_node **)(cnode)->_private)
#define dentry_array(cnode) \
	((struct dentry **)(cnode)->_private)

void dump_cnode (struct chunk_node *cnode, const char *indent, int height, void (*dump_leaf) (void **, const char *)) {
    int i;

    if (!cnode)
        return;

    printf ("%s%p:%p: %s", indent, cnode, cnode->chunk_digest, digest_string (cnode->chunk_digest));
    if (is_cnode_dirty (cnode))
        printf (" [dirty]");
    else if (!verify_chunk (cnode->chunk_data, cnode->chunk_digest))
        printf (" [ERR]");
    printf (" [%s] refcount=%d %p\n", height ? "internal" : "leaf", cnode->ref_count, cnode->_private);

    if (!height) {
        if (dump_leaf && cnode->_private)
            dump_leaf (cnode->_private, indent);
    } else {
        for (i = 0; i < DIGESTS_PER_CHUNK; i++) {
            dump_cnode (cnode_array (cnode)[i], indent - 1, height - 1, dump_leaf);
        }
    }
}

void dump_ctree (struct chunk_tree *ctree, const char *indent, void (*dump_leaf) (void **child, const char *indent)) {
    printf ("%sCTREE %p nr_leafs=%d height=%d\n", indent, ctree, ctree->nr_leafs, ctree->height);
    if (ctree->root)
        dump_cnode (ctree->root, indent - 1, ctree->height, dump_leaf);
}

void dump_dentries (void **list, const char *indent) {
    int i;
    for (i = 0; i < DIRENTS_PER_CHUNK; i++)
        dump_dentry (list[i], indent);
}

void dump_dentry (struct dentry *dentry, const char *indent) {
    if (!dentry)
        return;

    printf ("%s%p:%p:%p:%p %s ref_count=%d\n", indent, dentry, dentry->ddent, dentry->ddent_cnode, dentry->parent, dentry->ddent->name, dentry->ref_count);
    dump_ctree (&dentry->chunk_tree, indent, dump_dentries);
}

void dump_dentry_2 (struct dentry *dentry, const char *indent);

static int dump_child (struct dentry *child, void *data) {
    const char *indent = data;
    dump_dentry_2 (child, indent);
    return 0;
}

void dump_dentry_2 (struct dentry *dentry, const char *indent) {
    int err;

    if (!dentry)
        return;

    printf ("%s%p:%p:%p:%p %s ref_count=%u size=%ld type=%s\n",
            indent, dentry, dentry->ddent,
            dentry->ddent_cnode, dentry->parent, dentry->ddent->name, dentry->ref_count, (long) dentry->size, S_ISDIR (dentry->mode) ? "dir" : S_ISREG (dentry->mode) ? "reg" : "???");

    if (!S_ISDIR (dentry->mode))
        return;

    err = scan_dir (dentry, dump_child, (void *) (indent - 1));
    if (err) {
        fprintf (stderr, "PANIC: scan_dir(%p): %s\n", dentry, strerror (-err));
        dump_ctree (&dentry->chunk_tree, indent, dump_dentries);
        fflush (stdout);
        abort ();
    }
}
