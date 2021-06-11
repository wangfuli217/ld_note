#ifndef AREFERENCE_HPP
#define AREFERENCE_HPP

#include "Interfaces.hpp"

class AReference : public IReference, public virtual IMeta {
	public:
		virtual std::shared_ptr<const IMap> resetMeta(std::shared_ptr<const IMap> m) {IMeta::_meta = m; return m;};
	protected:
		AReference() {};
};

#endif /* AREFERENCE_HPP */
