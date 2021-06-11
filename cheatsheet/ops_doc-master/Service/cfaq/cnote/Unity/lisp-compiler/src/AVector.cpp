#include "AVector.hpp"

#include <memory>

#include "ASeq.hpp"
#include "Numbers.hpp"
#include "Util.hpp"

class VSeq : public ASeq/*, public IndexedSeq, public IReduce*/ {
	public:
		VSeq(std::shared_ptr<const IVector> v, size_t i) : v(v), i(i) {};
		VSeq(std::shared_ptr<const IMap> meta, std::shared_ptr<const IVector> v, size_t i) : ASeq(meta), v(v), i(i) {};
		virtual std::shared_ptr<const lisp_object> first(void) const;
		virtual std::shared_ptr<const ISeq> next(void) const;
	private:
		virtual std::shared_ptr<const ASeq> with_meta_impl(std::shared_ptr<const IMap>) const;

		const std::shared_ptr<const IVector> v;
		const size_t i;
};

std::shared_ptr<const ASeq> VSeq::with_meta_impl(std::shared_ptr<const IMap> meta) const {
	return std::make_shared<VSeq>(meta, v, i);
}

std::shared_ptr<const lisp_object> VSeq::first(void) const {
	return v->nth(i);
}

std::shared_ptr<const ISeq> VSeq::next(void) const {
	if(i + 1 < v->count())
		return std::make_shared<VSeq>(v, i+1);
	return NULL;
}

std::string AVector::toString(void) const {
	return ::toString(shared_from_this());
}

std::shared_ptr<const ISeq> AVector::seq(void) const {
	if(count() > 0)
		return std::make_shared<const VSeq>(std::dynamic_pointer_cast<const IVector>(shared_from_this()), 0);
	return NULL;
}

size_t AVector::length (void) const {
	return count();
}

std::shared_ptr<const lisp_object> AVector::peek(void) const {
	size_t n = count();
	if(n > 0)
		return nth(n);	// TODO should this be n-1?
	return NULL;
}

bool AVector::containsKey(const std::shared_ptr<const lisp_object> key) const {
	std::shared_ptr<const Integer> I = std::dynamic_pointer_cast<const Integer>(key);
	if(I) {
		int i = (long)*I;
		return (i >= 0) && (((unsigned int)i) < count());
	}
	return false;
}

std::shared_ptr<const AVector> AVector::assoc_impl(const std::shared_ptr<const lisp_object> key,
		const std::shared_ptr<const lisp_object> val) const {
	std::shared_ptr<const Integer> ln = std::dynamic_pointer_cast<const Integer>(key);
	if(ln)
		return assocN((long)*ln, val);
	throw std::runtime_error("Key must be integer");
}
