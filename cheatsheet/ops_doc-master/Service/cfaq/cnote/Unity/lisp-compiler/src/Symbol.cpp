#include "Symbol.hpp"

#include <cassert>

std::string Symbol::toString(void) const {
	if(ns.size() == 0)
		return name;
	return ns + "/" + name;
}

std::string Symbol::getName() const {
	return name;
}

std::string Symbol::getNamespace() const {
	return ns;
}

std::shared_ptr<Symbol> Symbol::intern(std::string nsname) {
	size_t i = nsname.find('/');
	if(i == std::string::npos || nsname == "/")
		return std::shared_ptr<Symbol>(new Symbol("", nsname));
	return std::shared_ptr<Symbol>(new Symbol(nsname.substr(0,i), nsname.substr(i+1)));
}

std::shared_ptr<Symbol> Symbol::intern(std::string ns, std::string name) {
	return std::shared_ptr<Symbol>(new Symbol(ns, name));
}

std::shared_ptr<const Symbol> Symbol::with_meta_impl(std::shared_ptr<const IMap> meta) const {
	return std::shared_ptr<Symbol>(new Symbol(meta, ns, name));
}

bool Symbol::equals(std::shared_ptr<const lisp_object> o) const {
	if(o.get() == this)
		return true;
	std::shared_ptr<const Symbol> s = std::dynamic_pointer_cast<const Symbol>(o);
	if(s)
		return (ns == s->ns) && (name == s->name);
	return false;
}

int Symbol::compare(std::shared_ptr<const lisp_object> o) const {
	if(equals(o))
		return 0;
	std::shared_ptr<const Symbol> s = std::dynamic_pointer_cast<const Symbol>(o);
	assert(s);
	if(ns.size() == 0 && s->ns.size() > 0)
		return -1;
	if(ns.size() > 0) {
		if(s->ns.size() > 0)
			return 1;
		int nsc = ns.compare(s->ns);
		if(nsc)
			return nsc;
	}
	return name.compare(s->name);
}
