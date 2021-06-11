#include "Map.hpp"

#include "List.hpp"
#include "MapEntry.hpp"
#include "Node.hpp"
#include "Util.hpp"

class NotFound : public lisp_object {
	public:
		virtual std::string toString(void) const {
			return "Not Found";
		};
};

static std::shared_ptr<const lisp_object> NOT_FOUND = std::shared_ptr<NotFound>(new NotFound());

size_t LMap::count() const {
	  return _count;
}

std::shared_ptr<const ISeq> LMap::seq() const {
	std::shared_ptr<const ISeq> s = root ? root->nodeSeq() : NULL;
	return hasNull ? std::dynamic_pointer_cast<const ISeq>(s->cons(MapEntry::create(NULL, nullValue))) : s;
}

 std::shared_ptr<const AMap> LMap::empty_impl() const {
	 return EMPTY->with_meta(meta());
}

std::shared_ptr<const AMap> LMap::assoc_impl(std::shared_ptr<const lisp_object> key, 
		std::shared_ptr<const lisp_object> val) const {
	if(key == NULL) {
		if(hasNull && (val == nullValue))
			return std::dynamic_pointer_cast<const LMap>(shared_from_this());
		return std::shared_ptr<const LMap>(new LMap(meta(), _count + (hasNull ? 0 : 1), root, true, val));
	}
	bool addedLeaf = false;
	std::shared_ptr<const INode> newroot = (root == NULL ? BitmapIndexedNode::Empty : root)->assoc(0, hashEq(key), key, val, addedLeaf);
	if(newroot == root)
		return std::dynamic_pointer_cast<const LMap>(shared_from_this());
	return std::shared_ptr<const LMap>(new LMap(meta(), addedLeaf ? _count + 1 : _count, newroot, hasNull, nullValue));
}

std::shared_ptr<const IMap> LMap::without(std::shared_ptr<const lisp_object> key) const {
	if(key == NULL)
		return hasNull ? std::shared_ptr<LMap>(new LMap(meta(), _count - 1, root, false, std::shared_ptr<const lisp_object>()))
			: std::dynamic_pointer_cast<const LMap>(shared_from_this());
	if(root == NULL)
		return std::dynamic_pointer_cast<const LMap>(shared_from_this());
	std::shared_ptr<const INode> newroot = root->without(0, hash(key), key);
	if(newroot == root)
		return std::dynamic_pointer_cast<const LMap>(shared_from_this());
	return std::shared_ptr<LMap>(new LMap(meta(), _count - 1, newroot, hasNull, nullValue));
}

std::shared_ptr<const LMap> LMap::with_meta_impl(std::shared_ptr<const IMap> meta) const {
	return std::shared_ptr<const LMap>(new LMap(meta, _count, root, hasNull, nullValue));
}

std::shared_ptr<ITransientCollection> LMap::asTransient() const {
	return std::make_shared<TransientMap>(std::hash<std::thread::id>{}(std::this_thread::get_id()), _count, std::const_pointer_cast<INode>(root), hasNull, nullValue);
}

bool LMap::containsKey(const std::shared_ptr<const lisp_object> key) const {
	if(key == NULL)
		return hasNull;
	return root ? root->find(0, hash(key), key, NOT_FOUND) != NOT_FOUND : false;
}

std::shared_ptr<const LMap> LMap::create(std::vector<std::shared_ptr<const lisp_object> > init) {
	if(init.size() % 2)
		throw std::runtime_error("Map literal must contain an even number of forms");
	std::shared_ptr<ITransientMap> ret = std::dynamic_pointer_cast<ITransientMap>(EMPTY->asTransient());
	for(size_t i=0; i<init.size(); i++)
		ret = std::dynamic_pointer_cast<ITransientMap>(ret->assoc(init[i], init[i+1]));
	return std::dynamic_pointer_cast<const LMap>(ret->persistent());
}

std::shared_ptr<const LMap> LMap::EMPTY = std::shared_ptr<LMap>(new LMap(0, NULL, false, NULL));

std::string TransientMap::toString() const {
	return "";
}

size_t TransientMap::count() const {
	ensureEditable();
	return _count;
}

std::shared_ptr<const ICollection> TransientMap::persistent() {
	ensureEditable();
	hashId = BitmapIndexedNode::HASH_NOEDIT;
	return std::shared_ptr<const LMap>(new LMap(_count, root, hasNull, nullValue));
}

std::shared_ptr<ITransientMap> TransientMap::without(std::shared_ptr<const lisp_object> key) {
	ensureEditable();
	if (key == NULL) {
		if (!hasNull) return shared_from_this();
		hasNull = false;
		nullValue = NULL;
		_count--;
		return shared_from_this();
	}
	if (root == NULL)
		return shared_from_this();
	bool leafFlag = false;
	std::shared_ptr<INode> n = root->without(hashId, 0, hash(key), key, leafFlag);
	if (n != root)
		root = n;
	if(leafFlag)
		_count--;
	return shared_from_this();
}

std::shared_ptr<TransientMap> TransientMap::assoc_impl(std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val) {
	ensureEditable();
	if (key == NULL) {
		if (nullValue != val)
			nullValue = val;
		if (!hasNull) {
			_count++;
			hasNull = true;
		}
		return std::dynamic_pointer_cast<TransientMap>(shared_from_this());
	}
	bool leafFlag = false;
	std::shared_ptr<INode> n = (root == NULL ? std::const_pointer_cast<BitmapIndexedNode>(BitmapIndexedNode::Empty) : root)
		->assoc(hashId, 0, hashEq(key), key, val, leafFlag);
	if (n != root)
		root = n; 
	if(leafFlag) _count++;
	return std::dynamic_pointer_cast<TransientMap>(shared_from_this());
}

void TransientMap::ensureEditable() const {
	if(hashId == BitmapIndexedNode::HASH_NOEDIT)
		throw std::runtime_error("Transient used after persistent! call");
}
