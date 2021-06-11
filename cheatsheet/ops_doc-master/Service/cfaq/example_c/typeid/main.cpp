#include <stdio.h>
#include <stdlib.h>
#include <typeinfo>
#include <iostream>

using namespace std;

#define t(v) typeid(v).name()
#define pt(v) printf("type of "#v": %s addr: 0x%p\n", t(v), v)
#define __SEP__ printf("**************************************\n")

int main(int argc, char **argv)
{
	int i;
	int* p;
	
	int a[2][3];
    int b[1][2][3];
    int* c[10];
	
	int*** ppp;
	
	printf("type of i: %s\n", typeid(i).name());
	printf("type of p: %s\n", typeid(p).name());
	printf("type of int: %s\n", typeid(int).name());
	printf("type of new char[2][3]: %s\n", typeid(new char[2][3]).name());
	printf("type of a: %s\n", t(a));
	printf("type of *a: %s\n", t(*a));
	printf("type of &a: %s\n", t(&a));
	
	pt(a);
	pt(ppp);
	pt('a');
	pt(&a);
    pt(a[0]); // char [3]
    pt(&a[0]);
	
	__SEP__;
	pt(&b); // char(*)[1][2][3]
	pt(b[0]);
    pt(&b[0]);
    pt(b);
    pt(b + 0);
    pt(b + 1);
    pt(*(b + 0));
    pt(*(b + 0) + 0);
    pt(*(*(b + 0) + 0));
    pt(*(*(b + 0) + 0) + 0);
    pt(*(*(*(b + 0) + 0) + 0));
    pt(**b);
    pt(***b);
    pt(&b[0]);
    pt(&b[0][0]);
	
	__SEP__;
    pt(&c);
    pt(&c[0]);
    pt(c + 0);
    pt(c);
	
	return 0;
}
