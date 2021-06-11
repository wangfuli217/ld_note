#include "TheLib.hpp"
#include <iostream>
#include <string_view>
using namespace std::string_view_literals;

sstd::TheLib::TheLib(){
}

void sstd::TheLib::printHellowWorld(){
    std::cout << "Hellow World!"sv <<std::endl;
}
