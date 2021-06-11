#include "Vector.hpp"

#include <stdexcept>
#include <thread>
#include <vector>

#define LOG_NODE_SIZE 5
#define NODE_SIZE (2 << LOG_NODE_SIZE)
#define NODE_BITMASK (NODE_SIZE - 1)

class Node : virtual public lisp_object {
	public:
		Node(std::thread::id id) :
			id(std::hash<std::thread::id>{}(id)),
			array(std::vector<std::shared_ptr<const lisp_object> >(NODE_SIZE)) {};
		Node(std::thread::id id, std::vector<std::shared_ptr<const lisp_object> > array) :
			id(std::hash<std::thread::id>{}(id)),
			array(array) {};
		Node(size_t id) : id(id),
			array(std::vector<std::shared_ptr<const lisp_object> >(NODE_SIZE)) {};
		Node(size_t id, std::vector<std::shared_ptr<const lisp_object> > array) :
			id(id), array(array) {};
		virtual std::string toString(void) const {return "";};
		// virtual std::shared_ptr<const IMeta> with_meta(std::shared_ptr<const IMap>) const;
							      
		// const std::shared_ptr<std::thread::id> id;
		size_t id;
		// std::mutex id_mutex;
		std::vector<std::shared_ptr<const lisp_object> > array;

		static const std::thread::id NOEDIT;
		static const std::shared_ptr<const Node> EmptyNode;
};
const std::thread::id Node::NOEDIT = std::thread().get_id();
const std::shared_ptr<const Node> Node::EmptyNode(new Node(NOEDIT));

// LVector Implementations
const std::shared_ptr<const LVector> LVector::EMPTY(new LVector(0, LOG_NODE_SIZE, Node::EmptyNode,
			std::vector<std::shared_ptr<const lisp_object> >()));

std::shared_ptr<const AVector> LVector::empty_impl(void) const {
	return LVector::EMPTY->with_meta(meta());
}

std::shared_ptr<const LVector> LVector::create(std::vector<std::shared_ptr<const lisp_object> >list) {
	size_t size = list.size();
	if(size == 0)
		return EMPTY;
	if(size <= NODE_SIZE)
		return std::shared_ptr<const LVector>(new LVector(size, LOG_NODE_SIZE, Node::EmptyNode, list));
	std::shared_ptr<TransientVector> ret = EMPTY->asTransient();
	for(size_t i=0; i<size; i++)
		ret = std::dynamic_pointer_cast<TransientVector>(ret->conj(list[i]));
	return std::dynamic_pointer_cast<const LVector>(ret->persistent());
}

std::shared_ptr<TransientVector> LVector::asTransient(void) const {
	return std::make_shared<TransientVector>(std::dynamic_pointer_cast<const LVector>(shared_from_this()));
}

std::shared_ptr<const AVector> LVector::cons_impl(std::shared_ptr<const lisp_object> val) const {
	//room in tail?
	if(cnt - tailoff() < NODE_SIZE) {
		std::vector<std::shared_ptr<const lisp_object> > newTail(tail.size() + 1);
		for(size_t i=0; i<tail.size(); i++)
			newTail[i] = tail[i];
		newTail[tail.size()] = val;
		return std::shared_ptr<LVector>(new LVector(meta(), cnt + 1, shift, root, newTail));
	}
	// full tail, push into tree
	std::shared_ptr<Node> newroot;
	std::shared_ptr<Node> tailnode = std::make_shared<Node>(root->id, tail);
	size_t newshift = shift;
	// overflow root?
	if((cnt >> LOG_NODE_SIZE) > (((size_t)1) << shift)) {
		newroot = std::make_shared<Node>(root->id);
		newroot->array[0] = root;
		newroot->array[1] = newPath(root->id, shift, tailnode);
		newshift += 5;
	} else
		newroot = pushTail(shift, root, tailnode);
	std::vector<std::shared_ptr<const lisp_object> > newTail(1);
	newTail[0] = val;
	return std::shared_ptr<LVector>(new LVector(meta(), cnt + 1, newshift, newroot, newTail));
}

std::shared_ptr<const IStack> LVector::pop(void) const {
	if(cnt == 0)
		throw std::runtime_error("Can't pop empty vector");
	if(cnt == 1)
		return std::dynamic_pointer_cast<const IStack>(EMPTY->with_meta(meta()));
	if(cnt-tailoff() > 1) {
		std::vector<std::shared_ptr<const lisp_object> >newTail(tail.size() - 1);
		for(size_t i=0; i<newTail.size(); i++)
			newTail[i] = tail[i];
		return std::shared_ptr<LVector>( new LVector(meta(), cnt - 1, shift, root, newTail));
	}
	std::vector<std::shared_ptr<const lisp_object> > newTail = arrayFor(cnt - 2);
	std::shared_ptr<const Node> newroot = popTail(shift, root);
	size_t newshift = shift;
	if(newroot == NULL)
		newroot = std::make_shared<const Node>(Node::NOEDIT);
	if(shift > LOG_NODE_SIZE && newroot->array[1] == NULL) {
		newroot = std::dynamic_pointer_cast<const Node>(newroot->array[0]);
		newshift -= 5;
	}
	return std::shared_ptr<LVector>(new LVector(meta(), cnt - 1, newshift, newroot, newTail));
}

