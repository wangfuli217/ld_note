#include "exception.h"

my_exception_t::my_exception_t(const string& err)
{
    err_msg = err;
}

my_exception_t::~my_exception_t() NOEXCEPT
{
  
}

const char* 
my_exception_t::what() const NOEXCEPT
{
    return err_msg.c_str();
}

