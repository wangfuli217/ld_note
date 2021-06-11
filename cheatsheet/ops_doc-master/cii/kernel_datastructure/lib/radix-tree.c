/*
 * Copyright (C) 2001 Momchil Velikov
 * Portions Copyright (C) 2001 Christoph Hellwig
 * Copyright (C) 2005 SGI, Christoph Lameter
 * Copyright (C) 2006 Nick Piggin
 * Copyright (C) 2012 Konstantin Khlebnikov
 * Copyright (C) 2016 Intel, Matthew Wilcox
 * Copyright (C) 2016 Intel, Ross Zwisler
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include "radix-tree.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
/*
 * The radix tree is variable-height, so an insert operation not only has
 * to build the branch to its corresponding item, it also has to build the
 * branch to existing items if the size has to be increased (by
 * radix_tree_extend).
 *
 * The worst case is a zero height tree with just a single item at index 0,
 * and then inserting an item at index ULONG_MAX. This requires 2 new branches
 * of RADIX_TREE_MAX_PATH size to be created, with only the root node shared.
 * Hence:
 */

static inline struct radix_tree_node *entry_to_node(void *ptr)
{
	return (void *)((unsigned long)ptr & ~RADIX_TREE_INTERNAL_NODE);
}

static inline void *node_to_entry(void *ptr)
{
	return (void *)((unsigned long)ptr | RADIX_TREE_INTERNAL_NODE);
}

#define RADIX_TREE_RETRY	node_to_entry(NULL)

#ifdef CONFIG_RADIX_TREE_MULTIORDER
/* Sibling slots point directly to another slot in the same node */
static inline bool is_sibling_entry(const struct radix_tree_node *parent, void *node)
{
	void  **ptr = node;
	return (parent->slots <= ptr) &&
			(ptr < parent->slots + RADIX_TREE_MAP_SIZE);
}
#else
static inline bool is_sibling_entry(const struct radix_tree_node *parent, void *node)
{
	return false;
}
#endif

static inline unsigned long get_slot_offset(const struct radix_tree_node *parent, void **slot)
{
	return slot - parent->slots;
}

static unsigned int radix_tree_descend(const struct radix_tree_node *parent,
			struct radix_tree_node **nodep, unsigned long index)
{
	unsigned int offset = (index >> parent->shift) & RADIX_TREE_MAP_MASK;
	void  **entry = parent->slots[offset];

#ifdef CONFIG_RADIX_TREE_MULTIORDER
	if (radix_tree_is_internal_node(entry)) {
		if (is_sibling_entry(parent, entry)) {
			void  **sibentry;
			sibentry = (void **) entry_to_node(entry);
			offset = get_slot_offset(parent, sibentry);
			entry = *sibentry;
		}
	}
#endif

	*nodep = (void *)entry;
	return offset;
}


static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
		int offset)
{
	set_bit(offset, node->tags[tag]);
}

static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
		int offset)
{
	clear_bit(offset, node->tags[tag]);
}

static inline int tag_get(const struct radix_tree_node *node, unsigned int tag,
		int offset)
{
	return test_bit(offset, node->tags[tag]);
}

static inline void root_tag_set(struct radix_tree_root *root, unsigned tag)
{
	root->tag_mask |= 1UL << (tag);
}

static inline void root_tag_clear(struct radix_tree_root *root, unsigned tag)
{
	root->tag_mask &= ~(1UL << (tag));
}

static inline void root_tag_clear_all(struct radix_tree_root *root)
{
	root->tag_mask = 0;
}

static inline int root_tag_get(const struct radix_tree_root *root, unsigned tag)
{
	return (int)root->tag_mask & (1UL << (tag));
}


/*
 * Returns 1 if any slot in the node has this tag set.
 * Otherwise returns 0.
 */
static inline int any_tag_set(const struct radix_tree_node *node,
							unsigned int tag)
{
	unsigned idx;
	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
		if (node->tags[tag][idx])
			return 1;
	}
	return 0;
}

/**
 * radix_tree_find_next_bit - find the next set bit in a memory region
 *
 * @addr: The address to base the search on
 * @size: The bitmap size in bits
 * @offset: The bitnumber to start searching at
 *
 * Unrollable variant of find_next_bit() for constant size arrays.
 * Tail bits starting from size to roundup(size, BITS_PER_LONG) must be zero.
 * Returns next bit offset, or size if nothing found.
 */
static inline unsigned long
radix_tree_find_next_bit(struct radix_tree_node *node, unsigned int tag,
			 unsigned long offset)
{
	const unsigned long *addr = node->tags[tag];

	if (offset < RADIX_TREE_MAP_SIZE) {
		unsigned long tmp;

		addr += offset / BITS_PER_LONG;
		tmp = *addr >> (offset % BITS_PER_LONG);
		if (tmp)
			return radix_tree_ffs(tmp) + offset;
		offset = (offset + BITS_PER_LONG) & ~(BITS_PER_LONG - 1);
		while (offset < RADIX_TREE_MAP_SIZE) {
			tmp = *++addr;
			if (tmp)
				return radix_tree_ffs(tmp) + offset;
			offset += BITS_PER_LONG;
		}
	}
	return RADIX_TREE_MAP_SIZE;
}

static unsigned int iter_offset(const struct radix_tree_iter *iter)
{
	return (iter->index >> iter_shift(iter)) & RADIX_TREE_MAP_MASK;
}

/*
 * The maximum index which can be stored in a radix tree
 */
static inline unsigned long shift_maxindex(unsigned int shift)
{
	return (RADIX_TREE_MAP_SIZE << shift) - 1;
}

static inline unsigned long node_maxindex(const struct radix_tree_node *node)
{
	return shift_maxindex(node->shift);
}

