#include "RuleOfFive.h"

void RuleOfFive()
{
  cout << "### Should be default constructor" << endl;
  ROF rofConstFoo{};
  ROF rofConstBar{};
  cout << "rofConstFoo.name: " << rofConstFoo.GetName() << endl;
  cout << "rofConstBar.name: " << rofConstBar.GetName() << endl;

  cout << endl;

  cout << "### Should be customer constructor" << endl;
  ROF rofCustConstFoo{ "Foo" };
  ROF rofCustConstBar{ "Bar" };
  cout << "rofCustConstFoo.name: " << rofCustConstFoo.GetName() << endl;
  cout << "rofCustConstBar.name: " << rofCustConstBar.GetName() << endl;

  cout << endl;

  cout << "### Copy constructor" << endl;
  ROF rofCopyConstFoo(rofCustConstFoo);
  cout << "### Copy operator" << endl;
  rofConstFoo = rofCustConstFoo;

  cout << endl;

  cout << "### Before changing names" << endl;
  cout << "rofCustConstFoo.name: " << rofCustConstFoo.GetName() << endl;
  cout << "rofCopyConstFoo.name: " << rofCopyConstFoo.GetName() << endl;
  cout << "rofConstFoo.name: " << rofConstFoo.GetName() << endl;
  cout << "### After changing names" << endl;
  rofCopyConstFoo.SetName("rofCopyConstFoo");
  rofConstFoo.SetName("rofConstFoo");
  cout << "rofCustConstFoo.name: " << rofCustConstFoo.GetName() << endl;
  cout << "rofCopyConstFoo.name: " << rofCopyConstFoo.GetName() << endl;
  cout << "rofConstFoo.name: " << rofConstFoo.GetName() << endl;

  cout << endl;

  cout << "### Move constructor" << endl;
  ROF rofMoveConstBar(std::move(rofCustConstBar));
  cout << "### Move operator" << endl;
  rofConstBar = std::move(rofCustConstBar);

  cout << endl;

  cout << "### Before changing names" << endl;
  cout << "rofCustConstBar.name: " << rofCustConstBar.GetName() << endl;
  cout << "rofMoveConstBar.name: " << rofMoveConstBar.GetName() << endl;
  cout << "rofConstBar.name: " << rofConstBar.GetName() << endl;
  cout << "### After changing names" << endl;
  rofMoveConstBar.SetName("rofMoveConstBar");
  rofConstBar.SetName("rofConstBar");
  cout << "rofCustConstBar.name: " << rofCustConstBar.GetName() << endl;
  cout << "rofMoveConstBar.name: " << rofMoveConstBar.GetName() << endl;
  cout << "rofConstBar.name: " << rofConstBar.GetName() << endl;
}
