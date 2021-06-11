#include "Bool.hpp"

std::string lisp_bool::toString(void) const {
	if(tf)
		return "true";
	return "false";
}

const std::shared_ptr<const lisp_bool> T = std::make_shared<const lisp_bool>(true);
const std::shared_ptr<const lisp_bool> F = std::make_shared<const lisp_bool>(false);
