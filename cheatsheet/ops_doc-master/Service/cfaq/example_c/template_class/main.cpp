#include <stdio.h>
#include <iostream>
#include "template.h"
#include "psTemplate.h"
#include "B.h"

#define printf(a, b) do	{ \
		a + b;		\
	}while(0)		\

using namespace std;

int main(int argc, char **argv)
{
	CExample<int> intAdd;
	
	CExample<string> strAdd;
	
	CExample<float> floatAdd;
	
	//B<int> b;
	
	//b.Say();
	
	intAdd.Add(1, 2);
	
	strAdd.Add("hello", " world!");
	
	floatAdd.Add(1.1, 2.2);
	
	//CPSExample<int, 100> psIntAdd;
	
	//psIntAdd.Add(1, 100);
	
	
	CParial<int*, int*> cp1;
	
	int i;
	
	cin >> i;
	
	return 0;
}
