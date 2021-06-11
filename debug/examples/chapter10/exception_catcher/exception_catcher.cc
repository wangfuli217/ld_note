/* exception_catcher.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <iostream>
void f1() {
    throw 42;
}
void f2() {
    throw "pol";
}

int main(int,char**) {
    try {
        f1();
    } catch (int E) {
        std::cout << "caught E=" << E << std::endl;
    }
    f2();
    return 0;
}
