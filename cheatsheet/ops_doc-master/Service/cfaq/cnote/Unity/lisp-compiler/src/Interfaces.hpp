#ifndef INTERFACES_HPP
#define INTERFACES_HPP

#include <memory>
#include <string>

class IMap;
class ISeq;

class lisp_object {
	public:
		virtual std::string toString(void) const = 0;
		virtual std::string toString(void) {return ((const lisp_object*)this)->toString();};
		// virtual bool operator==(const lisp_object&) const = 0;	// TODO
		virtual bool equals(std::shared_ptr<const lisp_object> o) const {return o.get() == this;};
	    bool operator==(std::shared_ptr<const lisp_object> o) const {return equals(o);};
	    // lisp_object& operator=(lisp_object&&) = delete;
		virtual size_t hashCode() const {return std::hash<const lisp_object*>()(this);};	// TODO
};

class Reversible {
	public:
		// virtual std::shared_ptr<const ISeq> rseq(void) const = 0;	// TODO
};

class Associative2 {
	public:
		// virtual const IMapEntry& entryAt(const lisp_object&) const = 0;	// TODO
		//	This is breaking EmptyMap.  It should be added back in later.	// TODO
};

class IMeta : public virtual lisp_object {
	public:
		const std::shared_ptr<const IMap> meta(void) const {return _meta;};
		std::shared_ptr<const IMeta> with_meta(std::shared_ptr<const IMap>) const {
			throw std::runtime_error("Unimplemented");
		};
	protected:
		std::shared_ptr<const IMap> _meta;
		IMeta(const std::shared_ptr<const IMap> meta) : _meta(meta) {};
		IMeta(void) : _meta(NULL) {};
};
template <class Derived, class ...Bases>
class IMeta_inherit : public virtual IMeta, public Bases... {
	public:
		std::shared_ptr<const Derived> with_meta(std::shared_ptr<const IMap> meta) const {
			return with_meta_impl(meta);
		};
	protected:
		IMeta_inherit() : IMeta() {};
		IMeta_inherit(const std::shared_ptr<const IMap> meta) : IMeta(meta) {};
		virtual std::shared_ptr<const Derived> with_meta_impl(std::shared_ptr<const IMap> meta) const = 0;
};

class Seqable : public virtual lisp_object {
	public:
		virtual std::shared_ptr<const ISeq> seq(void) const = 0;
	protected:
		Seqable(void) {};
};

class Counted : public virtual lisp_object {
	public:
		virtual size_t count(void) const = 0;
};

class ILookup : public virtual lisp_object {
	public:
		// virtual std::shared_ptr<const lisp_object> valAt(std::shared_ptr<const lisp_object> key) const = 0;			// TODO
		// virtual std::shared_ptr<const lisp_object> valAt(std::shared_ptr<const lisp_object> key,						// TODO
		//                                                  std::shared_ptr<const lisp_object> NotFound) const = 0;		// TODO
};

class IMapEntry : public virtual lisp_object {
	public:
		virtual std::shared_ptr<const lisp_object> key(void) const = 0;
		virtual std::shared_ptr<const lisp_object> val(void) const = 0;
};

#define MAX_POSITIONAL_ARITY 5
class IFn : public virtual lisp_object {
	public:
		virtual std::shared_ptr<const lisp_object> invoke() const = 0;
		virtual std::shared_ptr<const lisp_object> invoke(std::shared_ptr<const lisp_object>) const = 0;
		virtual std::shared_ptr<const lisp_object> invoke(std::shared_ptr<const lisp_object>,
				std::shared_ptr<const lisp_object>) const = 0;
		virtual std::shared_ptr<const lisp_object> invoke(std::shared_ptr<const lisp_object>,
				std::shared_ptr<const lisp_object>, std::shared_ptr<const lisp_object>) const = 0;
		virtual std::shared_ptr<const lisp_object> invoke(std::shared_ptr<const lisp_object>,
				std::shared_ptr<const lisp_object>, std::shared_ptr<const lisp_object>, std::shared_ptr<const lisp_object>) const = 0;
		virtual std::shared_ptr<const lisp_object> invoke(std::shared_ptr<const lisp_object>,
				std::shared_ptr<const lisp_object>, std::shared_ptr<const lisp_object>,
				std::shared_ptr<const lisp_object>, std::shared_ptr<const lisp_object>) const = 0;
		// Clojure extends this out to 20 args, plus a variadic.  This should be sufficient.
		virtual std::shared_ptr<const lisp_object> applyTo(std::shared_ptr<const ISeq>) const = 0;
};