#ifdef  DEBUG
static void dump_node(struct radix_tree_node *node, unsigned long index)
{
	unsigned long i;

	printf("radix node: %p offset %d indices %lu-%lu parent %p tags %lx %lx %lx shift %d count %d exceptional %d\n",
		node, node->offset, index, index | node_maxindex(node),
		node->parent,
		node->tags[0][0], node->tags[1][0], node->tags[2][0],
		node->shift, node->count, node->exceptional);

	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
		unsigned long first = index | (i << node->shift);
		unsigned long last = first | ((1UL << node->shift) - 1);
		void *entry = node->slots[i];
		if (!entry)
			continue;
		if (entry == RADIX_TREE_RETRY) {
			printf("radix retry offset %ld indices %lu-%lu parent %p\n",
					i, first, last, node);
		} else if (!radix_tree_is_internal_node(entry)) {
			printf("radix entry %p offset %ld indices %lu-%lu parent %p\n",
					entry, i, first, last, node);
		} else if (is_sibling_entry(node, entry)) {
			printf("radix sblng %p offset %ld indices %lu-%lu parent %p val %p\n",
					entry, i, first, last, node,
					*(void **)entry_to_node(entry));
		} else {
			dump_node(entry_to_node(entry), first);
		}
	}
}

/* For debug */
void radix_tree_dump(struct radix_tree_root *root)
{
	printf("radix root: %p rnode %p tags %lx\n",
			root, root->rnode,
			root->tag_mask);
	if (!radix_tree_is_internal_node(root->rnode))
		return;
	dump_node(entry_to_node(root->rnode), 0);
}

#endif

/*
 * This assumes that the caller has performed appropriate preallocation, and
 * that the caller has pinned this thread of control to the current CPU.
 */
static struct radix_tree_node *radix_tree_node_alloc(struct radix_tree_node *parent,
			struct radix_tree_root *root, unsigned int shift, 
			unsigned int offset, unsigned int count, unsigned int exceptional)
{
	struct radix_tree_node *ret = NULL;

	ret = malloc(sizeof(struct radix_tree_node));
	if (ret) {
		memset(ret, 0, sizeof(struct radix_tree_node));
		ret->shift = shift;
		ret->offset = offset;
		ret->count = count;
		ret->exceptional = exceptional;
		ret->parent = parent;
		ret->root = root;
	}
	return ret;
}

static inline void radix_tree_node_free(struct radix_tree_node *node)
{
	memset(node->slots, 0, sizeof(node->slots));
	memset(node->tags, 0, sizeof(node->tags));
	INIT_LIST_HEAD(&node->private_list);
	free(node);
}

static unsigned radix_tree_load_root(const struct radix_tree_root *root,
		struct radix_tree_node **nodep, unsigned long *maxindex)
{
	struct radix_tree_node *node = root->rnode;

	*nodep = node;
	if (radix_tree_is_internal_node(node)) {
		node = entry_to_node(node);
		*maxindex = node_maxindex(node);
		return node->shift + RADIX_TREE_MAP_SHIFT;
	}

	*maxindex = 0;
	return 0;
}

/*
 *	Extend a radix tree so it can store key @index.
 */
static int radix_tree_extend(struct radix_tree_root *root,
				unsigned long index, unsigned int shift)
{
	void *entry;
	unsigned int maxshift;
	int tag;

	/* Figure out what the shift should be.  */
	maxshift = shift;
	while (index > shift_maxindex(maxshift))
		maxshift += RADIX_TREE_MAP_SHIFT;

	entry = root->rnode;
	if (!entry)
		goto out;

	do {
		struct radix_tree_node *node = radix_tree_node_alloc(NULL,
							root, shift, 0, 1, 0);
		if (!node)
			//return -ENOMEM;
			return -1;

		/* Propagate the aggregated tag info to the new child */
		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
			if (root_tag_get(root, tag))
				tag_set(node, tag, 0);
		}
		//TODO:
		if(shift > BITS_PER_LONG){
			printf("shit overflow\n");
			return -1;
		}

		if (radix_tree_is_internal_node(entry)) {
			entry_to_node(entry)->parent = node;
		} else if (radix_tree_exceptional_entry(entry)) {
			/* Moving an exceptional root->rnode to a node */
			node->exceptional = 1;
		}
		/*
		 * entry was already in the radix tree, so we do not need
		 */
		node->slots[0] = entry;
		entry = node_to_entry(node);
		root->rnode = entry;
		shift += RADIX_TREE_MAP_SHIFT;
	} while (shift <= maxshift);
out:
	return maxshift + RADIX_TREE_MAP_SHIFT;
}

/**
 *	radix_tree_shrink    -    shrink radix tree to minimum height
 *	@root		radix tree root
 */
static inline bool radix_tree_shrink(struct radix_tree_root *root,
				     radix_tree_update_node_t update_node)
{
	bool shrunk = false;

	for (;;) {
		struct radix_tree_node *node = root->rnode;
		struct radix_tree_node *child;

		if (!radix_tree_is_internal_node(node))
			break;
		node = entry_to_node(node);

		/*
		 * The candidate node has more than one child, or its child
		 * is not at the leftmost slot, or the child is a multiorder
		 * entry, we cannot shrink.
		 */
		if (node->count != 1)
			break;
		child = node->slots[0];
		if (!child)
			break;
		if (!radix_tree_is_internal_node(child) && node->shift)
			break;

		if (radix_tree_is_internal_node(child))
			entry_to_node(child)->parent = NULL;

		/*
		 * We don't need rcu_assign_pointer(), since we are simply
		 * moving the node from one part of the tree to another: if it
		 * was safe to dereference the old pointer to it
		 * (node->slots[0]), it will be safe to dereference the new
		 * one (root->rnode) as far as dependent read barriers go.
		 */
		root->rnode = (void  *)child;
		/*
		 * We have a dilemma here. The node's slot[0] must not be
		 * NULLed in case there are concurrent lookups expecting to
		 * find the item. However if this was a bottom-level node,
		 * then it may be subject to the slot pointer being visible
		 * to callers dereferencing it. If item corresponding to
		 * slot[0] is subsequently deleted, these callers would expect
		 * their slot to become empty sooner or later.
		 *
		 * For example, lockless pagecache will look up a slot, deref
		 * the page pointer, and if the page has 0 refcount it means it
		 * was concurrently deleted from pagecache so try the deref
		 * again. Fortunately there is already a requirement for logic
		 * to retry the entire slot lookup -- the indirect pointer
		 * problem (replacing direct root node with an indirect pointer
		 * also results in a stale slot). So tag the slot as indirect
		 * to force callers to retry.
		 */
		node->count = 0;
		if (!radix_tree_is_internal_node(child)) {
			node->slots[0] = (void  *)RADIX_TREE_RETRY;
			if (update_node)
				update_node(node);
		}

//		WARN_ON_ONCE(!list_empty(&node->private_list));
		radix_tree_node_free(node);
		shrunk = true;
	}

	return shrunk;
}

