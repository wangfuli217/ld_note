#include "Node.hpp"

#include <functional>

#include "ASeq.hpp"
#include "MapEntry.hpp"
#include "Util.hpp"
#include "intrinsics.h"

#define NODE_LOG_SIZE 5
#define NODE_SIZE (1 << NODE_LOG_SIZE)
#define NODE_BITMASK (NODE_SIZE - 1)

std::shared_ptr<INode> INode::assoc(std::thread::id id, size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) {
	return assoc(std::hash<std::thread::id>{}(id), shift, hash, key, val, addedLeaf);
}

template<class Derived>
std::shared_ptr<Derived> INode_inherit<Derived>::editAndSet(size_t hashId, size_t i, std::shared_ptr<const lisp_object> a) {
	std::shared_ptr<Derived> editable = ensureEditable(hashId);
	editable->array[i] = a;
	return editable;
}

template<class Derived>
std::shared_ptr<Derived> INode_inherit<Derived>::editAndSet(size_t hashId, size_t i, std::shared_ptr<const lisp_object> a,
		size_t j, std::shared_ptr<const lisp_object> b) {
	std::shared_ptr<Derived> editable = ensureEditable(hashId);
	editable->array[i] = a;
	editable->array[j] = b;
	return editable;
}

static uint32_t mask(uint32_t hash, size_t shift) {
	return (hash >> shift) & NODE_BITMASK;
}

static uint32_t bitpos(uint32_t hash, size_t shift) {
	return 1 << mask(hash, shift);
}

class NodeSeq : public ASeq {
	public:
		static std::shared_ptr<const ISeq> create(std::vector<std::shared_ptr<const lisp_object> > array);
		virtual std::shared_ptr<const lisp_object> first(void) const;
		virtual std::shared_ptr<const ISeq> next(void) const;
	private:
		NodeSeq(std::shared_ptr<const IMap> meta, std::vector<std::shared_ptr<const lisp_object> > array, size_t i,
				std::shared_ptr<const ISeq> s) : ASeq(meta), array(array), i(i), s(s) {};
		static std::shared_ptr<const ISeq> create(std::vector<std::shared_ptr<const lisp_object> > array, size_t i,
				std::shared_ptr<const ISeq> s);
		virtual std::shared_ptr<const ASeq> with_meta_impl(std::shared_ptr<const IMap>) const;

		const std::vector<std::shared_ptr<const lisp_object> > array;
		const size_t i;
		const std::shared_ptr<const ISeq> s;
};

class ArrayNodeSeq : public ASeq {
	public:
		static std::shared_ptr<const ISeq> create(std::vector<std::shared_ptr<INode> > array);
		virtual std::shared_ptr<const lisp_object> first(void) const;
		virtual std::shared_ptr<const ISeq> next(void) const;
	private:
		ArrayNodeSeq(std::shared_ptr<const IMap> meta, std::vector<std::shared_ptr<INode> > array, size_t i,
				std::shared_ptr<const ISeq> s) : ASeq(meta), nodes(array), i(i), s(s) {};
		static std::shared_ptr<const ISeq> create(std::shared_ptr<const IMap> meta, std::vector<std::shared_ptr<INode> > array,
				size_t i, std::shared_ptr<const ISeq> s);
		virtual std::shared_ptr<const ASeq> with_meta_impl(std::shared_ptr<const IMap>) const;

		const std::vector<std::shared_ptr<INode> > nodes;
		const size_t i;
		const std::shared_ptr<const ISeq> s;
};

class HashCollisionNode : public INode_inherit<HashCollisionNode> {
	public:
		HashCollisionNode(size_t hashId, uint32_t hash, size_t count, std::vector<std::shared_ptr<const lisp_object> > array) :
			INode_inherit<HashCollisionNode>(hashId, array), hash(hash), count(count) {};

		virtual std::shared_ptr<HashCollisionNode> ensureEditable(size_t hashId);
		virtual std::shared_ptr<const INode> assoc(size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) const;
		virtual std::shared_ptr<INode> assoc(size_t hashId, size_t shift, size_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf);
		virtual std::shared_ptr<const INode> without(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const;
		virtual std::shared_ptr<INode> without(size_t hashId, size_t shift, size_t hash,
				std::shared_ptr<const lisp_object> key, bool &removedLeaf);
		virtual std::shared_ptr<const IMapEntry> find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const;
		virtual std::shared_ptr<const lisp_object> find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> notFound) const;
		virtual std::shared_ptr<const ISeq> nodeSeq() const;

