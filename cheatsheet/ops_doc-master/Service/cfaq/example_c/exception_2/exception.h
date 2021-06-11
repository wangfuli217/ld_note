#ifndef __EXCEPTION_H_
#define __EXCEPTION_H_


#include <exception>
#include <string>

using namespace std;

#define NOEXCEPT throw()

class my_exception_t : public exception 
{
public:
    my_exception_t(const string& err);
    virtual ~my_exception_t() NOEXCEPT;
public:
    const char* what() const NOEXCEPT;
private:
    string err_msg;
};

#endif