static bool delete_node(struct radix_tree_root *root,
			struct radix_tree_node *node,
			radix_tree_update_node_t update_node)
{
	bool deleted = false;

	do {
		struct radix_tree_node *parent;

		if (node->count) {
			if (node_to_entry(node) == root->rnode)
				deleted |= radix_tree_shrink(root,
								update_node);
			return deleted;
		}

		parent = node->parent;
		if (parent) {
			parent->slots[node->offset] = NULL;
			parent->count--;
		} else {
			/*
			 * Shouldn't the tags already have all been cleared
			 * by the caller?
			 */
			root->rnode = NULL;
		}
		//TODO:
//		WARN_ON_ONCE(!list_empty(&node->private_list));
		radix_tree_node_free(node);
		deleted = true;

		node = parent;
	} while (node);

	return deleted;
}

/**
 *	__radix_tree_create	-	create a slot in a radix tree
 *	@root:		radix tree root
 *	@index:		index key
 *	@order:		index occupies 2^order aligned slots
 *	@nodep:		returns node
 *	@slotp:		returns slot
 *
 *	Create, if necessary, and return the node and slot for an item
 *	at position @index in the radix tree @root.
 *
 *	Until there is more than one item in the tree, no nodes are
 *	allocated and @root->rnode is used as a direct slot instead of
 *	pointing to a node, in which case *@nodep will be NULL.
 *
 *	Returns -ENOMEM, or 0 for success.
 */
int __radix_tree_create(struct radix_tree_root *root, unsigned long index,
			unsigned order, struct radix_tree_node **nodep,
			void  ***slotp)
{
	struct radix_tree_node *node = NULL, *child;
	void  **slot = (void**)&root->rnode;
	unsigned long maxindex;
	unsigned int shift, offset = 0;
	unsigned long max = index | ((1UL << order) - 1);

	shift = radix_tree_load_root(root, &child, &maxindex);

	/* Make sure the tree is high enough.  */
	if (order > 0 && max == ((1UL << order) - 1))
		max++;
	if (max > maxindex) {
		int error = radix_tree_extend(root, max, shift);
		if (error < 0)
			return error;
		shift = error;
		child = root->rnode;
	}

	while (shift > order) {
		shift -= RADIX_TREE_MAP_SHIFT;
		if (child == NULL) {
			/* Have to add a child node.  */
			child = radix_tree_node_alloc(node, root, shift,
							offset, 0, 0);
			if (!child)
				//return -ENOMEM;
				return -1;
			*slot = node_to_entry(child);
			if (node)
				node->count++;
		} else if (!radix_tree_is_internal_node(child))
			break;

		/* Go a level down */
		node = entry_to_node(child);
		offset = radix_tree_descend(node, &child, index);
		slot = &node->slots[offset];
	}

	if (nodep)
		*nodep = node;
	if (slotp)
		*slotp = slot;
	return 0;
}

#ifdef CONFIG_RADIX_TREE_MULTIORDER
/*
 * Free any nodes below this node.  The tree is presumed to not need
 * shrinking, and any user data in the tree is presumed to not need a
 * destructor called on it.  If we need to add a destructor, we can
 * add that functionality later.  Note that we may not clear tags or
 * slots from the tree as an RCU walker may still have a pointer into
 * this subtree.  We could replace the entries with RADIX_TREE_RETRY,
 * but we'll still have to clear those in rcu_free.
 */
static void radix_tree_free_nodes(struct radix_tree_node *node)
{
	unsigned offset = 0;
	struct radix_tree_node *child = entry_to_node(node);

	for (;;) {
		void *entry = child->slots[offset];
		if (radix_tree_is_internal_node(entry) &&
					!is_sibling_entry(child, entry)) {
			child = entry_to_node(entry);
			offset = 0;
			continue;
		}
		offset++;
		while (offset == RADIX_TREE_MAP_SIZE) {
			struct radix_tree_node *old = child;
			offset = child->offset + 1;
			child = child->parent;
//			WARN_ON_ONCE(!list_empty(&old->private_list));
			radix_tree_node_free(old);
			if (old == entry_to_node(node))
				return;
		}
	}
}

static inline int insert_entries(struct radix_tree_node *node,
		void **slot, void *item, unsigned order, bool replace)
{
	struct radix_tree_node *child;
	unsigned i, n, tag, offset, tags = 0;

	if (node) {
		if (order > node->shift)
			n = 1 << (order - node->shift);
		else
			n = 1;
		offset = get_slot_offset(node, slot);
	} else {
		n = 1;
		offset = 0;
	}

	if (n > 1) {
		offset = offset & ~(n - 1);
		slot = &node->slots[offset];
	}
	child = node_to_entry(slot);

	for (i = 0; i < n; i++) {
		if (slot[i]) {
			if (replace) {
				node->count--;
				for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
					if (tag_get(node, tag, offset + i))
						tags |= 1 << tag;
			} else
				return -1;
			//	return -EEXIST;
		}
	}

	for (i = 0; i < n; i++) {
		struct radix_tree_node *old = slot[i];
		if (i) {
			slot[i] = child;
			for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
				if (tags & (1 << tag))
					tag_clear(node, tag, offset + i);
		} else {
			slot[i] = item;
			for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
				if (tags & (1 << tag))
					tag_set(node, tag, offset);
		}
		if (radix_tree_is_internal_node(old) &&
					!is_sibling_entry(node, old) &&
					(old != RADIX_TREE_RETRY))
			radix_tree_free_nodes(old);
		if (radix_tree_exceptional_entry(old))
			node->exceptional--;
	}
	if (node) {
		node->count += n;
		if (radix_tree_exceptional_entry(item))
			node->exceptional += n;
	}
	return n;
}
#else
static inline int insert_entries(struct radix_tree_node *node,
		void  **slot, void *item, unsigned order, bool replace)
{
	if (*slot)
	//	return -EEXIST;
		return -1;
	*slot = item;
	if (node) {
		node->count++;
		if (radix_tree_exceptional_entry(item))
			node->exceptional++;
	}
	return 1;
}
#endif

/**
 *	__radix_tree_insert    -    insert into a radix tree
 *	@root:		radix tree root
 *	@index:		index key
 *	@order:		key covers the 2^order indices around index
 *	@item:		item to insert
 *
 *	Insert an item into the radix tree at position @index.
 */
