#include "List.hpp"

class EmptyList : public ISeq_inherit<ISeq> {
	public:
		EmptyList(void) {};
		virtual std::string toString(void) const {return "()";};
		virtual std::shared_ptr<const ISeq> seq(void) const {
			return List::Empty;
		};
		virtual size_t count(void) const {return 0;};
		virtual std::shared_ptr<const lisp_object> first(void) const {return NULL;};
		virtual std::shared_ptr<const ISeq> next(void) const {return NULL;};
		virtual std::shared_ptr<const ISeq> more(void) const {
			return List::Empty;
		};
	private:
		virtual std::shared_ptr<const ISeq> cons_impl(std::shared_ptr<const lisp_object> first) const {
			return std::make_shared<List>(first);
		};
		virtual std::shared_ptr<const ISeq> empty_impl(void) const {return List::Empty;};
};

const std::shared_ptr<const ISeq> List::Empty = std::make_shared<const EmptyList>();
std::shared_ptr<const lisp_object> List::first(void) const {
	return _first;
}

std::shared_ptr<const ISeq> List::next(void) const {
	return _rest;
}

size_t List::count(void) const {
	return _count;
}

std::shared_ptr<const ISeq> List::cons_impl(std::shared_ptr<const lisp_object> first) const {
	return std::make_shared<const List>(_meta, first, shared_from_this(), _count + 1);
}

std::shared_ptr<const ISeq> List::createRest(std::vector<std::shared_ptr<const lisp_object> >& entries) {
	size_t i = entries.size() - 1;
	std::shared_ptr<const ISeq> ret = std::make_shared<List>(entries[i]);
	for(i--; i > 0; i--)
		ret = std::dynamic_pointer_cast<const ISeq>(ret->cons(entries[i]));
	return ret;
}

std::shared_ptr<const ASeq> List::with_meta_impl(std::shared_ptr<const IMap> meta) const {
	return std::make_shared<const List>(meta, _first, _rest, _count);
}
