/* initial_delay.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdlib.h>
#ifdef _MSC_VER
#define sleep(x) _sleep(1000*(x))
#else
#include <unistd.h>
#endif

static int ask_mice() {
static int done=0;
  while (!done)
    sleep(10);
  return 42;
}
static int pol = ask_mice();
