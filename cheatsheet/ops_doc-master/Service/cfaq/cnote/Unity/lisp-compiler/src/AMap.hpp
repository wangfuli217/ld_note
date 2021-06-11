#ifndef AMAP_HPP
#define AMAP_HPP

#include "Interfaces.hpp"
#include "AFn.hpp"

class AMap : public AFn, public IMap_inherit<AMap> {
	public:
		virtual std::string toString(void) const;
	private:
		virtual std::shared_ptr<const AMap> cons_impl(std::shared_ptr<const lisp_object>) const;
};

class ATransientMap : /* public AFn, */public ITransientMap, public std::enable_shared_from_this<ATransientMap> {
	public:
		std::shared_ptr<ITransientCollection> conj(std::shared_ptr<const lisp_object>);
		virtual void ensureEditable() const = 0;
};

#endif /* AMAP_HPP */
