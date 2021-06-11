#ifndef LIST_HPP
#define LIST_HPP

#include "Interfaces.hpp"

#include <vector>

#include "ASeq.hpp"
#include "Map.hpp"

class List : public ASeq {
	public:
		List(std::shared_ptr<const lisp_object> first) : _first(first), _rest(NULL), _count(1) {};
		List(std::shared_ptr<const IMap> meta, std::shared_ptr<const lisp_object> first, std::shared_ptr<const ISeq> rest, size_t count) :
			ASeq(meta), _first(first), _rest(rest), _count(count) {};
		List(std::vector<std::shared_ptr<const lisp_object> >& entries) :
			_first(entries[0]), _rest(createRest(entries)), _count(entries.size()) {};
		virtual std::shared_ptr<const lisp_object> first(void) const;
		virtual std::shared_ptr<const ISeq> next(void) const;
		virtual size_t count(void) const;

		static const std::shared_ptr<const ISeq> Empty;
	private:
		virtual std::shared_ptr<const ISeq> cons_impl(std::shared_ptr<const lisp_object> first) const;
		virtual std::shared_ptr<const ASeq> with_meta_impl(std::shared_ptr<const IMap>) const;
		static std::shared_ptr<const ISeq>createRest(std::vector<std::shared_ptr<const lisp_object> >& entries);

		const std::shared_ptr<const lisp_object> _first;
    	const std::shared_ptr<const ISeq> _rest;
    	const size_t _count;
};

#endif /* LIST_HPP */