int __radix_tree_insert(struct radix_tree_root *root, unsigned long index,
			unsigned order, void *item)
{
	struct radix_tree_node *node;
	void **slot;
	int error;

	//TODO: error condition print some warning
	if(radix_tree_is_internal_node(item)){
		printf("item already in tree\n");
		return -1;
	}

	error = __radix_tree_create(root, index, order, &node, &slot);
	if (error)
		return error;

	error = insert_entries(node, slot, item, order, false);
	if (error < 0)
		return error;

	if (node) {
//TODO:error checking
//		unsigned offset = get_slot_offset(node, slot);
//		BUG_ON(tag_get(node, 0, offset));
//		BUG_ON(tag_get(node, 1, offset));
//		BUG_ON(tag_get(node, 2, offset));
	} else {
//		BUG_ON(root_tags_get(root));
	}

	return 0;
}

/**
 *	__radix_tree_lookup	-	lookup an item in a radix tree
 *	@root:		radix tree root
 *	@index:		index key
 *	@nodep:		returns node
 *	@slotp:		returns slot
 *
 *	Lookup and return the item at position @index in the radix
 *	tree @root.
 *
 *	Until there is more than one item in the tree, no nodes are
 *	allocated and @root->rnode is used as a direct slot instead of
 *	pointing to a node, in which case *@nodep will be NULL.
 */
void *__radix_tree_lookup(const struct radix_tree_root *root,
			  unsigned long index, struct radix_tree_node **nodep,
			  void  ***slotp)
{
	struct radix_tree_node *node, *parent;
	unsigned long maxindex;
	void **slot;

 restart:
	parent = NULL;
	slot = (void **)&root->rnode;
	radix_tree_load_root(root, &node, &maxindex);
	if (index > maxindex)
		return NULL;

	while (radix_tree_is_internal_node(node)) {
		unsigned offset;

		if (node == RADIX_TREE_RETRY)
			goto restart;
		parent = entry_to_node(node);
		offset = radix_tree_descend(parent, &node, index);
		slot = parent->slots + offset;
	}

	if (nodep)
		*nodep = parent;
	if (slotp)
		*slotp = slot;
	return node;
}

/**
 *	radix_tree_lookup_slot    -    lookup a slot in a radix tree
 *	@root:		radix tree root
 *	@index:		index key
 *
 *	Returns:  the slot corresponding to the position @index in the
 *	radix tree @root. This is useful for update-if-exists operations.
 *
 *	This function can be called under rcu_read_lock iff the slot is not
 *	modified by radix_tree_replace_slot, otherwise it must be called
 *	exclusive from other writers. Any dereference of the slot must be done
 *	using radix_tree_deref_slot.
 */
void  **radix_tree_lookup_slot(const struct radix_tree_root *root,
				unsigned long index)
{
	void  **slot;

	if (!__radix_tree_lookup(root, index, NULL, &slot))
		return NULL;
	return slot;
}

/**
 *	radix_tree_lookup    -    perform lookup operation on a radix tree
 *	@root:		radix tree root
 *	@index:		index key
 *
 *	Lookup the item at the position @index in the radix tree @root.
 *
 *	This function can be called under rcu_read_lock, however the caller
 *	must manage lifetimes of leaf nodes (eg. RCU may also be used to free
 *	them safely). No RCU barriers are required to access or modify the
 *	returned item, however.
 */
void *radix_tree_lookup(const struct radix_tree_root *root, unsigned long index)
{
	return __radix_tree_lookup(root, index, NULL, NULL);
}

static inline void replace_sibling_entries(struct radix_tree_node *node,
				void  **slot, int count, int exceptional)
{
#ifdef CONFIG_RADIX_TREE_MULTIORDER
	void *ptr = node_to_entry(slot);
	unsigned offset = get_slot_offset(node, slot) + 1;

	while (offset < RADIX_TREE_MAP_SIZE) {
		if (node->slots[offset] != ptr)
			break;
		if (count < 0) {
			node->slots[offset] = NULL;
			node->count--;
		}
		node->exceptional += exceptional;
		offset++;
	}
#endif
}

static void replace_slot(void  **slot, void *item,
		struct radix_tree_node *node, int count, int exceptional)
{
	if (radix_tree_is_internal_node(item))
		return;

	if (node && (count || exceptional)) {
		node->count += count;
		node->exceptional += exceptional;
		replace_sibling_entries(node, slot, count, exceptional);
	}

	*slot = item;
}


static int calculate_count(struct radix_tree_root *root,
				struct radix_tree_node *node, void  **slot,
				void *item, void *old)
{
	return !!item - !!old;
}

/**
 * __radix_tree_replace		- replace item in a slot
 * @root:		radix tree root
 * @node:		pointer to tree node
 * @slot:		pointer to slot in @node
 * @item:		new item to store in the slot.
 * @update_node:	callback for changing leaf nodes
 *
 * For use with __radix_tree_lookup().  Caller must hold tree write locked
 * across slot lookup and replacement.
 */
void __radix_tree_replace(struct radix_tree_root *root,
			  struct radix_tree_node *node,
			  void  **slot, void *item,
			  radix_tree_update_node_t update_node)
{
	void *old = *slot;
	int exceptional = !!radix_tree_exceptional_entry(item) -
				!!radix_tree_exceptional_entry(old);
	int count = calculate_count(root, node, slot, item, old);

	/*
	 * This function supports replacing exceptional entries and
	 * deleting entries, but that needs accounting against the
	 * node unless the slot is root->rnode.
	 */
//	WARN_ON_ONCE(!node && (slot != (void **)&root->rnode) &&
//			(count || exceptional));
	replace_slot(slot, item, node, count, exceptional);

	if (!node)
		return;

	if (update_node)
		update_node(node);

	delete_node(root, node, update_node);
}

/**
 * radix_tree_replace_slot	- replace item in a slot
 * @root:	radix tree root
 * @slot:	pointer to slot
 * @item:	new item to store in the slot.
 *
 * For use with radix_tree_lookup_slot(), radix_tree_gang_lookup_slot(),
 * radix_tree_gang_lookup_tag_slot().  Caller must hold tree write locked
 * across slot lookup and replacement.
 *
 * NOTE: This cannot be used to switch between non-entries (empty slots),
 * regular entries, and exceptional entries, as that requires accounting
 * inside the radix tree node. When switching from one type of entry or
 * deleting, use __radix_tree_lookup() and __radix_tree_replace() or
 * radix_tree_iter_replace().
 */
