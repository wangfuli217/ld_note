/* break_template.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <iostream>

template <class T> 
void myFunction(T value)
{ 
    std::cout << "got " << value << std::endl; 
}
 
int main(int argc, char* argv[]) {
    myFunction(100);
    myFunction('A');
    myFunction(true);
    return 0;
}