class IReference {
	public:
		// virtual std::shared_ptr<const IMap> alterMeta(IFn alter, ISeq args) = 0;		// TODO
		virtual std::shared_ptr<const IMap> resetMeta(std::shared_ptr<const IMap> m) = 0;
};
template <class Derived, class ...Bases>
class IReference_inherit : public IReference, public virtual IMeta_inherit<Derived>, Bases... {
	protected:
		IReference_inherit() {};
		IReference_inherit(std::shared_ptr<const IMap> meta) : IMeta_inherit<Derived>(meta) {};
};

class Named {
	public:
		virtual std::string getName() const = 0;
		virtual std::string getNamespace() const = 0;
};

class Comparable {
	public:
		virtual int compare(std::shared_ptr<const lisp_object> o) const = 0;
		bool operator< (std::shared_ptr<const lisp_object> o) {return compare(o) <  0;};
		bool operator<=(std::shared_ptr<const lisp_object> o) {return compare(o) <= 0;};
		bool operator> (std::shared_ptr<const lisp_object> o) {return compare(o) >  0;};
		bool operator>=(std::shared_ptr<const lisp_object> o) {return compare(o) >= 0;};
};

class ICollection : public Seqable, public virtual Counted {
	public:
		std::shared_ptr<const ICollection> cons(std::shared_ptr<const lisp_object>) const {
			throw std::runtime_error("Unimplemented");
		};
		std::shared_ptr<const ICollection> empty(void) const {
			throw std::runtime_error("Unimplemented");
		};
		virtual bool equiv(std::shared_ptr<const lisp_object>&) const {return false;}; // TODO = 0;
	protected:
		ICollection(void) {};
};
template <class Derived, class ...Bases>
class ICollection_inherit : public virtual ICollection, public Bases... {
	public:
		std::shared_ptr<const Derived> cons(std::shared_ptr<const lisp_object> o) const {
			return cons_impl(o);
		};
		std::shared_ptr<const Derived> empty(void) const {
			return empty_impl();
		};
	private:
		virtual std::shared_ptr<const Derived> cons_impl(std::shared_ptr<const lisp_object>) const = 0;
		virtual std::shared_ptr<const Derived> empty_impl(void) const = 0;
};

class IStack : public virtual ICollection {
	public:
		virtual std::shared_ptr<const lisp_object> peek(void) const = 0;
		virtual std::shared_ptr<const IStack> pop(void) const = 0;
};
template <class Derived, class ...Bases>
class IStack_inherit : public IStack, public virtual ICollection_inherit<Derived, Bases...> {
};

class Indexed : public virtual Counted {
	public:
		virtual std::shared_ptr<const lisp_object>nth(size_t i) const = 0;
		// virtual std::shared_ptr<const lisp_object>nth(size_t i, std::shared_ptr<const lisp_object> NotFound)const = 0;	// TODO
};

class ISeq : virtual public ICollection_inherit<ISeq> {
	public:
		virtual std::shared_ptr<const lisp_object> first(void) const = 0;
		virtual std::shared_ptr<const ISeq> more(void) const = 0;
		virtual std::shared_ptr<const ISeq> next(void) const = 0;
	protected:
		ISeq(void) {};
};
template <class Derived, class ...Bases>
class ISeq_inherit : virtual public ICollection_inherit<Derived, Bases...>, public ISeq {
};

class Associative : public virtual ICollection, public Associative2 {
	public:
		std::shared_ptr<const Associative> assoc(std::shared_ptr<const lisp_object>,
												 std::shared_ptr<const lisp_object>) const {
			throw std::runtime_error("Unimplemented");
		};
		virtual bool containsKey(const std::shared_ptr<const lisp_object>) const = 0;
	protected:
		Associative(void) {};
};
template <class Derived, class ...Bases>
class Associative_inherit : virtual public Associative, public ICollection_inherit<Derived, Bases...> {
	public:
		std::shared_ptr<const Derived> assoc(std::shared_ptr<const lisp_object> key,
											 std::shared_ptr<const lisp_object> val) const {
			return assoc_impl(key, val);
		};
	private:
		virtual std::shared_ptr<const Derived> assoc_impl(std::shared_ptr<const lisp_object>,
														  std::shared_ptr<const lisp_object>) const = 0;
};

