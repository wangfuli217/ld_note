#include "ScriptTypes.h"


ProgramInstance::ProgramInstance() {
   sleeping = false;
   dead = false;
   programTemplate = NULL;
   a = 0;
   
   stack = new StackItem[STACK_LIMIT];
   activationStack = new Activation[MAX_RECURSION_DEPTH];
}

ProgramInstance::~ProgramInstance() {
  delete[] stack;
  delete[] activationStack;
}