		std::shared_ptr<HashCollisionNode> ensureEditable2(size_t hashId, size_t count, std::vector<std::shared_ptr<const lisp_object> > array);
	private:
		const uint32_t hash;
		size_t count;

		size_t findIndex(std::shared_ptr<const lisp_object>) const;
};

class ArrayNode : public INode_inherit<ArrayNode> {
	public:
		ArrayNode(std::thread::id id, size_t count, std::vector<std::shared_ptr<INode> >array) :
			INode_inherit<ArrayNode>(std::hash<std::thread::id>{}(id), std::vector<std::shared_ptr<const lisp_object> >()),
			count(count), array(array) {};
		ArrayNode(size_t hashId, size_t count, std::vector<std::shared_ptr<INode> >array) :
			INode_inherit<ArrayNode>(hashId, std::vector<std::shared_ptr<const lisp_object> >()),
			count(count), array(array) {};

		virtual std::shared_ptr<const INode> assoc(size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> val, bool& addedLeaf) const;
		virtual std::shared_ptr<INode> assoc(size_t hashId, size_t shift, size_t hash, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> val, bool& addedLeaf);
		virtual std::shared_ptr<const INode> without(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const;
		virtual std::shared_ptr<INode> without(size_t hashId, size_t shift, size_t hash,
				std::shared_ptr<const lisp_object> key, bool &removedLeaf);
		virtual std::shared_ptr<const IMapEntry> find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const;
		virtual std::shared_ptr<const lisp_object> find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> notFound) const;
		virtual std::shared_ptr<const ISeq> nodeSeq() const;

	private:
		size_t count;
		std::vector<std::shared_ptr<INode> > array;

		virtual std::shared_ptr<ArrayNode> ensureEditable(size_t hashId);

		std::shared_ptr<ArrayNode> editAndSet(size_t hashId, size_t i, std::shared_ptr<INode> a);
		std::shared_ptr<BitmapIndexedNode> pack(size_t hashId, size_t idx) const;
};

static std::shared_ptr<const INode> createNode(size_t hashId, size_t shift, std::shared_ptr<const lisp_object> key1, std::shared_ptr<const lisp_object> val1, uint32_t key2hash, std::shared_ptr<const lisp_object> key2, std::shared_ptr<const lisp_object> val2) {
	size_t key1hash = hash(key1);
	if(key1hash == key2hash) {
		return std::make_shared<HashCollisionNode>(BitmapIndexedNode::HASH_NOEDIT, key1hash,
				2, std::vector<std::shared_ptr<const lisp_object> >{key1, val1, key2, val2});
		return NULL;
	}
	bool addedLeaf = false;
	return std::const_pointer_cast<BitmapIndexedNode>(BitmapIndexedNode::Empty)
		->assoc(hashId, shift, key1hash, key1, val1, addedLeaf)
		->assoc(hashId, shift, key2hash, key2, val2, addedLeaf);
}

static std::shared_ptr<const INode> createNode(size_t shift, std::shared_ptr<const lisp_object> key1, std::shared_ptr<const lisp_object> val1, uint32_t key2hash, std::shared_ptr<const lisp_object> key2, std::shared_ptr<const lisp_object> val2) {
	return createNode(BitmapIndexedNode::HASH_NOEDIT, shift, key1, val1, key2hash, key2, val2);
}

static std::vector<std::shared_ptr<INode> > cloneAndSet(const std::vector<std::shared_ptr<INode> > &array,
		size_t i, std::shared_ptr<INode> a) {
	std::vector<std::shared_ptr<INode> > clone(array);
	clone[i] = a;
	return clone;
}

static std::vector<std::shared_ptr<const lisp_object> > cloneAndSet(const std::vector<std::shared_ptr<const lisp_object> > &array,
		size_t i, std::shared_ptr<const lisp_object> a) {
	std::vector<std::shared_ptr<const lisp_object> > clone(array);
	clone[i] = a;
	return clone;
}

static std::vector<std::shared_ptr<const lisp_object> > cloneAndSet(std::vector<std::shared_ptr<const lisp_object> > &array,
		size_t i, std::shared_ptr<const lisp_object> a, size_t j, std::shared_ptr<const lisp_object> b) {
	std::vector<std::shared_ptr<const lisp_object> > clone(array);
	clone[i] = a;
	clone[j] = b;
	return clone;
}

