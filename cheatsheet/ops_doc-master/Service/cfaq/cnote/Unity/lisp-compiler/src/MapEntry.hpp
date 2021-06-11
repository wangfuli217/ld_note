#ifndef MAPENTRY_HPP
#define MAPENTRY_HPP

#include "Interfaces.hpp"

#include "AVector.hpp"

class MapEntry : public IMapEntry, public AVector {
	public:
		MapEntry(std::shared_ptr<const lisp_object> key, const std::shared_ptr<const lisp_object> val) :
			_key(key),_val(val) {};
		virtual std::shared_ptr<const lisp_object>nth(size_t i) const;
		virtual std::shared_ptr<const IStack> pop(void) const;
		virtual std::shared_ptr<const lisp_object> key(void) const;
		virtual std::shared_ptr<const lisp_object> val(void) const;
		virtual size_t count(void) const;

		static std::shared_ptr<const MapEntry> create(std::shared_ptr<const lisp_object>, std::shared_ptr<const lisp_object>);
	private:
		const std::shared_ptr<const lisp_object> _key;
		const std::shared_ptr<const lisp_object> _val;

		std::shared_ptr<const AVector> asVector() const;
		virtual std::shared_ptr<const AVector> cons_impl(std::shared_ptr<const lisp_object>) const;
		virtual std::shared_ptr<const AVector> empty_impl(void) const;
		virtual std::shared_ptr<const AVector> assocN_impl(size_t, const std::shared_ptr<const lisp_object>) const;
};

#endif /* MAPENTRY_HPP */
