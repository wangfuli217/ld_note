#ifndef AVECTOR_HPP
#define AVECTOR_HPP

#include "Interfaces.hpp"

#include "AFn.hpp"

class AVector : public IVector_inherit<AVector>, virtual public AFn {
	public:
		virtual std::string toString(void) const;
		virtual std::shared_ptr<const ISeq> seq(void) const;
		virtual size_t length (void) const;
		virtual std::shared_ptr<const lisp_object> peek(void) const;
		virtual bool containsKey(const std::shared_ptr<const lisp_object>) const;
	private:
		virtual std::shared_ptr<const AVector> assoc_impl(
				const std::shared_ptr<const lisp_object> key,
				const std::shared_ptr<const lisp_object> val) const;
};

#endif /* AVECTOR_HPP */
