
#define _GNU_SOURCE
#include <assert.h>
#include <dirent.h>
#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>

#include "zunkfs.h"
#include "zunkfs-tests.h"
#include "dir.h"
#include "chunk-db.h"

static const char spaces[] = "                                                                                                                                                               ";
#define indent_start (spaces + sizeof(spaces) - 1)

static void test1 (void);
static void test2 (void);
static void test3 (void);
static void test4 (void);

int main (int argc, char **argv) {
    struct disk_dentry root_ddent;
    struct timeval now;
    DECLARE_MUTEX (root_mutex);
    char *errstr;
    int err;

    fprintf (stderr, "DIRENTS_PER_CHUNK=%lu\n", (unsigned long) DIRENTS_PER_CHUNK);

    err = set_logging ("T,stdout");
    if (err)
        panic ("set_logging: %s\n", strerror (-err));

    errstr = add_chunkdb ("rw,mem:");
    if (errstr)
        panic ("add_chunkdb: %s\n", STR_OR_ERROR (errstr));

    err = init_disk_dentry (&root_ddent);
    if (err < 0)
        panic ("init_disk_dentry: %s\n", strerror (-err));

    namcpy (root_ddent.name, "/");

    gettimeofday (&now, NULL);

    root_ddent.mode = htole16 (S_IFDIR | S_IRWXU);
    root_ddent.size = htole64 (0);
    root_ddent.ctime = htole32 (now.tv_sec);
    root_ddent.mtime = htole32 (now.tv_sec);

    err = set_root (&root_ddent, &root_mutex);
    if (err)
        panic ("set_root: %s\n", strerror (-err));

    if (0)
        test1 ();
    if (0)
        test2 ();
    if (0)
        test3 ();
    if (1)
        test4 ();

    return 0;
}

char *d_path (const char *prefix, const struct dentry *dentry) {
    char *npath = NULL;
    char *path;
    int err;

    if (!dentry->parent) {
        path = strdup ("/");
        assert (path != NULL);
        return path;
    }

    err = asprintf (&path, "/%s", dentry->ddent->name);
    assert (err != -1);

    while ((dentry = dentry->parent)) {
        if (!dentry->parent)
            break;
        err = asprintf (&npath, "/%s%s", dentry->ddent->name, path);
        assert (err != -1);
        free (path);
        path = npath;
    }

    if (prefix) {
        err = asprintf (&npath, "%s%s", prefix, path);
        assert (err != -1);
        free (path);
        path = npath;
    }

    return path;
}

static struct dentry *locked_add_dentry (struct dentry *parent, const char *name, mode_t mode) {
    struct dentry *dentry;

    lock (&parent->mutex);
    dentry = add_dentry (parent, name, mode);
    unlock (&parent->mutex);

    return dentry;
}

static void test1 (void) {
    struct dentry *root;
    struct dentry *foo;
    struct dentry *bar;
    int err;

    root = find_dentry ("/", NULL);
    if (IS_ERR (root))
        panic ("find_dentry(/): %s\n", strerror (PTR_ERR (root)));

    printf ("after getting root:\n");
    dump_dentry (root, indent_start);

    foo = locked_add_dentry (root, "foo", S_IFREG | S_IRWXU);
    if (IS_ERR (foo))
        panic ("add_dentry(foo): %s\n", strerror (PTR_ERR (foo)));

    printf ("after adding foo:\n");
    dump_dentry (root, indent_start);

    bar = locked_add_dentry (root, "bar", S_IFREG | S_IRWXU);
    if (IS_ERR (bar))
        panic ("del_dentry(bar): %s\n", strerror (PTR_ERR (bar)));

    printf ("after adding bar:\n");
    dump_dentry (root, indent_start);

    err = del_dentry (bar);
    if (err)
        panic ("del(bar): %s\n", strerror (-err));

    put_dentry (bar);
    printf ("\nafter del(bar):\n");
    dump_dentry (root, indent_start);

    put_dentry (foo);
    printf ("\nafter putting foo:\n");
    dump_dentry (root, indent_start);

    put_dentry (bar);
    put_dentry (foo);
    put_dentry (root);
}

/*
 * Create a directory hierarchy, based on /lib
 */
