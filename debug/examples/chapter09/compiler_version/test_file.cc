/* test_file.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <iostream>
struct B { virtual int foo(); };
struct D: public B { virtual int foo(); };
void test() {
  std::string S("abc");    // std::string::string(...)
  std::string S2(S);       // ditto
  int* a = new int[4];     // operator new
  delete [] a;             // operator delete[] (typo in Book example)  
  D* d1 = new D;
  B* b = d1;
  D* d2 = dynamic_cast<D*>(b); // dynamic_cast
  b = d2;
}