std::shared_ptr<const lisp_object>LVector::nth(size_t i)const {
	return arrayFor(i)[i & NODE_BITMASK];
}

std::shared_ptr<const LVector> LVector::with_meta_impl(std::shared_ptr<const IMap> meta) const {
	return std::shared_ptr<LVector>(new LVector(meta, cnt, shift, root, tail));
}

std::shared_ptr<const AVector> LVector::assocN_impl(size_t i, const std::shared_ptr<const lisp_object> val) const {
	if(i < cnt) {
		if(i >= tailoff()) {
			std::vector<std::shared_ptr<const lisp_object> >newTail(tail.size());
			for(size_t j=0; j<tail.size(); j++)
				newTail[j] = tail[j];
			newTail[i & NODE_BITMASK] = val;
			return std::shared_ptr<LVector>(new LVector(meta(), cnt, shift, root, newTail));
		}

		return std::shared_ptr<LVector>(new LVector(meta(), cnt, shift, doAssoc(shift, root, i, val), tail));
	}
	if(i == cnt)
		return std::dynamic_pointer_cast<const LVector>(cons(val));
	throw std::out_of_range(i + " is Out of Range");
}

std::shared_ptr<Node> LVector::doAssoc(size_t level, std::shared_ptr<const Node> node, size_t i, std::shared_ptr<const lisp_object> val) {
	std::shared_ptr<Node> ret = std::make_shared<Node>(node->id, node->array);
	if(level == 0) {
		ret->array[i & NODE_BITMASK] = val;
	} else {
		size_t subidx = (i >> level) & NODE_BITMASK;
		ret->array[subidx] = doAssoc(level - LOG_NODE_SIZE, std::dynamic_pointer_cast<const Node>(node->array[subidx]), i, val);
	}
	return ret;
}

std::vector<std::shared_ptr<const lisp_object> > LVector::arrayFor(size_t i) const {
	if(i < cnt) {
		if(i >= tailoff())
			return tail;
		std::shared_ptr<const Node> node = root;
		for(size_t level = shift; level > 0; level -= LOG_NODE_SIZE)
			node = std::dynamic_pointer_cast<Node>(std::const_pointer_cast<lisp_object>(node->array[(i >> level) & NODE_BITMASK]));
		return node->array;
	}
	throw std::out_of_range(i + " is Out of Range");
}

size_t LVector::tailoff(void) const {
	if(cnt < NODE_SIZE)
		return 0;
	return ((cnt-1) >> LOG_NODE_SIZE) << LOG_NODE_SIZE;
}

std::shared_ptr<Node> LVector::newPath(size_t id, size_t level, std::shared_ptr<Node> node) {
	if(level == 0)
		return node;
	std::shared_ptr<Node> ret = std::make_shared<Node>(id);
	ret->array[0] = newPath(id, level - LOG_NODE_SIZE, node);
	return ret;
}

std::shared_ptr<Node> LVector::pushTail(size_t level, std::shared_ptr<const Node> parent, std::shared_ptr<const Node> tailnode) const {
	// if parent is leaf, insert node,
	//  else does it map to an existing child? -> nodeToInsert = pushNode one more level
	//  else alloc new path
	// return  nodeToInsert placed in copy of parent
	size_t subidx = ((cnt - 1) >> level) & NODE_BITMASK;
	std::shared_ptr<Node> ret = std::make_shared<Node>(parent->id, parent->array);
	std::shared_ptr<const Node> nodeToInsert;
	if(level == LOG_NODE_SIZE)
		nodeToInsert = tailnode;
	else {
		std::shared_ptr<const Node> child = std::dynamic_pointer_cast<const Node>(parent->array[subidx]);
	nodeToInsert = (child != NULL)?
	                pushTail(level-LOG_NODE_SIZE, child, tailnode)
	                :NULL; // newPath(root->id, level-LOG_NODE_SIZE, tailnode);
	}
	ret->array[subidx] = nodeToInsert;
	return ret;
}

std::shared_ptr<Node> LVector::popTail(size_t level, std::shared_ptr<const Node> node) const {
	size_t subidx = ((cnt-2) >> level) & NODE_BITMASK;
	if(level > LOG_NODE_SIZE) {
		std::shared_ptr<Node> newchild = popTail(level - LOG_NODE_SIZE, std::dynamic_pointer_cast<const Node>(node->array[subidx]));
		if(newchild == NULL && subidx == 0) {
			return NULL;
		} else {
			std::shared_ptr<Node> ret = std::make_shared<Node>(root->id,node->array);
			ret->array[subidx] = newchild;
			return ret;
		}
	} else if(subidx == 0) {
		return NULL;
	} else {
		std::shared_ptr<Node> ret = std::make_shared<Node>(root->id,node->array);
		ret->array[subidx] = NULL;
		return ret;
	}
}

