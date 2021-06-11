/* macro_example.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <assert.h>
#include <stdlib.h>

#define NUM_REGISTERS  8
#define INCR          16
#define DECR          20
#define INVERT        22

int* registers;

void execute_unary( int opcode, int reg )
{
   assert(0 <= reg && reg < NUM_REGISTERS);

   if (opcode == INCR)
       ++registers[reg];
   else if (opcode == DECR)
       --registers[reg];
   else if (opcode == INVERT)
       registers[reg] = ~registers[reg];
   else
       assert(0); /* illegal unary opcode */
}

int main()
{
    registers = new int[NUM_REGISTERS];

    execute_unary(INCR, 0);
    execute_unary(DECR, 0);
    execute_unary(INVERT, 0);

    delete [] registers;
}