static std::vector<std::shared_ptr<const lisp_object> > removePair(const std::vector<std::shared_ptr<const lisp_object> > &array,
		size_t i) {
	std::vector<std::shared_ptr<const lisp_object> > newArray(array.size() - 2);
	for(size_t j=0; j<2*i; j++)
		newArray[j] = array[j];
	for(size_t j=2*i; j<newArray.size(); j++)
		newArray[j] = array[j+2];
	return newArray;
}


// BitmapIndexedNode
const std::thread::id BitmapIndexedNode::NOEDIT =  std::thread().get_id();
const std::shared_ptr<const BitmapIndexedNode> BitmapIndexedNode::Empty = std::make_shared<const BitmapIndexedNode>(NOEDIT, 0, std::vector<std::shared_ptr<const lisp_object> >());
const size_t BitmapIndexedNode::HASH_NOEDIT = std::hash<std::thread::id>{}(BitmapIndexedNode::NOEDIT);

std::shared_ptr<const INode> BitmapIndexedNode::assoc(size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) const {
	uint32_t bit = bitpos(hash, shift);
	size_t idx = index(bit);
	if((bitmap & bit) != 0) {
		std::shared_ptr<const lisp_object> keyOrNull = array[2*idx];
		std::shared_ptr<const lisp_object> valOrNode = array[2*idx + 1];
		if(keyOrNull == NULL) {
			std::shared_ptr<const INode> n = std::dynamic_pointer_cast<const INode>(valOrNode);
			n = n->assoc(shift + NODE_LOG_SIZE, hash, key, val, addedLeaf);
			if(n == valOrNode)
				return shared_from_this();
			std::vector<std::shared_ptr<const lisp_object> > newArray(array);
			newArray[2*idx+1] = n;
			return std::make_shared<const BitmapIndexedNode>(NOEDIT, bitmap, newArray);
		}
		if(equiv(key, keyOrNull)) {
			if(val == valOrNode)
				return shared_from_this();
			std::vector<std::shared_ptr<const lisp_object> > newArray(array);
			newArray[2*idx+1] = val;
			return std::make_shared<BitmapIndexedNode>(NOEDIT, bitmap, newArray);
		}
		addedLeaf = true;
		std::vector<std::shared_ptr<const lisp_object> > newArray(array);
		newArray[2*idx    ] = NULL;
		newArray[2*idx + 1] = createNode(shift + NODE_LOG_SIZE, keyOrNull, valOrNode, hash, key, val);
		return std::make_shared<BitmapIndexedNode>(NOEDIT, bitmap, newArray);
	} else {
		size_t n = popcount(bitmap);
		if(n >= (NODE_SIZE >> 1)) {
			std::vector<std::shared_ptr<INode> > nodes(NODE_SIZE);
			size_t jdx = mask(hash, shift);
			nodes[jdx] = std::const_pointer_cast<INode>(Empty->assoc(shift + NODE_LOG_SIZE, hash, key, val, addedLeaf));
			size_t j = 0;
			for(size_t i=0; i<NODE_SIZE; i++) {
				if((bitmap >> i) & 1) {
					if(array[j])
						nodes[i] = std::const_pointer_cast<INode>(Empty->assoc(shift + NODE_LOG_SIZE, hashEq(array[j]), array[j], array[j+1], addedLeaf));
					else
						nodes[i] = std::const_pointer_cast<INode>(std::dynamic_pointer_cast<const INode>(array[j+1]));
					j += 2;
				}
			}
			return std::make_shared<ArrayNode>(NOEDIT, n+1, nodes);
		} else {
			std::vector<std::shared_ptr<const lisp_object> > newArray(2*(n+1));
			for(size_t i=0; i<2*idx; i++)
				newArray[i] = array[i];
			newArray[2*idx  ] = key;
			addedLeaf = true;
			newArray[2*idx+1] = val;
			for(size_t i=2*idx; i<2*(n+1); i++)
				newArray[i+2] = array[i];
			return std::make_shared<BitmapIndexedNode>(NOEDIT, bitmap | bit, newArray);
		}
	}
}