static void test2 (void) {
    struct dentry *root;
    struct dentry *curr;
    struct dentry *new;
    DIR *dir;
    struct dirent *de;
    int n = 0;
    unsigned max_height = 0;
    unsigned max_leafs = 0;

    struct dlist {
        struct dentry *dentry;
        struct dlist *next;
    } *dlist = NULL, **dtail = &dlist, *d;

    root = find_dentry ("/", NULL);
    if (IS_ERR (root))
        panic ("find_dentry(/): %s\n", strerror (PTR_ERR (root)));

    dir = opendir ("/usr/lib");
    if (!dir)
        panic ("opendir(/usr/lib'): %s\n", strerror (errno));

    curr = root;
  again:
    while ((de = readdir (dir))) {
        if (!strcmp (de->d_name, ".") || !strcmp (de->d_name, ".."))
            continue;
        if (de->d_type == DT_DIR) {
            new = locked_add_dentry (curr, de->d_name, S_IRWXU | S_IFDIR);
            if (IS_ERR (new)) {
                panic ("dir::add_dentry(%s/%s): %s\n", curr->ddent->name, de->d_name, strerror (PTR_ERR (new)));
            }
            d = malloc (sizeof (struct dlist));
            assert (d != NULL);
            d->dentry = new;
            d->next = NULL;
            *dtail = d;
            dtail = &d->next;
            n++;
        } else if (de->d_type == DT_REG) {
            new = locked_add_dentry (curr, de->d_name, S_IRWXU | S_IFREG);
            if (IS_ERR (new)) {
                panic ("reg::add_dentry(%s/%s): %s\n", curr->ddent->name, de->d_name, strerror (PTR_ERR (new)));
            }
            put_dentry (new);
            n++;
        }
    }
    if (curr->chunk_tree.root) {
        if (curr->chunk_tree.height > max_height)
            max_height = curr->chunk_tree.height;
        if (curr->chunk_tree.nr_leafs > max_leafs)
            max_leafs = curr->chunk_tree.nr_leafs;
    }
    //put_dentry(curr);
    closedir (dir);

    if (dlist) {
        char *path;
        d = dlist;
        dlist = d->next;
        curr = d->dentry;
        free (d);
        path = d_path ("/usr/lib", curr);
        dir = opendir (path);
        if (!dir)
            panic ("opendir(2, %s): %s\n", path, strerror (errno));
        //printf("\r%s                                        ", path);
        free (path);

        if (!dlist)
            dtail = &dlist;

        goto again;
    }
    printf ("\n");

    //dump_dentry_2(root, indent_start);
    printf ("max_height=%u\n", max_height);
    printf ("max_leafs=%u\n", max_leafs);
}

static void test3 (void) {
    struct dentry *root;
    struct dentry *foo;
    struct dentry *bar;
    int err;

    root = find_dentry ("/", NULL);
    if (IS_ERR (root))
        panic ("find_dentry(/): %s\n", strerror (PTR_ERR (root)));

    printf ("Testing rename in the same directory.\n");

    foo = locked_add_dentry (root, "foo", S_IFREG | S_IRWXU);
    if (IS_ERR (foo))
        panic ("add_dentry(foo): %s\n", strerror (PTR_ERR (foo)));

    err = rename_dentry (foo, "fu", root);
    if (err)
        panic ("rename_dentry(/foo, /fu): %s\n", strerror (-err));

    printf ("After rename_dentry(/foo, /fu):\n");
    dump_dentry (root, indent_start);

    printf ("\nTesting rename in different directories:\n");
    bar = locked_add_dentry (root, "bar", S_IFDIR | S_IRWXU);
    if (IS_ERR (bar))
        panic ("add_dentry(bar): %s\n", strerror (PTR_ERR (bar)));

    err = rename_dentry (foo, "foo", bar);
    if (err)
        panic ("rename_dentry(/fu, /bar/fu): %s\n", strerror (-err));

    printf ("After rename_dentry(/fu, /bar/foo):\n");
    dump_dentry (root, indent_start);

    assert (foo->parent == bar);

    err = rename_dentry (foo, "foo", root);
    if (err)
        panic ("rename_dentry(/bar/foo, /foo): %s\n", strerror (-err));

    assert (foo->parent == root);

    printf ("After rename_dentry(/bar/foo, /foo):\n");
    dump_dentry (root, indent_start);

    printf ("Before del(foo) root->size=%" PRIu64 " bar->size=%" PRIu64 "\n", root->size, bar->size);

    err = del_dentry (foo);
    if (err)
        panic ("del_dentry(/bar/foo): %s\n", strerror (-err));
    put_dentry (foo);

    printf ("After del(foo) root->size=%" PRIu64 " bar->size=%" PRIu64 "\n", root->size, bar->size);

    err = del_dentry (bar);
    if (err)
        panic ("del_dentry(/bar): %s\n", strerror (-err));
    put_dentry (bar);

    put_dentry (root);
}

static void test4 (void) {
    struct dentry *root;
    struct dentry *foo;
    struct dentry *bar;

    root = find_dentry ("/", NULL);
    if (IS_ERR (root))
        panic ("find_dentry(/): %s\n", strerror (PTR_ERR (root)));

    foo = locked_add_dentry (root, "foo", S_IFREG | S_IRWXU);
    if (IS_ERR (foo))
        panic ("add_dentry(foo): %s\n", strerror (PTR_ERR (foo)));

    bar = locked_add_dentry (root, "bar", S_IFDIR | S_IRWXU);
    if (IS_ERR (bar))
        panic ("add_dentry(bar): %s\n", strerror (PTR_ERR (bar)));

    put_dentry (foo);
    put_dentry (bar);
    put_dentry (root);

    foo = find_dentry ("/foo", NULL);
    if (IS_ERR (foo))
        panic ("find_dentry(/foo): %s\n", strerror (PTR_ERR (foo)));

    printf ("foo mode: 0%o (expected 0%o)\n", foo->mode, S_IFREG | S_IRWXU);

    dentry_chmod (foo, S_IRUSR | S_IXUSR);

    printf ("foo mode: 0%o (expected 0%o)\n", foo->mode, S_IFREG | S_IRUSR | S_IXUSR);

    put_dentry (foo);

    bar = find_dentry ("/bar", NULL);
    if (IS_ERR (bar))
        panic ("find_dentry(/bar): %s\n", strerror (PTR_ERR (bar)));

    printf ("bar mode: 0%o (expected 0%o)\n", bar->mode, S_IFDIR | S_IRWXU);

    dentry_chmod (bar, S_IRUSR | S_IXUSR);

    printf ("bar mode: 0%o (expected 0%o)\n", bar->mode, S_IFDIR | S_IRUSR | S_IXUSR);

    put_dentry (bar);
}
