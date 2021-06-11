
struct chunk_node;
struct chunk_tree;
struct dentry;

void dump_digest (const unsigned char *digest);
void dump_cnode (struct chunk_node *cnode, const char *indent, int height, void (*dump_leaf) (void **, const char *));
void dump_ctree (struct chunk_tree *ctree, const char *indent, void (*dump_leaf) (void **child, const char *indent));
void dump_dentry (struct dentry *dentry, const char *indent);
void dump_dentry_2 (struct dentry *dentry, const char *indent);
