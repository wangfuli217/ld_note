#include "Util.hpp"

#include <assert.h>
#include <iostream>
#include <sstream>

#include "List.hpp"
#include "Numbers.hpp"


static std::ostream &PrintObject(std::ostream &os, const std::shared_ptr<const lisp_object> obj) {
	const std::shared_ptr<const IMeta> im = std::dynamic_pointer_cast<const IMeta>(obj);
	if(im && im->meta() && im->meta()->count() > 0) {
		PrintObject(os << "#^", im->meta()) << " ";
	}

	if(obj == List::Empty) {
		os << "()";
		return os;
	}

	std::shared_ptr<const ISeq> list = std::dynamic_pointer_cast<const ISeq>(obj);
	if(list) {
		PrintObject(os << "(", list->first());
		for(list = list->next(); list != NULL; list = list->next())
			PrintObject(os << " ", list->first());
		os << ")";
		return os;
	}

	std::shared_ptr<const IMap> map = std::dynamic_pointer_cast<const IMap>(obj);
	if(map) {
		os << "{";
		for(list = map->seq(); list != NULL; list = list->next()) {
			std::shared_ptr<const IMapEntry> me = std::dynamic_pointer_cast<const IMapEntry>(list->first());
			assert(me != NULL);
			PrintObject(os, me->key());
			PrintObject(os << " ", me->val());
			if(list->next() != NULL) os << ", ";
		}
		return os << "}";
	}

	std::shared_ptr<const IVector> vec = std::dynamic_pointer_cast<const IVector>(obj);
	if(vec) {
		os << "[";
		if(vec->count() > 0)
			PrintObject(os, vec->nth(0));
		for(size_t i = 1; i < vec->count(); i++)
			PrintObject(os << " ", vec->nth(i));
		return os << "]";
	}

	return os << obj->toString();
}

std::string toString(const std::shared_ptr<const lisp_object> o) {
	    std::stringstream buffer;
		    PrintObject(buffer, o);
			    return buffer.str();
}

std::shared_ptr<const lisp_object> ret1(std::shared_ptr<const lisp_object> ret, std::shared_ptr<const lisp_object>) {
	  return ret;
}

std::shared_ptr<const ISeq> ret1(std::shared_ptr<const ISeq> ret, std::shared_ptr<const lisp_object>) {
	  return ret;
}

bool equiv(std::shared_ptr<const lisp_object> x, std::shared_ptr<const lisp_object> y) {
	if(x == y)
		return true;
	if(x) {
		std::shared_ptr<const Number> x_num = std::dynamic_pointer_cast<const Number>(x);
		if(x_num) {
			std::shared_ptr<const Number> y_num = std::dynamic_pointer_cast<const Number>(y);
			if(y_num)
				return x_num == y_num;
		} else {
			std::shared_ptr<const ICollection> x_coll = std::dynamic_pointer_cast<const ICollection>(x);
			if(x_coll)
				return x_coll->equiv(y);
			std::shared_ptr<const ICollection> y_coll = std::dynamic_pointer_cast<const ICollection>(y);
			if(y_coll)
				return y_coll->equiv(x);
		}
		return x == y;
	}
	return false;
}

size_t hash(std::shared_ptr<const lisp_object> o) {
	if(o == NULL)
		return 0;
	return o->hashCode();
}

size_t hashEq(std::shared_ptr<const lisp_object>) {
	// TODO
	return 0;
}

std::shared_ptr<const ISeq> seq(std::shared_ptr<const lisp_object>) {
	// TODO
	return NULL;
}