void radix_tree_replace_slot(struct radix_tree_root *root,
			     void **slot, void *item)
{
	__radix_tree_replace(root, NULL, slot, item, NULL);
}

/**
 * radix_tree_iter_replace - replace item in a slot
 * @root:	radix tree root
 * @slot:	pointer to slot
 * @item:	new item to store in the slot.
 *
 * For use with radix_tree_split() and radix_tree_for_each_slot().
 * Caller must hold tree write locked across split and replacement.
 */
void radix_tree_iter_replace(struct radix_tree_root *root,
				const struct radix_tree_iter *iter,
				void **slot, void *item)
{
	__radix_tree_replace(root, iter->node, slot, item, NULL);
}

#ifdef CONFIG_RADIX_TREE_MULTIORDER
/**
 * radix_tree_join - replace multiple entries with one multiorder entry
 * @root: radix tree root
 * @index: an index inside the new entry
 * @order: order of the new entry
 * @item: new entry
 *
 * Call this function to replace several entries with one larger entry.
 * The existing entries are presumed to not need freeing as a result of
 * this call.
 *
 * The replacement entry will have all the tags set on it that were set
 * on any of the entries it is replacing.
 */
int radix_tree_join(struct radix_tree_root *root, unsigned long index,
			unsigned order, void *item)
{
	struct radix_tree_node *node;
	void  **slot;
	int error;

//	BUG_ON(radix_tree_is_internal_node(item));

	error = __radix_tree_create(root, index, order, &node, &slot);
	if (!error)
		error = insert_entries(node, slot, item, order, true);
	if (error > 0)
		error = 0;

	return error;
}

/**
 * radix_tree_split - Split an entry into smaller entries
 * @root: radix tree root
 * @index: An index within the large entry
 * @order: Order of new entries
 *
 * Call this function as the first step in replacing a multiorder entry
 * with several entries of lower order.  After this function returns,
 * loop over the relevant portion of the tree using radix_tree_for_each_slot()
 * and call radix_tree_iter_replace() to set up each new entry.
 *
 * The tags from this entry are replicated to all the new entries.
 *
 * The radix tree should be locked against modification during the entire
 * replacement operation.  Lock-free lookups will see RADIX_TREE_RETRY which
 * should prompt RCU walkers to restart the lookup from the root.
 */
int radix_tree_split(struct radix_tree_root *root, unsigned long index,
				unsigned order)
{
	struct radix_tree_node *parent, *node, *child;
	void  **slot;
	unsigned int offset, end;
	unsigned n, tag, tags = 0;

	if (!__radix_tree_lookup(root, index, &parent, &slot))
		return -1;
	//	return -ENOENT;
	if (!parent)
		return -1;
	//	return -ENOENT;

	offset = get_slot_offset(parent, slot);

	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
		if (tag_get(parent, tag, offset))
			tags |= 1 << tag;

	for (end = offset + 1; end < RADIX_TREE_MAP_SIZE; end++) {
		if (!is_sibling_entry(parent, parent->slots[end]))
			break;
		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
			if (tags & (1 << tag))
				tag_set(parent, tag, end);
		parent->slots[end] = RADIX_TREE_RETRY;
	}
	parent->slots[offset] = RADIX_TREE_RETRY;
	parent->exceptional -= (end - offset);

	if (order == parent->shift)
		return 0;
	if (order > parent->shift) {
		while (offset < end)
			offset += insert_entries(parent, &parent->slots[offset],
					RADIX_TREE_RETRY, order, true);
		return 0;
	}

	node = parent;

	for (;;) {
		if (node->shift > order) {
			child = radix_tree_node_alloc(node, root,
					node->shift - RADIX_TREE_MAP_SHIFT,
					offset, 0, 0);
			if (!child)
				goto nomem;
			if (node != parent) {
				node->count++;
				node->slots[offset] = node_to_entry(child);
				for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
					if (tags & (1 << tag))
						tag_set(node, tag, offset);
			}

			node = child;
			offset = 0;
			continue;
		}

		n = insert_entries(node, &node->slots[offset],
					RADIX_TREE_RETRY, order, false);
	//	BUG_ON(n > RADIX_TREE_MAP_SIZE);

		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
			if (tags & (1 << tag))
				tag_set(node, tag, offset);
		offset += n;

		while (offset == RADIX_TREE_MAP_SIZE) {
			if (node == parent)
				break;
			offset = node->offset;
			child = node;
			node = node->parent;
			node->slots[offset]	= node_to_entry(child);
			offset++;
		}
		if ((node == parent) && (offset == end))
			return 0;
	}

 nomem:
	/* TODO: free all the allocated nodes */
//	WARN_ON(1);
	return -1;
}
#endif

static void node_tag_set(struct radix_tree_root *root,
				struct radix_tree_node *node,
				unsigned int tag, unsigned int offset)
{
	while (node) {
		if (tag_get(node, tag, offset))
			return;
		tag_set(node, tag, offset);
		offset = node->offset;
		node = node->parent;
	}

	if (!root_tag_get(root, tag))
		root_tag_set(root, tag);
}

/**
 *	radix_tree_tag_set - set a tag on a radix tree node
 *	@root:		radix tree root
 *	@index:		index key
 *	@tag:		tag index
 *
 *	Set the search tag (which must be < RADIX_TREE_MAX_TAGS)
 *	corresponding to @index in the radix tree.  From
 *	the root all the way down to the leaf node.
 *
 *	Returns the address of the tagged item.  Setting a tag on a not-present
 *	item is a bug.
 */
void *radix_tree_tag_set(struct radix_tree_root *root,
			unsigned long index, unsigned int tag)
{
	struct radix_tree_node *node, *parent;
	unsigned long maxindex;

	radix_tree_load_root(root, &node, &maxindex);
	//TODO:
//	BUG_ON(index > maxindex);

	while (radix_tree_is_internal_node(node)) {
		unsigned offset;

		parent = entry_to_node(node);
		offset = radix_tree_descend(parent, &node, index);
	//	BUG_ON(!node);

		if (!tag_get(parent, tag, offset))
			tag_set(parent, tag, offset);
	}

	/* set the root's tag bit */
	if (!root_tag_get(root, tag))
		root_tag_set(root, tag);

	return node;
}

