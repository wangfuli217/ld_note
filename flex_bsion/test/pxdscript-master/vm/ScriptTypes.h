#ifndef SCRIPTTYPES_H
#define SCRIPTTYPES_H

#include <string>
#include "opcodes.h"
#include "pxdScriptHeaders.h"

using namespace std;

const int STACK_LIMIT = 1024;
const int MAX_RECURSION_DEPTH = 1024;

class StackItem {
 public:
  int intval;
  string strval;
};


class Activation {
 public: 
  int endCode;
  int pc, bsp, sp;
  int numParams; 
};


class ProgramInstance {
  private:
     // current activation           
     int a; 
        
     // Stacks:
     StackItem *stack; 
     Activation *activationStack; 
  
  public:
     // Constructor:
     ProgramInstance();
     ~ProgramInstance();
     
     // The template for this program instance
     PROGRAMHEADER *programTemplate; 
          
     // State:
     bool sleeping;
     bool dead; 
     unsigned long wakeuptime;
      
     // utility functions to make things look nice:
     inline char *getName()                            {if (programTemplate) return programTemplate->name; return NULL;}

     inline void pushActivation()                      {a++;}
     inline void popActivation()                       {a--;}

     inline int getPC()                              {return activationStack[a].pc;}
     inline int getSP()                              {return activationStack[a].sp;}
     inline int getBSP()                             {return activationStack[a].bsp;}
     inline int getNumParams()                          {return activationStack[a].numParams;}
     inline int getEndCode()                         {return activationStack[a].endCode;}
     
     inline void addPC(int offset)                   {activationStack[a].pc += offset;}
     inline void setPC(int address)                  {activationStack[a].pc = address;}
     inline void addSP(int offset)                   {activationStack[a].sp += offset;}
     inline void setSP(int address)                  {activationStack[a].sp = address;}
     inline void setEC(int address)                  {activationStack[a].endCode = address;}
     inline void setBSP(int address)                 {activationStack[a].bsp = address;}
     inline void setNumParams(int count)             {activationStack[a].numParams = count;}
          
     inline void pop(int nr=1)                       {activationStack[a].sp -= nr;}
     inline void push()                              {activationStack[a].sp++;}
     
     // The 'push' series of functions pushes to the top of stack: (increases the 'sp' by one)
     inline void  pushInt(int i)                       {stack[++activationStack[a].sp].intval = i;}
     inline void  pushStr(string s)                    {stack[++activationStack[a].sp].strval = s;}
     inline void  pushStackItem(StackItem s)           {stack[++activationStack[a].sp] = s;}
     
      // The 'pop' series retrieves top stack element and decreases sp by one:
     inline int   popInt()                             {return stack[activationStack[a].sp--].intval;}
     inline string popStr()                             {return stack[activationStack[a].sp--].strval;}
          
     // The 'set' series sets an existing stack value
     inline void  setInt(int i, int ofs=0)             {stack[activationStack[a].sp + ofs].intval = i;}
     inline void  setStr(string s, int ofs=0)          {stack[activationStack[a].sp + ofs].strval = s;}
     inline void  setStackItem(StackItem s, int ofs=0) {stack[activationStack[a].sp + ofs] = s;}
          
     // The 'get' series retrieves an existing stack value:
     inline int   getInt(int ofs=0)                    {return stack[activationStack[a].sp + ofs].intval;}
     inline string getStr(int ofs=0)                   {return stack[activationStack[a].sp + ofs].strval;}
     inline StackItem getStackItem(int ofs=0)          {return stack[activationStack[a].sp + ofs];}
    
     // The 'getLocal' series retrieves an existing stack value:
     inline int   getLocalInt(int ofs)                 {return stack[activationStack[a].bsp + ofs].intval;}
     inline string getLocalStr(int ofs)                {return stack[activationStack[a].bsp + ofs].strval;}
         
     // The setLocal series sets an existing stack value
     inline void  setLocalInt(int i, int ofs)          {stack[activationStack[a].bsp + ofs].intval = i;}
     inline void  setLocalStr(string s, int ofs)       {stack[activationStack[a].bsp + ofs].strval = s;}
 };

#endif 

