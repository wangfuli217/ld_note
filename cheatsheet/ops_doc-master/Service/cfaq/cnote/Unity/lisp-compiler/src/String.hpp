#ifndef STRING_HPP
#define STRING_HPP

#include "Interfaces.hpp"

class Char : public lisp_object {
	public:
		Char(char c) : s(&c, 1) {};
		virtual std::string toString(void) const {return s;};
	private:
		const std::string s;
};

class lisp_string : public lisp_object {
	public:
		lisp_string(const std::string& s) : s(s) {};
		virtual std::string toString(void) const {return s;};
	private:
		const std::string s;
};

#endif /* STRING_HPP */