/**
 * radix_tree_iter_tag_set - set a tag on the current iterator entry
 * @root:	radix tree root
 * @iter:	iterator state
 * @tag:	tag to set
 */
void radix_tree_iter_tag_set(struct radix_tree_root *root,
			const struct radix_tree_iter *iter, unsigned int tag)
{
	node_tag_set(root, iter->node, tag, iter_offset(iter));
}

static void node_tag_clear(struct radix_tree_root *root,
				struct radix_tree_node *node,
				unsigned int tag, unsigned int offset)
{
	while (node) {
		if (!tag_get(node, tag, offset))
			return;
		tag_clear(node, tag, offset);
		if (any_tag_set(node, tag))
			return;

		offset = node->offset;
		node = node->parent;
	}

	/* clear the root's tag bit */
	if (root_tag_get(root, tag))
		root_tag_clear(root, tag);
}

/**
 *	radix_tree_tag_clear - clear a tag on a radix tree node
 *	@root:		radix tree root
 *	@index:		index key
 *	@tag:		tag index
 *
 *	Clear the search tag (which must be < RADIX_TREE_MAX_TAGS)
 *	corresponding to @index in the radix tree.  If this causes
 *	the leaf node to have no tags set then clear the tag in the
 *	next-to-leaf node, etc.
 *
 *	Returns the address of the tagged item on success, else NULL.  ie:
 *	has the same return value and semantics as radix_tree_lookup().
 */
void *radix_tree_tag_clear(struct radix_tree_root *root,
			unsigned long index, unsigned int tag)
{
	struct radix_tree_node *node, *parent;
	unsigned long maxindex;
	int offset;

	radix_tree_load_root(root, &node, &maxindex);
	if (index > maxindex)
		return NULL;

	parent = NULL;

	while (radix_tree_is_internal_node(node)) {
		parent = entry_to_node(node);
		offset = radix_tree_descend(parent, &node, index);
	}

	if (node)
		node_tag_clear(root, parent, tag, offset);

	return node;
}

/**
  * radix_tree_iter_tag_clear - clear a tag on the current iterator entry
  * @root: radix tree root
  * @iter: iterator state
  * @tag: tag to clear
  */
void radix_tree_iter_tag_clear(struct radix_tree_root *root,
			const struct radix_tree_iter *iter, unsigned int tag)
{
	node_tag_clear(root, iter->node, tag, iter_offset(iter));
}

/**
 * radix_tree_tag_get - get a tag on a radix tree node
 * @root:		radix tree root
 * @index:		index key
 * @tag:		tag index (< RADIX_TREE_MAX_TAGS)
 *
 * Return values:
 *
 *  0: tag not present or not set
 *  1: tag set
 *
 * Note that the return value of this function may not be relied on, even if
 * the RCU lock is held, unless tag modification and node deletion are excluded
 * from concurrency.
 */
int radix_tree_tag_get(const struct radix_tree_root *root,
			unsigned long index, unsigned int tag)
{
	struct radix_tree_node *node, *parent;
	unsigned long maxindex;

	if (!root_tag_get(root, tag))
		return 0;

	radix_tree_load_root(root, &node, &maxindex);
	if (index > maxindex)
		return 0;

	while (radix_tree_is_internal_node(node)) {
		unsigned offset;

		parent = entry_to_node(node);
		offset = radix_tree_descend(parent, &node, index);

		if (!tag_get(parent, tag, offset))
			return 0;
		if (node == RADIX_TREE_RETRY)
			break;
	}

	return 1;
}

static inline void __set_iter_shift(struct radix_tree_iter *iter,
					unsigned int shift)
{
#ifdef CONFIG_RADIX_TREE_MULTIORDER
	iter->shift = shift;
#endif
}

/* Construct iter->tags bit-mask from node->tags[tag] array */
static void set_iter_tags(struct radix_tree_iter *iter,
				struct radix_tree_node *node, unsigned offset,
				unsigned tag)
{
	unsigned tag_long = offset / BITS_PER_LONG;
	unsigned tag_bit  = offset % BITS_PER_LONG;

	if (!node) {
		iter->tags = 1;
		return;
	}

	iter->tags = node->tags[tag][tag_long] >> tag_bit;

	/* This never happens if RADIX_TREE_TAG_LONGS == 1 */
	if (tag_long < RADIX_TREE_TAG_LONGS - 1) {
		/* Pick tags from next element */
		if (tag_bit)
			iter->tags |= node->tags[tag][tag_long + 1] <<
						(BITS_PER_LONG - tag_bit);
		/* Clip chunk size, here only BITS_PER_LONG tags */
		iter->next_index = __radix_tree_iter_add(iter, BITS_PER_LONG);
	}
}

#ifdef CONFIG_RADIX_TREE_MULTIORDER
static void **skip_siblings(struct radix_tree_node **nodep,
			void **slot, struct radix_tree_iter *iter)
{
	void *sib = node_to_entry(slot - 1);

	while (iter->index < iter->next_index) {
		*nodep = *slot;
		if (*nodep && *nodep != sib)
			return slot;
		slot++;
		iter->index = __radix_tree_iter_add(iter, 1);
		iter->tags >>= 1;
	}

	*nodep = NULL;
	return NULL;
}

void  **__radix_tree_next_slot(void **slot, struct radix_tree_iter *iter, unsigned flags)
{
	unsigned tag = flags & RADIX_TREE_ITER_TAG_MASK;
	struct radix_tree_node *node = *slot;

	slot = skip_siblings(&node, slot, iter);

	while (radix_tree_is_internal_node(node)) {
		unsigned offset;
		unsigned long next_index;

		if (node == RADIX_TREE_RETRY)
			return slot;
		node = entry_to_node(node);
		iter->node = node;
		iter->shift = node->shift;

		if (flags & RADIX_TREE_ITER_TAGGED) {
			offset = radix_tree_find_next_bit(node, tag, 0);
			if (offset == RADIX_TREE_MAP_SIZE)
				return NULL;
			slot = &node->slots[offset];
			iter->index = __radix_tree_iter_add(iter, offset);
			set_iter_tags(iter, node, offset, tag);
			node = *slot;
		} else {
			offset = 0;
			slot = &node->slots[0];
			for (;;) {
				node = *slot;
				if (node)
					break;
				slot++;
				offset++;
				if (offset == RADIX_TREE_MAP_SIZE)
					return NULL;
			}
			iter->index = __radix_tree_iter_add(iter, offset);
		}
		if ((flags & RADIX_TREE_ITER_CONTIG) && (offset > 0))
			goto none;
		next_index = (iter->index | shift_maxindex(iter->shift)) + 1;
		if (next_index < iter->next_index)
			iter->next_index = next_index;
	}

	return slot;
 none:
	iter->next_index = 0;
	return NULL;
}
#else
static void  **skip_siblings(struct radix_tree_node **nodep,
			void **slot, struct radix_tree_iter *iter)
{
	return slot;
}
#endif