std::shared_ptr<INode> BitmapIndexedNode::assoc(size_t hashId, size_t shift, size_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) {
	uint32_t bit = bitpos(hash, shift);
	size_t idx = index(bit);
	if(bitmap & bit) {
		std::shared_ptr<const lisp_object> keyOrNull = array[2*idx];
		std::shared_ptr<const lisp_object> valOrNode = array[2*idx+1];
		if(keyOrNull == NULL) {
			std::shared_ptr<INode> n = std::const_pointer_cast<INode>(std::dynamic_pointer_cast<const INode>(valOrNode));
			n = n->assoc(hashId, shift + NODE_LOG_SIZE, hash, key, val, addedLeaf);
			if(n == valOrNode)
				return shared_from_this();
			return editAndSet(hashId, 2*idx+1, val);
		}
		if(equiv(key, keyOrNull)) {
			if(val == valOrNode)
				return shared_from_this();
			return editAndSet(hashId, 2*idx+1, val);
		}
		addedLeaf = true;
		return editAndSet(hashId, 2*idx, NULL, 2*idx+1, 
				createNode(hashId, shift + NODE_LOG_SIZE, keyOrNull, valOrNode, hash, key, val));
	} else {
		size_t n = popcount(bitmap);
		if(2*n < array.size()) {
			addedLeaf = true;
			std::shared_ptr<BitmapIndexedNode> editable = ensureEditable(hashId);
			for(size_t i=2*n-1; i>=2*idx; i--)
				editable->array[i+2] = editable->array[i];
			editable->array[2*idx  ] = key;
			editable->array[2*idx+1] = val;
			editable->bitmap |= bit;
			return editable;
		}
		if(n >= (NODE_SIZE >> 1)) {
			std::vector<std::shared_ptr<INode> > nodes(NODE_SIZE);
			size_t jdx = mask(hash, shift);
			nodes[jdx] = std::const_pointer_cast<BitmapIndexedNode>(Empty)->assoc(hashId, shift + NODE_LOG_SIZE, hash, key, val, addedLeaf);
			size_t j = 0;
			for(size_t i=0; i<NODE_SIZE; i++) {
				if((bitmap >> i) & 1) {
					if (array[j] == NULL)
						nodes[i] = std::const_pointer_cast<INode>(std::dynamic_pointer_cast<const INode>(array[j+1]));
					else
						nodes[i] = std::const_pointer_cast<BitmapIndexedNode>(Empty)->assoc(hashId, shift + NODE_LOG_SIZE, hashEq(array[j]), array[j], array[j+1], addedLeaf);
					j += 2;
				}
			}
			return std::make_shared<ArrayNode>(hashId, n+1, nodes);
		} else {
			std::vector<std::shared_ptr<const lisp_object> > newArray(2*(n+4));
			for(size_t i=0; i<2*idx; i++)
				newArray[i] = array[i];
			newArray[2*idx] = key;
			addedLeaf = true;
			newArray[2*idx+1] = val;
			for(size_t i=2*idx; i<2*n; i++)
				newArray[i+2] = array[i];
			std::shared_ptr<BitmapIndexedNode> editable = ensureEditable(hashId);
			editable->array = newArray;
			editable->bitmap |= bit;
			return editable;
		}
	}
}

size_t BitmapIndexedNode::index(uint32_t bit) const {
	return popcount(bitmap & (bit - 1));
}

std::shared_ptr<BitmapIndexedNode> BitmapIndexedNode::ensureEditable(size_t hashId) {
	if(this->hashId == hashId)
		return shared_from_this();
	size_t n = popcount(bitmap);
	std::vector<std::shared_ptr<const lisp_object> > newArray(2*(n+1));
	for(size_t i=0; i<2*n; i++)
		newArray[i] = array[i];
	return std::make_shared<BitmapIndexedNode>(hashId, bitmap, newArray);
}

