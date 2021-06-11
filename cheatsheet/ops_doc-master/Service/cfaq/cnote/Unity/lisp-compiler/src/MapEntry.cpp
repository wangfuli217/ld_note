#include "MapEntry.hpp"

#include <exception>
#include <vector>

#include "Vector.hpp"

std::shared_ptr<const MapEntry> MapEntry::create(std::shared_ptr<const lisp_object> key, std::shared_ptr<const lisp_object> val) {
	return std::shared_ptr<const MapEntry>(new MapEntry(key, val));
}

std::shared_ptr<const AVector> MapEntry::cons_impl(std::shared_ptr<const lisp_object> o) const {
	return asVector()->cons(o);
}

std::shared_ptr<const AVector> MapEntry::empty_impl(void) const {
	return NULL;
}

std::shared_ptr<const lisp_object> MapEntry::nth(size_t i) const {
	if(i == 0)
		return _key;
	if(i == 1)
		return _val;
	throw std::out_of_range("Index to MapEntry is out of range.");
}

std::shared_ptr<const IStack> MapEntry::pop(void) const {
	std::vector<std::shared_ptr<const lisp_object> > array(1);
	array[0] = _key;
	return LVector::create(array);
}

std::shared_ptr<const AVector> MapEntry::assocN_impl(size_t i, const std::shared_ptr<const lisp_object> val) const {
	return asVector()->assocN(i, val);
}

std::shared_ptr<const lisp_object> MapEntry::key(void) const {
	return _key;
}

std::shared_ptr<const lisp_object> MapEntry::val(void) const {
	return _val;
}

size_t MapEntry::count(void) const {
	return 2;
}

std::shared_ptr<const AVector> MapEntry::asVector() const {
	std::vector<std::shared_ptr<const lisp_object> > array(2);
	array[0] = _key;
	array[1] = _val;
	return LVector::create(array);
}
