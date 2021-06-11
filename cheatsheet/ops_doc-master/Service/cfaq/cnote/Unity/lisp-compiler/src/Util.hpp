#include "Interfaces.hpp"

std::string toString(const std::shared_ptr<const lisp_object> o);

std::shared_ptr<const lisp_object> ret1(std::shared_ptr<const lisp_object> ret, std::shared_ptr<const lisp_object>);

std::shared_ptr<const ISeq> ret1(std::shared_ptr<const ISeq> ret, std::shared_ptr<const lisp_object>);

bool equiv(std::shared_ptr<const lisp_object> x, std::shared_ptr<const lisp_object> y);

size_t hash(std::shared_ptr<const lisp_object> o);

size_t hashEq(std::shared_ptr<const lisp_object>);

std::shared_ptr<const ISeq> seq(std::shared_ptr<const lisp_object>);