void  **radix_tree_iter_resume(void **slot,
					struct radix_tree_iter *iter)
{
	struct radix_tree_node *node;

	slot++;
	iter->index = __radix_tree_iter_add(iter, 1);
	skip_siblings(&node, slot, iter);
	iter->next_index = iter->index;
	iter->tags = 0;
	return NULL;
}

/**
 * radix_tree_next_chunk - find next chunk of slots for iteration
 *
 * @root:	radix tree root
 * @iter:	iterator state
 * @flags:	RADIX_TREE_ITER_* flags and tag index
 * Returns:	pointer to chunk first slot, or NULL if iteration is over
 */
void  **radix_tree_next_chunk(const struct radix_tree_root *root,
			     struct radix_tree_iter *iter, unsigned flags)
{
	unsigned tag = flags & RADIX_TREE_ITER_TAG_MASK;
	struct radix_tree_node *node, *child;
	unsigned long index, offset, maxindex;

	if ((flags & RADIX_TREE_ITER_TAGGED) && !root_tag_get(root, tag))
		return NULL;

	/*
	 * Catch next_index overflow after ~0UL. iter->index never overflows
	 * during iterating; it can be zero only at the beginning.
	 * And we cannot overflow iter->next_index in a single step,
	 * because RADIX_TREE_MAP_SHIFT < BITS_PER_LONG.
	 *
	 * This condition also used by radix_tree_next_slot() to stop
	 * contiguous iterating, and forbid switching to the next chunk.
	 */
	index = iter->next_index;
	if (!index && iter->index)
		return NULL;

 restart:
	radix_tree_load_root(root, &child, &maxindex);
	if (index > maxindex)
		return NULL;
	if (!child)
		return NULL;

	if (!radix_tree_is_internal_node(child)) {
		/* Single-slot tree */
		iter->index = index;
		iter->next_index = maxindex + 1;
		iter->tags = 1;
		iter->node = NULL;
		__set_iter_shift(iter, 0);
		return (void  **)&root->rnode;
	}

	do {
		node = entry_to_node(child);
		offset = radix_tree_descend(node, &child, index);

		if ((flags & RADIX_TREE_ITER_TAGGED) ?
				!tag_get(node, tag, offset) : !child) {
			/* Hole detected */
			if (flags & RADIX_TREE_ITER_CONTIG)
				return NULL;

			if (flags & RADIX_TREE_ITER_TAGGED)
				offset = radix_tree_find_next_bit(node, tag,
						offset + 1);
			else
				while (++offset	< RADIX_TREE_MAP_SIZE) {
					void *slot = node->slots[offset];
					if (is_sibling_entry(node, slot))
						continue;
					if (slot)
						break;
				}
			index &= ~node_maxindex(node);
			index += offset << node->shift;
			/* Overflow after ~0UL */
			if (!index)
				return NULL;
			if (offset == RADIX_TREE_MAP_SIZE)
				goto restart;
			child = node->slots[offset];
		}

		if (!child)
			goto restart;
		if (child == RADIX_TREE_RETRY)
			break;
	} while (radix_tree_is_internal_node(child));

	/* Update the iterator state */
	iter->index = (index &~ node_maxindex(node)) | (offset << node->shift);
	iter->next_index = (index | node_maxindex(node)) + 1;
	iter->node = node;
	__set_iter_shift(iter, node->shift);

	if (flags & RADIX_TREE_ITER_TAGGED)
		set_iter_tags(iter, node, offset, tag);

	return node->slots + offset;
}

/**
 *	radix_tree_gang_lookup - perform multiple lookup on a radix tree
 *	@root:		radix tree root
 *	@results:	where the results of the lookup are placed
 *	@first_index:	start the lookup from this key
 *	@max_items:	place up to this many items at *results
 *
 *	Performs an index-ascending scan of the tree for present items.  Places
 *	them at *@results and returns the number of items which were placed at
 *	*@results.
 *
 *	The implementation is naive.
 *
 *	Like radix_tree_lookup, radix_tree_gang_lookup may be called under
 *	rcu_read_lock. In this case, rather than the returned results being
 *	an atomic snapshot of the tree at a single point in time, the
 *	semantics of an RCU protected gang lookup are as though multiple
 *	radix_tree_lookups have been issued in individual locks, and results
 *	stored in 'results'.
 */
unsigned int
radix_tree_gang_lookup(const struct radix_tree_root *root, void **results,
			unsigned long first_index, unsigned int max_items)
{
	struct radix_tree_iter iter;
	void **slot;
	unsigned int ret = 0;

	if (!max_items)
		return 0;

	radix_tree_for_each_slot(slot, root, &iter, first_index) {
		results[ret] = *slot;
		if (!results[ret])
			continue;
		if (radix_tree_is_internal_node(results[ret])) {
			slot = radix_tree_iter_retry(&iter);
			continue;
		}
		if (++ret == max_items)
			break;
	}

	return ret;
}

/**
 *	radix_tree_gang_lookup_slot - perform multiple slot lookup on radix tree
 *	@root:		radix tree root
 *	@results:	where the results of the lookup are placed
 *	@indices:	where their indices should be placed (but usually NULL)
 *	@first_index:	start the lookup from this key
 *	@max_items:	place up to this many items at *results
 *
 *	Performs an index-ascending scan of the tree for present items.  Places
 *	their slots at *@results and returns the number of items which were
 *	placed at *@results.
 *
 *	The implementation is naive.
 *
 *	Like radix_tree_gang_lookup as far as RCU and locking goes. Slots must
 *	be dereferenced with radix_tree_deref_slot, and if using only RCU
 *	protection, radix_tree_deref_slot may fail requiring a retry.
 */