// TransientVector Implementations
std::shared_ptr<Node> TransientVector::editableRoot(const std::shared_ptr<const Node> node){
	return std::make_shared<Node>(std::this_thread::get_id(), node->array);
}

std::vector<std::shared_ptr<const lisp_object> > TransientVector::editableTail(std::vector<std::shared_ptr<const lisp_object> > tl) {
	std::vector<std::shared_ptr<const lisp_object> >ret = tl;
	ret.resize(NODE_SIZE);
	return ret;
}

std::vector<std::shared_ptr<const lisp_object> > TransientVector::arrayFor(size_t i) const {
	if(i < cnt) {
		if(i >= tailoff())
			return tail;
		std::shared_ptr<Node> node = root;
		for(size_t level = shift; level > 0; level -= LOG_NODE_SIZE)
			node = std::dynamic_pointer_cast<Node>(std::const_pointer_cast<lisp_object>(node->array[(i >> level) & NODE_BITMASK]));
		return node->array;
	}
	throw std::out_of_range(i + " is Out of Range");
}

std::shared_ptr<Node> TransientVector::newPath(size_t id, size_t level, std::shared_ptr<Node> node) {
	if(level == 0)
		return node;
	std::shared_ptr<Node> ret = std::make_shared<Node>(id);
	ret->array[0] = newPath(id, level - LOG_NODE_SIZE, node);
	return ret;
}

std::shared_ptr<Node> TransientVector::pushTail(size_t level, std::shared_ptr<Node> parent, std::shared_ptr<Node> tailnode) {
	parent = ensureEditable(parent);
	size_t subidx = ((cnt - 1) >> level) & NODE_BITMASK;
	std::shared_ptr<Node> ret = parent;
	std::shared_ptr<Node> nodeToInsert;
	if(level == LOG_NODE_SIZE){
		nodeToInsert = tailnode;
	} else {
		std::shared_ptr<Node> child = std::dynamic_pointer_cast<Node>(std::const_pointer_cast<lisp_object>(parent->array[subidx]));
		nodeToInsert = (child != NULL) ? pushTail(level - LOG_NODE_SIZE, child, tailnode)
									   : newPath(root->id, level - LOG_NODE_SIZE, tailnode);
	}
	ret->array[subidx] = nodeToInsert;
	return ret;
}

void TransientVector::ensureEditable(void) const {
	if(root->id == std::hash<std::thread::id>{}(Node::NOEDIT))
		throw std::runtime_error("Transient used after persistent call");
}

std::shared_ptr<Node> TransientVector::ensureEditable(std::shared_ptr<Node> node) const {
	if(node->id == root->id)
		return node;
	return std::make_shared<Node>(root->id, node->array);
}

std::shared_ptr<const lisp_object> TransientVector::nth(size_t i) const {
	ensureEditable();
	return arrayFor(i)[i & NODE_BITMASK];
}

std::shared_ptr<ITransientCollection> TransientVector::conj(const std::shared_ptr<const lisp_object> val) {
	ensureEditable();
	size_t i = cnt;
	// Is there room in the tail?
	if(i - tailoff() < NODE_SIZE) {
		tail[i & NODE_BITMASK] = val;
		cnt++;
		return std::dynamic_pointer_cast<TransientVector>(shared_from_this());
	}
	// The tail is full, push into the tree.
	std::shared_ptr<Node> newroot;
	std::shared_ptr<Node> tailnode = std::make_shared<Node>(root->id, tail);
	tail = std::vector<std::shared_ptr<const lisp_object> >(NODE_SIZE);
	tail[0] = val;
	size_t newshift = shift;
	//overflow root?
	if((cnt >> LOG_NODE_SIZE) > (((size_t)1) << shift)) {
		newroot = std::make_shared<Node>(root->id);
		newroot->array[0] = root;
		newroot->array[1] = newPath(root->id, shift, tailnode);
		newshift += LOG_NODE_SIZE;
	} else
		newroot = pushTail(shift, root, tailnode);
	root = newroot;
	shift = newshift;
	cnt++;
	return std::dynamic_pointer_cast<TransientVector>(shared_from_this());
}

std::shared_ptr<const ICollection> TransientVector::persistent(void) {
	ensureEditable();
	root->id = std::hash<std::thread::id>{}(Node::NOEDIT);
	size_t len = cnt - tailoff();
	std::vector<std::shared_ptr<const lisp_object> > trimmedTail(len);
	for(size_t i=0; i<len; i++)
		trimmedTail[i] = tail[i];
	return std::shared_ptr<const LVector>(new LVector(cnt, shift, root, trimmedTail));
}

size_t TransientVector::tailoff(void) const {
	if(cnt < NODE_SIZE)
		return 0;
	return ((cnt-1) >> LOG_NODE_SIZE) << LOG_NODE_SIZE;
}
