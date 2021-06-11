#ifndef READER_HPP
#define READER_HPP

#include "Interfaces.hpp"

#include "LineNumberIStream.hpp"

std::shared_ptr<const lisp_object> read(LineNumberIStream *input, bool EOF_is_error, char return_on);

#endif /* READER_HPP */
