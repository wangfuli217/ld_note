#pragma once
#include <string>
#include <iostream>

class AnyBase
{
public:
    AnyBase(std::string iniStr) : m_str(iniStr) {}
    virtual ~AnyBase() = default;

    inline void dispMemStr(void) { std::cout << m_str << std::endl; }

private:
    std::string m_str;
};

class AnyDerived : public AnyBase
{
public:
    AnyDerived(std::string iniStr) : AnyBase(iniStr) {}
    virtual ~AnyDerived() = default;
};

void AnyTest(void);
