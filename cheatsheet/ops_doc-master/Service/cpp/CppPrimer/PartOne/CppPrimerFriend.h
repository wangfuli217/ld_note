#pragma once

#include "CppPrimerBasic.h"
#include <iostream>
#include <string>

using std::cout;
using std::endl;

class CppPrimerFriend
{
    // 其他类的成员函数作为友元
    friend void CppPrimer::toBeFriendOfCppPrimerFriend(CppPrimerFriend insCppPrimerFriend);

public:
    CppPrimerFriend();
    ~CppPrimerFriend();

    void useCppPrimerPrivate(const CppPrimer &insCppPrimer);

private:
    std::string privateStr{ "Hello, CppPrimerFriend!" };
};

