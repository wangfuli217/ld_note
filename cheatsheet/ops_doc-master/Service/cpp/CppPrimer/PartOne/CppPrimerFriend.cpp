#include "stdafx.h"
#include "CppPrimerFriend.h"


CppPrimerFriend::CppPrimerFriend()
{
}


CppPrimerFriend::~CppPrimerFriend()
{
}

void CppPrimerFriend::useCppPrimerPrivate(const CppPrimer &insCppPrimer)
{
    // CppPrimerFriend是CppPrimer的友元类，所以可以访问其private成员
    cout << "In CppPrimerFriend, CppPrimer.arithType_bool: " << insCppPrimer.arithType_bool << endl;
}
