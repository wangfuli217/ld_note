#ifndef NODE_HPP
#define NODE_HPP

#include "Interfaces.hpp"

#include <thread>
#include <vector>

class INode : public lisp_object {
	public:
		virtual std::string toString(void) const {return "";};
		virtual std::shared_ptr<const INode> assoc(size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) const = 0;
		virtual std::shared_ptr<INode> assoc(size_t hashId, size_t shift, size_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) = 0;
		virtual std::shared_ptr<INode> assoc(std::thread::id id, size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf);
		virtual std::shared_ptr<const INode> without(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const = 0;
		virtual std::shared_ptr<INode> without(size_t hashId, size_t shift, size_t hash,
				std::shared_ptr<const lisp_object> key, bool &removedLeaf) = 0;
		virtual std::shared_ptr<const IMapEntry> find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const = 0;
		virtual std::shared_ptr<const lisp_object> find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> notFound) const = 0;
		virtual std::shared_ptr<const ISeq> nodeSeq() const = 0;

		// Object kvreduce(IFn f, Object init);
		// Object fold(IFn combinef, IFn reducef, IFn fjtask, IFn fjfork, IFn fjjoin);
	protected:
		INode(size_t hashId, std::vector<std::shared_ptr<const lisp_object> > array) :
			array(array), hashId(hashId) {};
		std::vector<std::shared_ptr<const lisp_object> > array;
		size_t hashId;
};

template<class Derived>
class INode_inherit : public INode, public std::enable_shared_from_this<Derived> {
	public:
		virtual ~INode_inherit() = default;
	protected:
		virtual std::shared_ptr<Derived> ensureEditable(size_t hashId) = 0;
		std::shared_ptr<Derived> editAndSet(size_t hashId, size_t i, std::shared_ptr<const lisp_object> a);
		std::shared_ptr<Derived> editAndSet(size_t hashId, size_t i, std::shared_ptr<const lisp_object> a,
				size_t j, std::shared_ptr<const lisp_object> b);
	private:
		INode_inherit() = default;
		INode_inherit(size_t hashId, std::vector<std::shared_ptr<const lisp_object> > array) :
			INode(hashId, array) {};
		friend Derived;
};

class BitmapIndexedNode : public INode_inherit<BitmapIndexedNode> {
	public:
		BitmapIndexedNode(std::thread::id id, uint32_t bitmap, std::vector<std::shared_ptr<const lisp_object> > array) :
			INode_inherit<BitmapIndexedNode>(std::hash<std::thread::id>{}(id), array), bitmap(bitmap) {};
		BitmapIndexedNode(size_t hashId, uint32_t bitmap, std::vector<std::shared_ptr<const lisp_object> > array) :
			INode_inherit<BitmapIndexedNode>(hashId, array), bitmap(bitmap) {};

		size_t index(uint32_t bit) const;
		virtual std::shared_ptr<const INode> assoc(size_t shift, uint32_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf) const;
		virtual std::shared_ptr<INode> assoc(size_t hashId, size_t shift, size_t hash, std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val, bool& addedLeaf);
		virtual std::shared_ptr<const INode> without(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const;
		virtual std::shared_ptr<INode> without(size_t hashId, size_t shift, size_t hash,
				std::shared_ptr<const lisp_object> key, bool &removedLeaf);
		virtual std::shared_ptr<const IMapEntry> find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key) const;
		virtual std::shared_ptr<const lisp_object> find(size_t shift, size_t hash, std::shared_ptr<const lisp_object> key,
				std::shared_ptr<const lisp_object> notFound) const;
		virtual std::shared_ptr<const ISeq> nodeSeq() const;

		static const std::shared_ptr<const BitmapIndexedNode> Empty;
		static const std::thread::id NOEDIT;
		static const size_t HASH_NOEDIT;
	private:
		uint32_t bitmap;

		std::shared_ptr<BitmapIndexedNode> ensureEditable(size_t hashId);
		std::shared_ptr<BitmapIndexedNode> editAndRemovePair(size_t hashId, uint32_t bit, size_t i);
};

#endif /* NODE_HPP */
