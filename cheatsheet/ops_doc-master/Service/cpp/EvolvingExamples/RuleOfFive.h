#include <vector>
#include <string>
#include <iostream>

using std::vector;
using std::string;
using std::cout;
using std::endl;

class ROF
{
public:
  ROF() { cout << "\tROF()" << endl; }
  ROF(string name) : m_Name(name) { cout << "\tROF(string)" << endl; }
  ROF(const ROF& anotherRof) : m_Name(anotherRof.m_Name) { cout << "\tROF(const ROF&)" << endl; }
  ROF(ROF&& anotherRof) : m_Name(std::move(anotherRof.m_Name)) { cout << "\tROF(ROF&&)" << endl; }
  ROF& operator=(ROF& anotherRof) { cout << "\t=(ROF&)" << endl; this->m_Name = anotherRof.m_Name; return *this; }
  ROF& operator=(ROF&& anotherRof) { cout << "\t=(ROF&&)" << endl; this->m_Name = std::move(anotherRof.m_Name); return *this; }
  ~ROF() { cout << "\t~ROF()" << endl; }

  void SetName(const string& newName) { this->m_Name = newName; }
  const string GetName() { return this->m_Name; }

private:
  string m_Name{ "DEFAULT" };
};

void RuleOfFive();
