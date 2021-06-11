/* ********************************************************** */
/* ****    Script manager                                **** */
/* ****                                                  **** */
/* ****    Implements the singleton pattern              **** */
/* ****                                                  **** */  
/* ****    Copyright: Kasper Fauerby, Peroxide 2001      **** */
/* ****               telemachos@peroxide.dk             **** */
/* ********************************************************** */
#ifndef SCRIPTMANAGER_H
#define SCRIPTMANAGER_H

#include <string>
#include "VM.h"
#include "ScriptTypes.h"
#include "List.h"
#include "HashMap.h"

using namespace std;

class ScriptManager {
 private:
  static ScriptManager* theInstance; 

  string currentScriptFile;
  VM* virtualMachine;
   
  // The templates & instances
  List<PROGRAMHEADER* > programTemplates;
  List<ProgramInstance* > runningPrograms;
  
  // Utility functions for file parsing:
  string readString(FILE* f);
  int readInt32(FILE* f);
  unsigned int readUInt32(FILE* f);
  short readUInt16(FILE* f);
  char readChar(FILE* f);
  unsigned char readByte(FILE* f);
  
  // Create a program instance from template
  ProgramInstance* instantiate(PROGRAMHEADER* programTemplate);

  // Start all those script that are 'trigger_on_init'
  void startTriggerOnInit();

  ScriptManager();
public:
  static ScriptManager* instance();

  void reset();
  void handleScripts();
  bool load(const string& fn);
  bool hasRunningPrograms() {return runningPrograms.size > 0;}
};

#endif
