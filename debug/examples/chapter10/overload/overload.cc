/* overload.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

class C {
public:
    C(int a)          : n(a) {}
    int foo(int a)           {return n=a;}
    int foo() const          {return n;}
    int foo(char c, bool b)  {return n+=b+c;}
    C& operator=(const C& r) {n=r.foo(); return *this; }
private:
    int n;
};

int main(int argc, char* argv[]) {
   C ca(0);
   C cb(1);
   ca.foo(-23);
   cb=ca;
   return cb.foo('A',false);
}
