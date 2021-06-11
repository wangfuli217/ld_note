#ifndef SYMBOL_HPP
#define SYMBOL_HPP

#include "Interfaces.hpp"

#include "AFn.hpp"

class Symbol : public IMeta_inherit<Symbol>, public AFn, public Named, public Comparable {
	public:
		virtual std::string toString(void) const;
		virtual std::string getName() const;
		virtual std::string getNamespace() const;
		virtual bool equals(std::shared_ptr<const lisp_object>) const;
		virtual int compare(std::shared_ptr<const lisp_object>) const;
		bool operator< (std::shared_ptr<const lisp_object> o) {return Comparable::operator<(o);};

		static std::shared_ptr<Symbol> intern(std::string nsname);
		static std::shared_ptr<Symbol> intern(std::string ns, std::string name);
	private:
		const std::string ns;
		const std::string name;

		Symbol(std::string ns, std::string name) : ns(ns), name(name) {};
		Symbol(std::shared_ptr<const IMap> meta, std::string ns, std::string name) : IMeta_inherit(meta), ns(ns), name(name) {};

		virtual std::shared_ptr<const Symbol> with_meta_impl(std::shared_ptr<const IMap>) const;
};

#endif /* SYMBOL_HPP */
