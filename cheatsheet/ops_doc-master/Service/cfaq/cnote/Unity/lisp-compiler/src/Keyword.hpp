#ifndef KEYWORD_HPP
#define KEYWORD_HPP

#include "Interfaces.hpp"

#include <map>
#include <string>

#include "Symbol.hpp"

class Keyword : public Named, public Comparable /* IFn, IHashEq */ {
	public:
		virtual std::string toString(void) const;
		virtual std::string getName() const;
		virtual std::string getNamespace() const;
		virtual int compare(std::shared_ptr<const lisp_object> o) const;

		static std::shared_ptr<Keyword> intern(std::shared_ptr<const Symbol> sym);
		static std::shared_ptr<Keyword> intern(std::string nsname);
		static std::shared_ptr<Keyword> intern(std::string ns, std::string name);
		static std::shared_ptr<Keyword> find(std::shared_ptr<const Symbol> sym);
		static std::shared_ptr<Keyword> find(std::string nsname);
		static std::shared_ptr<Keyword> find(std::string ns, std::string name);

		const std::shared_ptr<const Symbol> sym;
	private:
		static std::map<std::shared_ptr<const Symbol>, std::weak_ptr<Keyword> > table;
		Keyword(std::shared_ptr<const Symbol> sym) : sym(sym) {};
};

#endif /* KEYWORD_HPP */
