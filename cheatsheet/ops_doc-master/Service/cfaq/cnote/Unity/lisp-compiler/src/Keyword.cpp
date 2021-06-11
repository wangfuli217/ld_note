#include "Keyword.hpp"

#include <cassert>

std::string Keyword::toString(void) const {
	return ":" + sym->toString();
}

std::string Keyword::getName() const {
	return sym->getName();
}

std::string Keyword::getNamespace() const {
	return sym->getNamespace();
}

int Keyword::compare(std::shared_ptr<const lisp_object> o) const {
	std::shared_ptr<const Keyword> s = std::dynamic_pointer_cast<const Keyword>(o);
	assert(s);
	return sym->compare(s->sym);
}

std::map<std::shared_ptr<const Symbol>, std::weak_ptr<Keyword> > Keyword::table = {};

std::shared_ptr<Keyword> Keyword::intern(std::shared_ptr<const Symbol> sym) {
	try {
		return table.at(sym).lock();
	} catch(std::out_of_range) {
		if(sym->meta())
			sym = std::dynamic_pointer_cast<const Symbol>(sym->with_meta(NULL));
		std::shared_ptr<Keyword> k = std::shared_ptr<Keyword>(new Keyword(sym));
		table[sym] = k;
		return k;
	}
}

std::shared_ptr<Keyword> Keyword::intern(std::string nsname) {
	return intern(Symbol::intern(nsname));
}

std::shared_ptr<Keyword> Keyword::intern(std::string ns, std::string name) {
	return intern(Symbol::intern(ns, name));
}

std::shared_ptr<Keyword> Keyword::find(std::shared_ptr<const Symbol> sym) {
	try {
		return table.at(sym).lock();
	} catch(std::out_of_range) {
		return NULL;
	}
}

std::shared_ptr<Keyword> Keyword::find(std::string nsname) {
	return find(Symbol::intern(nsname));
}

std::shared_ptr<Keyword> Keyword::find(std::string ns, std::string name) {
	return find(Symbol::intern(ns, name));
}
