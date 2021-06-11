#ifndef ASEQ_HPP
#define ASEQ_HPP

#include "Interfaces.hpp"

class ASeq : public IMeta_inherit<ASeq>, public ISeq_inherit<ISeq>, public std::enable_shared_from_this<ASeq> {
	public:
		virtual std::string toString(void) const;
		virtual std::shared_ptr<const ISeq> seq(void) const;
		virtual size_t count (void) const;
		virtual std::shared_ptr<const ISeq> more(void) const;

	protected:
		ASeq(const std::shared_ptr<const IMap> meta) : IMeta_inherit(meta) {};
		ASeq() : IMeta_inherit() {};

		virtual std::shared_ptr<const ISeq> cons_impl(const std::shared_ptr<const lisp_object>) const;
		virtual std::shared_ptr<const ISeq> empty_impl(void) const;
};

// bool EquivASeq(const ICollection*, const lisp_object*);
// bool EqualsASeq(const struct lisp_object_struct *x, const struct lisp_object_struct *y);
// const ISeq *seqASeq(const Seqable*);

#endif /* ASEQ_HPP */
