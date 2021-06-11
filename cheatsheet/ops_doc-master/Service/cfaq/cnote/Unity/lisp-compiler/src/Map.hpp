#ifndef MAP_HPP
#define MAP_HPP

#include "Interfaces.hpp"

#include <thread>
#include <vector>

#include "AMap.hpp"
#include "Node.hpp"

class TransientMap;

class LMap : public IMeta_inherit<LMap>, public virtual Associative, public AMap, public IEditableCollection /* IMapIterable, IKVReduce */ {
	public:
		virtual size_t count() const;
		virtual std::shared_ptr<const ISeq> seq() const;
		virtual std::shared_ptr<const IMap> without(std::shared_ptr<const lisp_object>) const;
		virtual std::shared_ptr<ITransientCollection> asTransient() const;
		virtual bool containsKey(const std::shared_ptr<const lisp_object>) const;

		static std::shared_ptr<const LMap> create(std::vector<std::shared_ptr<const lisp_object> >);

		static std::shared_ptr<const LMap> EMPTY;
	private:
		const size_t _count;
		const std::shared_ptr<const INode> root;
		const bool hasNull;
		const std::shared_ptr<const lisp_object> nullValue;

		LMap(std::shared_ptr<const IMap> meta, size_t count, std::shared_ptr<const INode> root, bool hasNull,
				std::shared_ptr<const lisp_object> nullValue) :
			IMeta_inherit(meta), _count(count), root(root), hasNull(hasNull), nullValue(nullValue) {};
		LMap(size_t count, std::shared_ptr<const INode> root, bool hasNull, std::shared_ptr<const lisp_object> nullValue) : _count(count), root(root), hasNull(hasNull), nullValue(nullValue) {};
		virtual std::shared_ptr<const AMap> assoc_impl(std::shared_ptr<const lisp_object>,
													   std::shared_ptr<const lisp_object>) const;
		virtual std::shared_ptr<const LMap> with_meta_impl(std::shared_ptr<const IMap>) const;
		virtual std::shared_ptr<const AMap> empty_impl() const;
		friend TransientMap;
};

class TransientMap : public ITransientAssociative_inherit<TransientMap, ATransientMap> {
	public:
		TransientMap(size_t hashId, size_t count, std::shared_ptr<INode> root, bool hasNull, std::shared_ptr<const lisp_object> nullValue) : hashId(hashId), _count(count), root(root), hasNull(hasNull), nullValue(nullValue) {};
		virtual std::string toString() const;
		virtual size_t count() const;
		virtual std::shared_ptr<const ICollection> persistent();
		virtual std::shared_ptr<ITransientMap> without(std::shared_ptr<const lisp_object> key);
	private:
		size_t hashId;
		size_t _count;
		std::shared_ptr<INode> root;
		bool hasNull;
		std::shared_ptr<const lisp_object> nullValue;

		virtual std::shared_ptr<TransientMap> assoc_impl(std::shared_ptr<const lisp_object>, std::shared_ptr<const lisp_object>);
		virtual void ensureEditable() const;
};

#endif /* MAP_HPP */
