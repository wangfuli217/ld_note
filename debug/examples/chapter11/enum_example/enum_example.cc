/* macro_example.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <assert.h>
#include <stdlib.h>

const int num_registers = 8;
enum UnaryOpcodeEncoding {incr=16, decr=20, invert=22};

int* registers;

void execute_unary( enum UnaryOpcodeEncoding opcode, int reg )
{
   assert(0 <= reg && reg < num_registers);

   if (opcode == incr)
       ++registers[reg];
   else if (opcode == decr)
       --registers[reg];
   else if (opcode == invert)
       registers[reg] = ~registers[reg];
   else
       assert(0); /* illegal unary opcode */
}

int main()
{
    registers = new int[num_registers];

    execute_unary(incr, 0);
    execute_unary(decr, 0);
    execute_unary(invert, 0);

    delete [] registers;
}
