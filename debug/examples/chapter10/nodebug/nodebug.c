/* nodebug.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include "nodebug.h"
	
int F (int A, const char* B, char* C) {
    int R = size(B+A);
    R *= size(C+A);
    return R;
}
