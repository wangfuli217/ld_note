#include <stdio.h>
#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
 
#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#else
#include <time.h>
#endif

#ifndef _mylib_
#define _mylib_

double get_sec_since_epoch();
void hello();
void here();
void bye();

#endif