std::shared_ptr<const INode> BitmapIndexedNode::without(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const {
	uint32_t bit = bitpos(hash, shift);
	if((bitmap & bit) == 0)
		return shared_from_this();
	size_t idx = index(bit);
	std::shared_ptr<const lisp_object> keyOrNull = array[2*idx];
	std::shared_ptr<const lisp_object> valOrNode = array[2*idx+1];
	if(keyOrNull == NULL) {
		std::shared_ptr<const INode> n = std::dynamic_pointer_cast<const INode>(valOrNode)
			->without(shift + NODE_LOG_SIZE, hash, key);
		if(n == valOrNode)
			return shared_from_this();
		if(n)
			return std::make_shared<BitmapIndexedNode>(HASH_NOEDIT, bitmap, cloneAndSet(array, 2*idx+1, n));
		if(bitmap == bit) 
			return NULL;
		return std::make_shared<BitmapIndexedNode>(HASH_NOEDIT, bitmap ^ bit, removePair(array, idx));
	}
	if(equiv(key, keyOrNull))
		return std::make_shared<BitmapIndexedNode>(HASH_NOEDIT, bitmap ^ bit, removePair(array, idx));
	return shared_from_this();
}

std::shared_ptr<INode> BitmapIndexedNode::without(size_t hashId, size_t shift, size_t hash,
		std::shared_ptr<const lisp_object> key, bool &removedLeaf){
	size_t bit = bitpos(hash, shift);
	if(bitmap & bit)
		return shared_from_this();
	size_t idx = index(bit);
	std::shared_ptr<const lisp_object> keyOrNull = array[2*idx];
	std::shared_ptr<const lisp_object> valOrNode = array[2*idx+1];
	if(keyOrNull == NULL) {
		std::shared_ptr<INode> n = std::const_pointer_cast<INode>(std::dynamic_pointer_cast<const INode>(valOrNode))
			->without(hashId, shift + NODE_LOG_SIZE, hash, key, removedLeaf);
		if(n == valOrNode)
			return shared_from_this();
		if(n)
			return editAndSet(hashId, 2*idx+1, n);
		if (bitmap == bit) 
			return NULL;
		return editAndRemovePair(hashId, bit, idx); 
	}
	if(equiv(key, keyOrNull)) {
		removedLeaf = true;
		return editAndRemovePair(hashId, bit, idx);				
	}
	return shared_from_this();
}

std::shared_ptr<const IMapEntry> BitmapIndexedNode::find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const {
	uint32_t bit = bitpos(hash, shift);
	if(bitmap & bit)
		return NULL;
	size_t idx = index(bit);
	std::shared_ptr<const lisp_object> keyOrNull = array[2*idx];
	std::shared_ptr<const lisp_object> valOrNode = array[2*idx+1];
	if(keyOrNull == NULL)
		return std::dynamic_pointer_cast<const INode>(valOrNode)->find(shift + NODE_LOG_SIZE, hash, key);
	if(equiv(key, keyOrNull))
		return MapEntry::create(keyOrNull, valOrNode);
	return NULL;
}

std::shared_ptr<const lisp_object> BitmapIndexedNode::find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> notFound) const {
	uint32_t bit = bitpos(hash, shift);
	if(bitmap & bit)
		return notFound;
	size_t idx = index(bit);
	std::shared_ptr<const lisp_object> keyOrNull = array[2*idx];
	std::shared_ptr<const lisp_object> valOrNode = array[2*idx+1];
	if(keyOrNull == NULL)
		return std::dynamic_pointer_cast<const INode>(valOrNode)->find(shift + NODE_LOG_SIZE, hash, key, notFound);
	if(equiv(key, keyOrNull))
		return valOrNode;
	return notFound;
}

std::shared_ptr<BitmapIndexedNode> BitmapIndexedNode::editAndRemovePair(size_t hashId, uint32_t bit, size_t i) {
	if (bitmap == bit) 
		return NULL;
	std::shared_ptr<BitmapIndexedNode> editable = ensureEditable(hashId);
	editable->bitmap ^= bit;
	for(size_t j=2*i; j<editable->array.size()-2; j++)
		editable->array[j] = editable->array[j+2];
	editable->array[editable->array.size() - 2] = NULL;
	editable->array[editable->array.size() - 1] = NULL;
	return editable;
}

std::shared_ptr<const ISeq> BitmapIndexedNode::nodeSeq() const {
	return NodeSeq::create(array);
}

// HashCollisionNode
std::shared_ptr<const INode> HashCollisionNode::assoc(size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) const {
	if(hash == this->hash) {
		size_t idx = findIndex(key);
		if(idx != (size_t)-1) {
			if(array[idx+1]->equals(val))
				return shared_from_this();
		}
		std::vector<std::shared_ptr<const lisp_object> > newArray(2*count + 2);
		for(size_t i=0; i<2*count+2; i++)
			newArray[i] = array[i];
		newArray[2*count    ] = key;
		newArray[2*count + 1] = val;
		addedLeaf = true;
		return std::make_shared<HashCollisionNode>(hashId, hash, count+1, newArray);
	}
	std::vector<std::shared_ptr<const lisp_object> > newArray(2);
	newArray[1] = shared_from_this();
	return std::make_shared<BitmapIndexedNode>(BitmapIndexedNode::NOEDIT, bitpos(this->hash, shift), newArray)
		->assoc(shift, hash, key, val, addedLeaf);
}

