/* myfile.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <iostream>
#include <string>
#include <vector>

using namespace std;

class some_class {
public:
    string name;
    some_class(const char *s) : name(s) {}
};

vector<some_class> crowd;

some_class * find(char *name)
{
    unsigned i;
    for(i=0; i<crowd.size(); i++)
	if(crowd[i].name == name)
	    return &(crowd[i]);
    return 0;
}

void f()
{
    some_class *P, *Q;

    if (P=find("intelligent lifeform"))
        cout << "We found an intelligent lifeform" << endl;
    if (Q=find("mouse"))
        cout << "We found a mouse" << endl;

    if (P=Q) {
        cout << "They are the same" << endl;
    } else {
      cout << "They are different" << endl;
    }
}

int main()
{
    some_class a("mouse"), b("intelligentlifeform"), c("artur");
    crowd.push_back(a);
    crowd.push_back(b);
    crowd.push_back(c);

    f();
    return 0;
}
