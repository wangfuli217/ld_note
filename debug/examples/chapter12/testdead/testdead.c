/* testdead.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

/* program entry point */
int main() {
    int v[16];
    int i;

    for(i=0; i<16; i++) {
	if(i > 8) {
	    v[i] = i;
	    if(i <= 8) {
	        v[i] = -i;
            }
	}
    }
    return 0;
}
