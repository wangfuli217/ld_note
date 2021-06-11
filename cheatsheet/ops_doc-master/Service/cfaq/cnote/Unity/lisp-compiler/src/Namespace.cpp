#include "Namespace.hpp"

std::string Namespace::toString(void) const {
	return name->toString();
}

std::shared_ptr<const Namespace> Namespace::with_meta_impl(std::shared_ptr<const IMap>) const {
	return shared_from_this();
}

std::shared_ptr<Namespace> Namespace::findOrCreate(std::shared_ptr<const Symbol> name) {
	try {
		return namespaces.at(name);
	} catch(std::out_of_range) {
		std::shared_ptr<Namespace> newns = std::shared_ptr<Namespace>(new Namespace(name));
		namespaces[name] = newns;
		return newns;
	}
}

std::map<std::shared_ptr<const Symbol>, std::shared_ptr<Namespace> > Namespace::namespaces = {};
