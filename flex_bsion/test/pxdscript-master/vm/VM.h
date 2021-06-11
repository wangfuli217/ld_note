#ifndef VM_H
#define VM_H

#include "os.h"
#include "ScriptTypes.h"
#include "HashMap.h"

#include <stdio.h>
#include <stdlib.h>

class VM {
 private:
  char *CS;		// code segment
  HashMap<string, FUNCTIONHEADER *> *functionList;
  StackItem *constantPool;

 public:
  VM(char *code, HashMap<string, FUNCTIONHEADER *>* functionList, StackItem *cp);
  ~VM();

 void run(ProgramInstance *prog, int maxInstructions);
};


#endif
