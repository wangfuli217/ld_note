/* max_example.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#define MAX(x,y) ((x)>(y))?(x):(y)

inline int min(int x, int y)
{
    if (x<y) return x;
    else     return y;
}

int main()
{
    int a1 = 0, a2 = 42, a3;

    a3 = MAX(a1,a2);
    a3 = min(a1,a2);

    return 0;
}
