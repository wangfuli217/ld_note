
#include <charconv>

int test(){
    long double varAns{0};
    std::from_chars("1.0","1.0"+1,varAns);
    return 0;
}
