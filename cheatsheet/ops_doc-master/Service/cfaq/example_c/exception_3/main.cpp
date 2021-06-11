// bad_exception example
#include <iostream>       // std::cerr
#include <exception>      // std::bad_exception, std::set_unexpected
#include <stdlib.h>

void 
myunexpected () 
{
    std::cerr << "unexpected handler called\n";
    throw; // 重新throw当前异常，如果异常不在函数的规范 bas_exception 将被throw
}

void 
myfunction () throw (int, std::bad_exception) 
{
    throw 'x'; // throws char (not in exception-specification)
}

int 
main (void) 
{
    std::set_unexpected(myunexpected);
    
    try {
        myfunction();
    } catch (int) { 
        std::cerr << "caught int\n"; 
    } catch (std::bad_exception be) { 
        std::cerr << "caught bad_exception\n"; 
    } catch (...) { 
        std::cerr << "caught some other exception\n"; 
    }
    
    system("pause");
    return 0;
}