std::shared_ptr<INode> HashCollisionNode::assoc(size_t hashId, size_t shift, size_t hash, std::shared_ptr<const lisp_object>   key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) {
	if(hash == this->hash) {
		size_t idx = findIndex(key);
		if(idx != ((size_t)-1)) {
			if(array[idx+1] == val)
				return shared_from_this();
			return editAndSet(hashId, idx+1, val);
		}
		if(array.size() > 2*count) {
			addedLeaf = true;
			std::shared_ptr<HashCollisionNode> editable = editAndSet(hashId, 2*count, key, 2*count+1, val);
			editable->count++;
			return editable;
		}
		std::vector<std::shared_ptr<const lisp_object> > newArray(array.size()+2);
		for(size_t i=0; i<array.size(); i++)
			newArray[i] = array[i];
		newArray[array.size()  ] = key;
		newArray[array.size()+1] = val;
		addedLeaf = true;
		return ensureEditable2(hashId, count+1, newArray);
	}
	std::vector<std::shared_ptr<const lisp_object> > newArray(4);
	newArray[1] = shared_from_this();
	return std::make_shared<BitmapIndexedNode>(hashId, bitpos(this->hash, shift), newArray)
		->assoc(hashId, shift, hash, key, val, addedLeaf);
}

std::shared_ptr<const INode> HashCollisionNode::without(size_t, size_t hash, std::shared_ptr<const lisp_object> key) const {
	size_t idx = findIndex(key);
	if(idx == (size_t)-1)
		return shared_from_this();
	if(count == 1)
		return NULL;
	return std::make_shared<HashCollisionNode>(BitmapIndexedNode::HASH_NOEDIT, hash, count - 1, removePair(array, idx/2));
}

std::shared_ptr<INode> HashCollisionNode::without(size_t hashId, size_t, size_t, std::shared_ptr<const lisp_object> key,
		bool &removedLeaf) {
	size_t idx = findIndex(key);
	if(idx == (size_t)-1)
		return shared_from_this();
	removedLeaf = true;
	if(count == 1)
		return NULL;
	std::shared_ptr<HashCollisionNode> editable = ensureEditable(hashId);
	editable->array[idx      ] = editable->array[2*count-2];
	editable->array[idx+1    ] = editable->array[2*count-1];
	editable->array[2*count-2] = editable->array[2*count-1] = NULL;
	editable->count--;
	return editable;
}

std::shared_ptr<const IMapEntry> HashCollisionNode::find(size_t, size_t, std::shared_ptr<const lisp_object> key) const {
	size_t idx = findIndex(key);
	if(idx == ((size_t)-1))
		return NULL;
	if(equiv(key, array[idx]))
		return MapEntry::create(array[idx], array[idx+1]);
	return NULL;
}

std::shared_ptr<const lisp_object> HashCollisionNode::find(size_t, size_t, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> notFound) const {
	size_t idx = findIndex(key);
	if(idx == ((size_t)-1))
		return notFound;
	if(equiv(key, array[idx]))
		return array[idx+1];
	return notFound;
}

size_t HashCollisionNode::findIndex(std::shared_ptr<const lisp_object> key) const {
	for(size_t i=0; i<array.size(); i+=2)
		if(equiv(key, array[i]))
			return i;
	return (size_t) -1;
}

std::shared_ptr<HashCollisionNode> HashCollisionNode::ensureEditable(size_t hashId) {
	if(this->hashId == hashId)
		return shared_from_this();
	std::vector<std::shared_ptr<const lisp_object> > newArray(2*(count+1));
	for(size_t i=0; i<2*count; i++)
		newArray[i] = array[i];
	return std::make_shared<HashCollisionNode>(hashId, hash, count, newArray);
}

std::shared_ptr<HashCollisionNode> HashCollisionNode::ensureEditable2(size_t hashId, size_t count,
		std::vector<std::shared_ptr<const lisp_object> > array) {
	if(this->hashId == hashId) {
		this->array = array;
		this->count = count;
	}
	return std::make_shared<HashCollisionNode>(hashId, hash, count, array);
}

