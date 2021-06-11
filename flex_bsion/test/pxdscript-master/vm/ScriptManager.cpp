#include "ScriptManager.h"
#include "Logger.h"
#include "os.h"
#include "memory.h" // strdup

// Static member
ScriptManager* ScriptManager::theInstance = NULL;


ScriptManager::ScriptManager() {
  virtualMachine = NULL;
  currentScriptFile = "";
}

ScriptManager* ScriptManager::instance() {
  if (theInstance == NULL)
    theInstance = new ScriptManager();
 
  return theInstance;
}


ProgramInstance* ScriptManager::instantiate(PROGRAMHEADER *programTemplate) {

   // Create instance and let constructor initialize basic fields
   ProgramInstance* instance = new ProgramInstance();
 
   // Set the template pointer
   instance->programTemplate = programTemplate;
 
   
   // Initialize the activation stack:
   instance->setEC(programTemplate->endCode);
   instance->setPC(programTemplate->startCode);
   instance->setSP(programTemplate->localLimit);
   instance->setBSP(0);
   instance->setNumParams(0);
  
   return instance;
}



void ScriptManager::handleScripts() {

 for (int i=0; i<runningPrograms.size; i++) {
    ProgramInstance *prog = runningPrograms[i];
    
    // Check if have to wake sleeping program up
    if (prog->sleeping) {
       if (prog->wakeuptime > 0 && GetTimeMsec() >= prog->wakeuptime)
         prog->sleeping = false;	
    }
  
    // If running and not sleeping we hand control to the VM
    if (!prog->sleeping) {
       // Run the program: (maximum 128 instructions per frame per program)
       virtualMachine->run(prog, 128);
    } 

    // Check if program has died
    if (prog->dead) {
       // Remove from list:
       runningPrograms.Remove(prog);
       
       // delete it
       delete prog;
    }   
 }
}

// Reset the manager.
void ScriptManager::reset() {
  // Kill all active scripts:
  for (int i=0; i<runningPrograms.size; i++) 
    delete runningPrograms[i];
  runningPrograms.Clear();
}



string ScriptManager::readString(FILE *f) {
	// strings are stored in a zero-terminated way so for easy loading we use a growable array (List)
	List<char> res;
	char c;
	do {
		fread(&c, sizeof(char), 1, f);
		res.Add(c);
	} while (c != 0);
	
	string strRes = string(res.element);
	return strRes;
}

int ScriptManager::readInt32(FILE *f) {
  int res;
	fread(&res, sizeof(int), 1, f);
	return res;
}

unsigned int ScriptManager::readUInt32(FILE *f) {
  unsigned int res;
	fread(&res, sizeof(unsigned int), 1, f);
	return res;
}

short ScriptManager::readUInt16(FILE *f) {
	short res;
	fread(&res, sizeof(short), 1, f);
	return res;
}

char ScriptManager::readChar(FILE *f) {
	char res;
	fread(&res, sizeof(char), 1, f);
	return res;
}

unsigned char ScriptManager::readByte(FILE* f) {
	unsigned char res;
	fread(&res, sizeof(unsigned char), 1, f);
	return res;
}


void ScriptManager::startTriggerOnInit() {
  // Run through all the program templates:
  for (int i=0; i<programTemplates.size; i++) {
    if (programTemplates[i]->triggertype == trigger_on_initK) {
      ProgramInstance* newInstance = instantiate(programTemplates[i]);
      runningPrograms.Add(newInstance);
    } 
  }
  
}


bool ScriptManager::load(const string& fn) {
 
 FILE* infile = fopen(fn.c_str(),"rb");
 if (infile != NULL) {
 	 Log("Loading script file '%s'", fn.c_str());
 	 
 	 // set current file:
   currentScriptFile = fn;
 	
 	 // Some structures for the VM:
 	 char *codeSegment = NULL;  
 	 HashMap<string, FUNCTIONHEADER *> *functionList = new HashMap<string, FUNCTIONHEADER *>();
 	 StackItem *constantPool = NULL;
 	
 	 // Parse the file:
 	 unsigned char c;
   
   do {    
     // Read a top-level ID
     c = readChar(infile);
     
     if (c == FUNCTION_ID) {
       FUNCTIONHEADER *newfunc = new FUNCTIONHEADER();
        
       string funcName = readString(infile);       
       newfunc->name = strdup(funcName.c_str());
       newfunc->inputs = readByte(infile);
       newfunc->outputs = readByte(infile); 
       newfunc->localLimit = readByte(infile);  
       newfunc->stackLimit = readUInt16(infile);
       newfunc->startCode = readInt32(infile);
       newfunc->endCode = readInt32(infile);
              
       // Add to function table:
       functionList->put(funcName, newfunc);
       Log("Loaded function '%s'", newfunc->name); 
     }
     else
     if(c == PROGRAM_ID) {
       PROGRAMHEADER *newprog = new PROGRAMHEADER();
   
       // Read header
       string programName = readString(infile);   
       newprog->name = strdup(programName.c_str());
       newprog->localLimit = readByte(infile);
       newprog->stackLimit = readUInt16(infile);
       newprog->triggertype = readByte(infile);
       string triggerArg = readString(infile);
       newprog->triggerArgument = strdup(triggerArg.c_str());
       newprog->startCode = readUInt32(infile); 
       newprog->endCode = readUInt32(infile); 
               
       // Add to list of templates
       programTemplates.Add(newprog);
       Log("Loaded program '%s'", newprog->name);
     }
     else  
     if(c == CONSTANTS_ID) {
    	 // How many constants in the file?
       unsigned int numConsts = readUInt32(infile);
       Log("loading %i constants", numConsts);
      
       // Create the constant pool structure:
       constantPool = new StackItem[numConsts];
        
       // Load each constant
       for (unsigned int i=0; i<numConsts; i++) {
         // read type of constant
       	 char type = readChar(infile);
       	 
       	 // read value:
       	 switch(type) {
       	   case INT_CONST:
       	    constantPool[i].intval = readInt32(infile);
       	    Log("read constant int: %i", constantPool[i].intval);
       	    break;
       	   case ZSTRING_CONST: 
       	   	constantPool[i].strval = readString(infile);
       	   	Log("read constant str: '%s'", constantPool[i].strval.c_str());
       	    break;
       	   default:
       	    Log("ERROR - unknown constant type '%i'", type);
       	    break;
       	 } 
       } 
     }
     else 
     if(c == CODE_ID) {
       unsigned int codeSize = readUInt32(infile);
       codeSegment = new char[codeSize];
       Log("loading %i bytes of code", codeSize);
      
       // Load the bytecode into the code segment
       fread(codeSegment, sizeof(char), codeSize, infile);
     }
   } while(codeSegment == NULL); // while more to load. We know the code segment is the last part of the file..
   // close the file
   fclose(infile);
 
   // Create the VM:
   virtualMachine = new VM(codeSegment, functionList, constantPool);
   
   // Trigger those programs that are 'trigger_on_init'
   startTriggerOnInit();
   
   return true;
 }
 else {
 	 Log("ERROR - could not open script file '%s'", fn.c_str());
 	 return false;
 }
}