unsigned int
radix_tree_gang_lookup_slot(const struct radix_tree_root *root,
			void ***results, unsigned long *indices,
			unsigned long first_index, unsigned int max_items)
{
	struct radix_tree_iter iter;
	void  **slot;
	unsigned int ret = 0;

	if (!max_items)
		return 0;

	radix_tree_for_each_slot(slot, root, &iter, first_index) {
		results[ret] = slot;
		if (indices)
			indices[ret] = iter.index;
		if (++ret == max_items)
			break;
	}

	return ret;
}

/**
 *	radix_tree_gang_lookup_tag - perform multiple lookup on a radix tree
 *	                             based on a tag
 *	@root:		radix tree root
 *	@results:	where the results of the lookup are placed
 *	@first_index:	start the lookup from this key
 *	@max_items:	place up to this many items at *results
 *	@tag:		the tag index (< RADIX_TREE_MAX_TAGS)
 *
 *	Performs an index-ascending scan of the tree for present items which
 *	have the tag indexed by @tag set.  Places the items at *@results and
 *	returns the number of items which were placed at *@results.
 */
unsigned int
radix_tree_gang_lookup_tag(const struct radix_tree_root *root, void **results,
		unsigned long first_index, unsigned int max_items,
		unsigned int tag)
{
	struct radix_tree_iter iter;
	void  **slot;
	unsigned int ret = 0;

	if ((!max_items))
		return 0;

	radix_tree_for_each_tagged(slot, root, &iter, first_index, tag) {
		results[ret] = *slot;
		if (!results[ret])
			continue;
		if (radix_tree_is_internal_node(results[ret])) {
			slot = radix_tree_iter_retry(&iter);
			continue;
		}
		if (++ret == max_items)
			break;
	}
	return ret;
}

/**
 *	radix_tree_gang_lookup_tag_slot - perform multiple slot lookup on a
 *					  radix tree based on a tag
 *	@root:		radix tree root
 *	@results:	where the results of the lookup are placed
 *	@first_index:	start the lookup from this key
 *	@max_items:	place up to this many items at *results
 *	@tag:		the tag index (< RADIX_TREE_MAX_TAGS)
 *
 *	Performs an index-ascending scan of the tree for present items which
 *	have the tag indexed by @tag set.  Places the slots at *@results and
 *	returns the number of slots which were placed at *@results.
 */
unsigned int
radix_tree_gang_lookup_tag_slot(const struct radix_tree_root *root,
		void ***results, unsigned long first_index,
		unsigned int max_items, unsigned int tag)
{
	struct radix_tree_iter iter;
	void **slot;
	unsigned int ret = 0;

	if ((!max_items))
		return 0;

	radix_tree_for_each_tagged(slot, root, &iter, first_index, tag) {
		results[ret] = slot;
		if (++ret == max_items)
			break;
	}

	return ret;
}

/**
 *	__radix_tree_delete_node    -    try to free node after clearing a slot
 *	@root:		radix tree root
 *	@node:		node containing @index
 *	@update_node:	callback for changing leaf nodes
 *
 *	After clearing the slot at @index in @node from radix tree
 *	rooted at @root, call this function to attempt freeing the
 *	node and shrinking the tree.
 */
void __radix_tree_delete_node(struct radix_tree_root *root,
			      struct radix_tree_node *node,
			      radix_tree_update_node_t update_node)
{
	delete_node(root, node, update_node);
}

static bool __radix_tree_delete(struct radix_tree_root *root,
				struct radix_tree_node *node, void **slot)
{
	void *old = *slot;
	int exceptional = radix_tree_exceptional_entry(old) ? -1 : 0;
	unsigned offset = get_slot_offset(node, slot);
	int tag;

	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
		node_tag_clear(root, node, tag, offset);

	replace_slot(slot, NULL, node, -1, exceptional);
	return node && delete_node(root, node, NULL);
}

/**
 * radix_tree_iter_delete - delete the entry at this iterator position
 * @root: radix tree root
 * @iter: iterator state
 * @slot: pointer to slot
 *
 * Delete the entry at the position currently pointed to by the iterator.
 * This may result in the current node being freed; if it is, the iterator
 * is advanced so that it will not reference the freed memory.  This
 * function may be called without any locking if there are no other threads
 * which can access this tree.
 */
void radix_tree_iter_delete(struct radix_tree_root *root,
				struct radix_tree_iter *iter, void  **slot)
{
	if (__radix_tree_delete(root, iter->node, slot))
		iter->index = iter->next_index;
}

/**
 * radix_tree_delete_item - delete an item from a radix tree
 * @root: radix tree root
 * @index: index key
 * @item: expected item
 *
 * Remove @item at @index from the radix tree rooted at @root.
 *
 * Return: the deleted entry, or %NULL if it was not present
 * or the entry at the given @index was not @item.
 */
void *radix_tree_delete_item(struct radix_tree_root *root,
			     unsigned long index, void *item)
{
	struct radix_tree_node *node = NULL;
	void  **slot;
	void *entry;

	entry = __radix_tree_lookup(root, index, &node, &slot);
	if (!entry)
		return NULL;

	if (item && entry != item)
		return NULL;

	__radix_tree_delete(root, node, slot);

	return entry;
}

/**
 * radix_tree_delete - delete an entry from a radix tree
 * @root: radix tree root
 * @index: index key
 *
 * Remove the entry at @index from the radix tree rooted at @root.
 *
 * Return: The deleted entry, or %NULL if it was not present.
 */
void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
{
	return radix_tree_delete_item(root, index, NULL);
}

void radix_tree_clear_tags(struct radix_tree_root *root,
			   struct radix_tree_node *node,
			   void **slot)
{
	if (node) {
		unsigned int tag, offset = get_slot_offset(node, slot);
		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
			node_tag_clear(root, node, tag, offset);
	} else {
		root_tag_clear_all(root);
	}
}

/**
 *	radix_tree_tagged - test whether any items in the tree are tagged
 *	@root:		radix tree root
 *	@tag:		tag to test
 */
int radix_tree_tagged(const struct radix_tree_root *root, unsigned int tag)
{
	return root_tag_get(root, tag);
}