std::shared_ptr<const ISeq> HashCollisionNode::nodeSeq() const {
	return NodeSeq::create(array);
}

// ArrayNode
std::shared_ptr<const INode> ArrayNode::assoc(size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) const {
	size_t idx = mask(hash, shift);
	std::shared_ptr<INode> node = array[idx];
	if(node == NULL) {
		std::vector<std::shared_ptr<INode> >newArray(array);
		newArray[idx] = std::const_pointer_cast<INode>(BitmapIndexedNode::Empty->assoc(shift + NODE_LOG_SIZE, hash, key, val, addedLeaf));
		return std::make_shared<ArrayNode>(BitmapIndexedNode::NOEDIT, count + 1, newArray);
	}
	std::shared_ptr<INode> n = std::const_pointer_cast<INode>(node->assoc(shift + NODE_LOG_SIZE, hash, key, val, addedLeaf));
	if(n == node)
		return shared_from_this();
	std::vector<std::shared_ptr<INode> >newArray(array);
	newArray[idx] = n;
	return std::make_shared<ArrayNode>(BitmapIndexedNode::NOEDIT, count, newArray);
}

std::shared_ptr<INode> ArrayNode::assoc(size_t hashId, size_t shift, size_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) {
	size_t idx = mask(hash, shift);
	std::shared_ptr<INode> node = array[idx];
	if(node == NULL) {
		std::shared_ptr<ArrayNode> editable = editAndSet(hashId, idx, std::const_pointer_cast<BitmapIndexedNode>(BitmapIndexedNode::Empty)
				->assoc(hashId, shift+NODE_LOG_SIZE, hash, key, val, addedLeaf));
		editable->count++;
		return editable;
	}
	std::shared_ptr<INode> n = node->assoc(hashId, shift+NODE_LOG_SIZE, hash, key, val, addedLeaf);
	if(n == node)
		return shared_from_this();
	return editAndSet(hashId, idx, n);
}

std::shared_ptr<ArrayNode> ArrayNode::ensureEditable(size_t hashId) {
	if(this->hashId == hashId)
		return shared_from_this();
	return std::make_shared<ArrayNode>(hashId, count, array);
}

std::shared_ptr<ArrayNode> ArrayNode::editAndSet(size_t hashId, size_t i, std::shared_ptr<INode> a) {
	std::shared_ptr<ArrayNode> editable = ensureEditable(hashId);
	editable->array[i] = a;
	return editable;
}

std::shared_ptr<const INode> ArrayNode::without(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const {
	size_t idx = mask(hash, shift);
	std::shared_ptr<INode> node = array[idx];
	if(node == NULL)
		return shared_from_this();
	std::shared_ptr<INode> n = std::const_pointer_cast<INode>(node->without(shift+NODE_LOG_SIZE, hash, key));
	if(n == node)
		return shared_from_this();
	if(n == NULL) {
		if(count <= (NODE_SIZE >> 2)) 
			return pack(BitmapIndexedNode::HASH_NOEDIT, idx);
		return std::make_shared<ArrayNode>(BitmapIndexedNode::HASH_NOEDIT, count-1, cloneAndSet(array, idx, n));
	}
	return std::make_shared<ArrayNode>(BitmapIndexedNode::HASH_NOEDIT, count, cloneAndSet(array, idx, n));
}

std::shared_ptr<INode> ArrayNode::without(size_t hashId, size_t shift, size_t hash,
		std::shared_ptr<const lisp_object> key, bool &removedLeaf) {
	size_t idx = mask(hash, shift);
	std::shared_ptr<INode> node = array[idx];
	if(node == NULL)
		return shared_from_this();
	std::shared_ptr<INode> n = node->without(hashId, shift + NODE_LOG_SIZE, hash, key, removedLeaf);
	if(n == node)
		return shared_from_this();
	if(n == NULL) {
		if (count <= NODE_SIZE >> 2) // shrink
			return pack(hashId, idx);
		std::shared_ptr<ArrayNode> editable = editAndSet(hashId, idx, n);
		editable->count--;
		return editable;
	}
	return editAndSet(hashId, idx, n);
}

std::shared_ptr<const IMapEntry> ArrayNode::find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const {
	size_t idx = mask(hash, shift);
	std::shared_ptr<INode> node = array[idx];
	if(node == NULL)
		return NULL;
	return node->find(shift + NODE_LOG_SIZE, hash, key); 
}

std::shared_ptr<const lisp_object> ArrayNode::find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> notFound) const {
	size_t idx = mask(hash, shift);
	std::shared_ptr<INode> node = array[idx];
	if(node == NULL)
		return notFound;
	return node->find(shift + NODE_LOG_SIZE, hash, key); 
}

