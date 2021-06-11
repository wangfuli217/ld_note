
#include <iostream>

int main(int,char **){

#if defined(HAS_FROM_CHARS_LONGDOUBLE)
    std::cout << "has from chars long double" <<std::endl;
#else
    std::cout << "do not have from chars long double"<<std::endl;
#endif

}
