#ifndef LISP_BOOL_HPP
#define LISP_BOOL_HPP

#include "Interfaces.hpp"

#include <string>

class lisp_bool : public lisp_object {
	public:
		lisp_bool(bool tf) : tf(tf) {};
		virtual std::string toString(void) const;
	private:
		bool tf;
};

extern const std::shared_ptr<const lisp_bool> T;
extern const std::shared_ptr<const lisp_bool> F;

#endif /* LISP_BOOL_HPP */