class IVector : public Reversible, public IStack, public virtual Associative, public Indexed {
	public:
		virtual size_t length(void) const = 0;
		std::shared_ptr<const IVector> assocN(size_t, const std::shared_ptr<const lisp_object>) const {
			throw std::runtime_error("Unimplemented");
		};
};
template <class Derived, class ...Bases>
class IVector_inherit : public IVector, public Associative_inherit<Derived>, public Bases... {
	public:
		std::shared_ptr<const Derived> assocN(size_t i, const std::shared_ptr<const lisp_object> o) const {
			return assocN_impl(i, o);
		};
	private:
		virtual std::shared_ptr<const Derived> assocN_impl(size_t, const std::shared_ptr<const lisp_object>) const = 0;
};

class IMap : public virtual Associative {
	public:
		virtual std::shared_ptr<const IMap> without(const std::shared_ptr<const lisp_object>) const = 0;	// Covariance	// TODO
		// virtual std::shared_ptr<const IMap> assocEx(std::shared_ptr<const lisp_object>,									// TODO
		//											   std::shared_ptr<const lisp_object>) const = 0;		// Covariance	// TODO
	protected:
		IMap(void) {};
};
template <class Derived, class ...Bases>
class IMap_inherit : public IMap, public Associative_inherit<Derived, Bases...> {
};

class IDeref {
	public:
		virtual std::shared_ptr<const lisp_object> deref() = 0;
};

class IRef : public IDeref {
	public:
		virtual void setValidator(std::shared_ptr<const IFn>) = 0;
		virtual std::shared_ptr<const IFn> getValidator() = 0;
		virtual std::shared_ptr<const IMap> getWatches() = 0;
		virtual std::shared_ptr<IRef> addWatch(std::shared_ptr<const lisp_object>, std::shared_ptr<const IFn>) = 0;		// Covariance	// TODO
		virtual std::shared_ptr<IRef> removeWatch(std::shared_ptr<const lisp_object>) = 0;		// Covariance			// TODO
};

class Settable {
	public:
		virtual std::shared_ptr<const lisp_object> doSet(std::shared_ptr<const lisp_object>) const = 0;
		virtual std::shared_ptr<const lisp_object> doReset(std::shared_ptr<const lisp_object>) const = 0;
};


class ITransientCollection : public virtual lisp_object {
	public:
		virtual std::shared_ptr<ITransientCollection> conj(std::shared_ptr<const lisp_object>) = 0;	// Covariance		// TODO
		virtual std::shared_ptr<const ICollection> persistent(void) = 0;
};

class IEditableCollection {
	public:
		virtual std::shared_ptr<ITransientCollection> asTransient() const = 0;
};

class ITransientAssociative : public ITransientCollection, public ILookup, public Associative2 {
	public:
		std::shared_ptr<ITransientAssociative> assoc(std::shared_ptr<const lisp_object>,
													 std::shared_ptr<const lisp_object>) {
			throw std::runtime_error("Unimplemented");
		};
};
template <class Derived, class ...Bases>
class ITransientAssociative_inherit : virtual public ITransientAssociative, public Bases... {
	public:
		std::shared_ptr<Derived> assoc(std::shared_ptr<const lisp_object> key,
									   std::shared_ptr<const lisp_object> val) {
			return assoc_impl(key, val);
		};
	private:
		ITransientAssociative_inherit() = default;
		friend Derived;
		virtual std::shared_ptr<Derived> assoc_impl(std::shared_ptr<const lisp_object>, std::shared_ptr<const lisp_object>) = 0;
};

class ITransientMap : public virtual ITransientAssociative, public Counted {
	public:
		virtual std::shared_ptr<ITransientMap> without(std::shared_ptr<const lisp_object> key) = 0;
};

class ITransientVector : public ITransientAssociative, public Indexed {
	public:
		// virtual std::shared_ptr<ITransientVector> assocN(size_t n, std::shared_ptr<const lisp_object> val) = 0;	// Covariance	// TODO
		// virtual std::shared_ptr<ITransientVector> pop(void) = 0;		// Covariance								// TODO
};

#endif /* INTERFACES_HPP */
