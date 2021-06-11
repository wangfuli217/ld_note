
#include <iostream>

int main(int,char **){

#if defined(HAS_CONSTEXPR)
    std::cout << "has constexpr" <<std::endl;
#else
    std::cout << "do not have constexpr"<<std::endl;
#endif

}
