#ifndef NAMESPACE_HPP
#define NAMESPACE_HPP

#include "Interfaces.hpp"

#include <map>

#include "AReference.hpp"
#include "Symbol.hpp"

class Namespace : public AReference, public IReference_inherit<Namespace>, public std::enable_shared_from_this<Namespace> {
	public:
		const std::shared_ptr<const Symbol> name;

		virtual std::string toString(void) const;
		virtual std::shared_ptr<const IMap> resetMeta(std::shared_ptr<const IMap> m) {IMeta::_meta = m; return m;};

		static std::shared_ptr<Namespace> findOrCreate(std::shared_ptr<const Symbol> name);
	private:
		std::shared_ptr<const IMap> mappings;
		std::shared_ptr<const IMap> aliases;

		static std::map<std::shared_ptr<const Symbol>, std::shared_ptr<Namespace> > namespaces;

		Namespace(std::shared_ptr<const Symbol> name) : IReference_inherit<Namespace>(name->meta()), name(name),
			mappings(NULL), aliases(NULL) /* TODO mappings.set(RT.DEFAULT_IMPORTS); aliases.set(RT.map()); */ {};
		virtual std::shared_ptr<const Namespace> with_meta_impl(std::shared_ptr<const IMap>) const;
};

#endif /* NAMESPACE_HPP */
