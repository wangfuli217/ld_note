#ifndef VECTOR_HPP
#define VECTOR_HPP

#include "Interfaces.hpp"

#include <vector>

#include "AVector.hpp"

class Node;
class TransientVector;
class LVector : virtual public AVector, public IMeta_inherit<LVector> {
	public:
		static std::shared_ptr<const LVector> create(std::vector<std::shared_ptr<const lisp_object> >);
		virtual size_t count(void) const {return cnt;};
		std::shared_ptr<TransientVector> asTransient(void) const;
		virtual std::shared_ptr<const IStack> pop(void) const;
		virtual std::shared_ptr<const lisp_object>nth(size_t i)const;

		static const std::shared_ptr<const LVector> EMPTY;
	private:
		const size_t cnt;
		const size_t shift;
		const std::shared_ptr<const Node> root;
		const std::vector<std::shared_ptr<const lisp_object> > tail;

		size_t tailoff(void) const;
		std::vector<std::shared_ptr<const lisp_object> > arrayFor(size_t i) const;
		static std::shared_ptr<Node> newPath(size_t id, size_t level, std::shared_ptr<Node> node);
		static std::shared_ptr<Node> doAssoc(size_t level, std::shared_ptr<const Node> node, size_t i, std::shared_ptr<const lisp_object> val);	
		std::shared_ptr<Node> pushTail(size_t level, std::shared_ptr<const Node> parent, std::shared_ptr<const Node> tailnode) const;
		std::shared_ptr<Node> popTail(size_t level, std::shared_ptr<const Node> node) const;
		virtual std::shared_ptr<const LVector> with_meta_impl(std::shared_ptr<const IMap>) const;
		virtual std::shared_ptr<const AVector> cons_impl(std::shared_ptr<const lisp_object>) const;
		virtual std::shared_ptr<const AVector> empty_impl(void) const;
		virtual std::shared_ptr<const AVector> assocN_impl(size_t, const std::shared_ptr<const lisp_object>) const;

		friend TransientVector;

		LVector(size_t cnt, size_t shift, std::shared_ptr<const Node> root, 
			const std::vector<std::shared_ptr<const lisp_object> > tail) : 
			cnt(cnt), shift(shift), root(root), tail(tail) {};
		LVector(std::shared_ptr<const IMap>meta, size_t cnt, size_t shift, std::shared_ptr<const Node> root, 
			const std::vector<std::shared_ptr<const lisp_object> > tail) : 
			IMeta_inherit(meta), cnt(cnt), shift(shift), root(root), tail(tail) {};
};

class TransientVector : virtual public AFn, virtual public ITransientVector, virtual public Counted {
	public:
		TransientVector(std::shared_ptr<const LVector> v): cnt(v->cnt), shift(v->shift),
			root(editableRoot(v->root)), tail(v->tail) {};
		TransientVector(size_t cnt, size_t shift, std::shared_ptr<Node> root,
			std::vector<std::shared_ptr<const lisp_object> > tail) :
			cnt(cnt), shift(shift), root(root), tail(tail) {};
		virtual std::string toString(void) const { return "";};
		virtual size_t count(void) const {ensureEditable(); return cnt;};
		virtual std::shared_ptr<const lisp_object>nth(size_t i)const;
		// virtual bool containsKey(const std::shared_ptr<const lisp_object>) const;
		std::shared_ptr<ITransientCollection> conj(const std::shared_ptr<const lisp_object>);
		std::shared_ptr<const ICollection> persistent(void);

	private:
		size_t cnt;
		size_t shift;
		std::shared_ptr<Node> root;
		std::vector<std::shared_ptr<const lisp_object> > tail;

		static std::shared_ptr<Node> editableRoot(const std::shared_ptr<const Node> node);
		static std::vector<std::shared_ptr<const lisp_object> > editableTail(std::vector<std::shared_ptr<const lisp_object> >);
		std::vector<std::shared_ptr<const lisp_object> > arrayFor(size_t i) const;
		static std::shared_ptr<Node> newPath(size_t id, size_t level, std::shared_ptr<Node> node);
		std::shared_ptr<Node> pushTail(size_t level, std::shared_ptr<Node> parent, std::shared_ptr<Node> tailnode);
		void ensureEditable(void) const;
		std::shared_ptr<Node> ensureEditable(std::shared_ptr<Node> node) const;
		size_t tailoff(void) const;
};


#endif /* VECTOR_HPP */
