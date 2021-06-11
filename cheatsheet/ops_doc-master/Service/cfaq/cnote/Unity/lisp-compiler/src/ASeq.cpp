#include "ASeq.hpp"

#include "List.hpp"
#include "Util.hpp"

std::string ASeq::toString(void) const {
	return ::toString(shared_from_this());
}

std::shared_ptr<const ISeq> ASeq::seq(void) const {
	return shared_from_this();
}

std::shared_ptr<const ISeq> ASeq::cons_impl(const std::shared_ptr<const lisp_object> first) const {
	size_t cnt = count();
	return std::make_shared<const List>(_meta, first, shared_from_this(), cnt);
}

size_t ASeq::count (void) const {
	return 1 + next()->count();
}

std::shared_ptr<const ISeq> ASeq::empty_impl(void) const {
	return List::Empty;
}

std::shared_ptr<const ISeq> ASeq::more(void) const {
	std::shared_ptr<const ISeq> s = next();
	if(s == NULL) return List::Empty;
	return s;
}

// bool EquivASeq(const ICollection *is, const lisp_object *obj) {
// 	assert(isISeq(&is->obj));
// 	assert(is->obj.fns->ISeqFns->first != NULL);
// 	assert(is->obj.fns->ISeqFns->next != NULL);
// 
// 	if(!isISeq(obj)) return false;
// 	const ISeq *ms = obj->fns->SeqableFns->seq((const Seqable*)obj);
// 	for(const ISeq *s = (const ISeq*)is; s != NULL; s = s->obj.fns->ISeqFns->next(s), ms = ms->obj.fns->ISeqFns->next(ms)) {
// 		if(ms == NULL) return false;
// 		if(!Equiv(s->obj.fns->ISeqFns->first(s), ms->obj.fns->ISeqFns->first(ms)))
// 			return false;
// 	}
// 	return ms == NULL;
// }
// 
// bool EqualsASeq(const struct lisp_object_struct *x, const struct lisp_object_struct *y) {
// 	assert(isISeq(x));
// 	const ISeq *self = (ISeq*)x;
// 	if(!isSeqable(y))
// 		return false;
// 	for(const ISeq *s = y->fns->SeqableFns->seq((Seqable*)y); s != NULL; s = s->obj.fns->ISeqFns->next(s)) {
// 		if(self == NULL || !Equals(s->obj.fns->ISeqFns->first(s), self->obj.fns->ISeqFns->first(self)))
// 			return false;
// 		self = self->obj.fns->ISeqFns->next(self);
// 	}
// 	return self == NULL;
// }