std::shared_ptr<BitmapIndexedNode> ArrayNode::pack(size_t hashId, size_t idx) const {
	  std::vector<std::shared_ptr<const lisp_object> > newArray(2*(count-1));
	  size_t j = 1;
	  uint32_t bitmap = 0;
	  for(size_t i=0; i<idx; i++) {
		  if(array[i]) {
			  newArray[j] = array[i];
			  bitmap |= (1 << i);
			  j += 2;
		  }
	  }
	  for(size_t i=idx+1; i<array.size(); i++) {
		  if(array[i]) {
			  newArray[j] = array[i];
			  bitmap |= (1 << i);
			  j += 2;
		  }
	  }
	  return std::make_shared<BitmapIndexedNode>(hashId, bitmap, newArray);
}

std::shared_ptr<const ISeq> ArrayNode::nodeSeq() const {
	return ArrayNodeSeq::create(array);
}

// ArrayNodeSeq
std::shared_ptr<const ISeq> ArrayNodeSeq::create(std::vector<std::shared_ptr<INode> > array) {
	return create(NULL, array, 0, NULL);
}

std::shared_ptr<const ISeq> ArrayNodeSeq::create(std::shared_ptr<const IMap> meta, std::vector<std::shared_ptr<INode> > array,
				size_t i, std::shared_ptr<const ISeq> s) {
	if(s)
		return std::shared_ptr<const ArrayNodeSeq>(new ArrayNodeSeq(meta, array, i, s));
	for(size_t j=i; j<array.size(); j++) {
		if(array[j]) {
			std::shared_ptr<const ISeq> ns = array[j]->nodeSeq();
			if(ns)
				return std::shared_ptr<const ArrayNodeSeq>(new ArrayNodeSeq(meta, array, i, s));
		}
	}
	return NULL;
}

std::shared_ptr<const ASeq> ArrayNodeSeq::with_meta_impl(std::shared_ptr<const IMap> meta) const {
	return std::shared_ptr<const ArrayNodeSeq>(new ArrayNodeSeq(meta, nodes, i, s));
}

std::shared_ptr<const lisp_object> ArrayNodeSeq::first(void) const {
	return s->first();
}

std::shared_ptr<const ISeq> ArrayNodeSeq::next(void) const {
	return create(NULL, nodes, i, s->next());
}

// NodeSeq
std::shared_ptr<const ISeq> NodeSeq::create(std::vector<std::shared_ptr<const lisp_object> > array) {
	return create(array, 0, NULL);
}

std::shared_ptr<const ISeq> NodeSeq::create(std::vector<std::shared_ptr<const lisp_object> > array, size_t i, std::shared_ptr<const ISeq> s) {
	if(s)
		return std::shared_ptr<const NodeSeq>(new NodeSeq(NULL, array, i, s));
	for(size_t j = i; j<array.size(); j+=2) {
		if(array[j])
			return std::shared_ptr<const NodeSeq>(new NodeSeq(NULL, array, j, NULL));
		std::shared_ptr<const INode> node = std::dynamic_pointer_cast<const INode>(array[j+1]);
		if(node) {
			std::shared_ptr<const ISeq> nodeSeq = node->nodeSeq();
			if(nodeSeq)
				return std::shared_ptr<const NodeSeq>(new NodeSeq(NULL, array, j+2, nodeSeq));
		}
	}
	return NULL;
}

std::shared_ptr<const ASeq> NodeSeq::with_meta_impl(std::shared_ptr<const IMap> meta) const {
	return std::shared_ptr<const NodeSeq>(new NodeSeq(meta, array, i, s));
}

std::shared_ptr<const lisp_object> NodeSeq::first(void) const {
	if(s)
		return s->first();
	return MapEntry::create(array[i], array[i+1]);
}

std::shared_ptr<const ISeq> NodeSeq::next(void) const {
	if(s)
		return create(array, i, s->next());
	return create(array, i + 2, NULL);
}
