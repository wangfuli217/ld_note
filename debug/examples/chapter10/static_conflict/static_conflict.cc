/* static_conflict.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>
#include "MyClass.h"

MyClass otherGlobal;

int main() {
	printf("otherGlobal.a[3]=%d\n", otherGlobal.a[3]);
	return 0;
}
