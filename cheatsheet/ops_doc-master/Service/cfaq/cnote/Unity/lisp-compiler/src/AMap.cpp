#include "AMap.hpp"

#include "Util.hpp"

std::string AMap::toString(void) const {
	return ::toString(shared_from_this());
}

std::shared_ptr<const AMap> AMap::cons_impl(std::shared_ptr<const lisp_object> o) const {
	std::shared_ptr<const IMapEntry> e = std::dynamic_pointer_cast<const IMapEntry>(o);
	if(e)
		return assoc(e->key(), e->val());
	std::shared_ptr<const IVector> iv = std::dynamic_pointer_cast<const IVector>(o);
	if(iv) {
		if(iv->count() != 2)
			throw std::runtime_error("Vector arg to map conj must be a pair");
		return assoc(iv->nth(0), iv->nth(1));
	}
	std::shared_ptr<const AMap> ret = std::dynamic_pointer_cast<const AMap>(shared_from_this());
	for(std::shared_ptr<const ISeq> es = ::seq(o); es != NULL; es = es->next()) {
		e = std::dynamic_pointer_cast<const IMapEntry>(es->first());
		ret = ret->assoc(e->key(), e->val());
	}
	return ret;
}

std::shared_ptr<ITransientCollection> ATransientMap::conj(std::shared_ptr<const lisp_object> o) {
	ensureEditable();
	std::shared_ptr<const IMapEntry> im = std::dynamic_pointer_cast<const IMapEntry>(o);
	if(im)
		return assoc(im->key(), im->val());
	std::shared_ptr<const IVector> iv = std::dynamic_pointer_cast<const IVector>(o);
	if(iv) {
		if(iv->count() != 2)
			throw std::runtime_error("Vector arg to map conj must be a pair");
		return assoc(iv->nth(0), iv->nth(1));
	}
	std::shared_ptr<ITransientMap> ret = shared_from_this();
	for(std::shared_ptr<const ISeq> es = ::seq(o); es != NULL; es = es->next()) {
		im = std::dynamic_pointer_cast<const IMapEntry>(es->first());
		ret = std::dynamic_pointer_cast<ITransientMap>(ret->assoc(im->key(), im->val()));
	}
	return ret;
}
