/* main.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include "nodebug.h"
#include <string.h>
	
int size(const char* S) {
    return strlen(S); 
}
	
int main(int argc, char* argv[]) {
    return F (2,          /* A */  
              "AABBCCDD", /* B */
              argv[1]   );/* C */
}
