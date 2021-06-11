#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "assembler.h"
#include "asmutils.h"
#include "memory.h"
#include "error.h"
#include "opcodes.h"
#include "pxdScriptHeaders.h"


/* ****************** PROTOTYPES ****************** */
void AssembleFunction();
void AssembleProgram();


/* ****************** STRUCTS ******************* */

typedef struct LABELADDRESS {
   char *label;
   unsigned int offset;
 
   struct LABELADDRESS *next;
} LABELADDRESS, LABELPLUG;	



/* ******************* GLOBALS ******************** */
unsigned int curCodeArraySize = 0; // Utility variable for the growing byte code array

// Where to add the next byte code.
unsigned int codeposition = 0;     

// Our final output file with the binary code.
FILE *emitFILE;

// The input text file with the symbolic byte code
FILE *sourceFILE;

// This is the (single) growing array of byte codes
unsigned char *bytecode = NULL;

// A linked list of unfilled "offset holes" in the code segment.
LABELPLUG *labelPlugs = NULL;

// A linked list of the labels and their corresponding offsets in the code segment.
unsigned int numLabels = 0;
LABELADDRESS *asmLabels = NULL;

// A linked list of the constants in the programs and functions
unsigned int nextconst = 0; 
unsigned int numConsts = 0;	
CONSTANT *asmConstants = NULL;

// The name of the function or program we are currently assembling.
// This is used to prefix all label names so we get truely unique names
// (remember label names are otherwise only unique within the function or
//  program in which they are used)
char *currentName = NULL;



/* *************** UTILITY FUNCTIONS ************** */

// Check that we have 'nrBytes' bytes of free space in the code segment
void checkSpace(int nrBytes) {
  unsigned char *temp = NULL;
  
  // Grow code segment if there isn't already room  
  if (codeposition+nrBytes >= curCodeArraySize) {	
    temp = (unsigned char *)Malloc(2*curCodeArraySize);
    memcpy(temp, bytecode, curCodeArraySize);
    bytecode = temp;
    curCodeArraySize *= 2;	
  }	
}


/* Add a plug to the list of label plugs at the current code position */
void addPlug(char *label) {
  LABELPLUG *plug = NULL;
        
  // Generate unique name for this label. 
  char *uniqueName = strconcat(currentName, label);
  
  plug = NEW(LABELPLUG);
  plug->label = uniqueName;        // which label?
  plug->offset = codeposition;     // where in the code should its address be placed? 
    
  // link it in 
  plug->next = labelPlugs;
  labelPlugs = plug;
    
  // Make sure there is space:
  checkSpace(4);
       
  // increase code position to make room for address later when we fill the plugs 
  codeposition += sizeof(unsigned int);  
}


/* Search the list of labels and returns the address */
unsigned int getAddressOfLabel(char *uniqueLabel) {
  LABELADDRESS *labels = asmLabels;
  
  while (labels != NULL) {
    if (strcmp(labels->label, uniqueLabel) == 0) 
      return labels->offset;
    
    labels = labels->next; 	
  }	
  
  // Error - label was not found! 
  printf("Internal assembler error - label '%s' is referenced but not defined\n", uniqueLabel);
  return 0;
}  


/* Run through the list of plugs, look up their labels addresses and insert into byte code buffer */
void fillPlugs() {
  unsigned int address = 0;
  LABELPLUG *plugs = labelPlugs;
  
  // Loop over all plugs
  while (plugs != NULL) {
    
    // look up address of labels (by now it MUST be defined) 
    address = getAddressOfLabel(plugs->label);
    
    // fill address into the code segment 
    *((unsigned int*)&bytecode[plugs->offset]) = address;

    plugs = plugs->next; 
  }
}



// Add the byte code 'bc' to the code segment.
void addCode(char bc) {
 // Make sure there is room 
 checkSpace(sizeof(char));
 
 // add code 
 bytecode[codeposition] = bc;
 codeposition++;
}


/* save a 32bit integer in the code segment */
void addIndex(unsigned int index) {
 // Make sure there is room 
 checkSpace(sizeof(unsigned int));

 // add 32bit index to code segment 
 *((unsigned int*)&bytecode[codeposition]) = index;
 
 // increase code pointer 
 codeposition += sizeof(unsigned int); 
}


/* save a 16bit integer in the code segment */
void addInt16(short unsigned int index) {
 // Make sure there is room 
 checkSpace(sizeof(short unsigned int));

 // add 16bit integer to code segment 
 *((short unsigned int*)&bytecode[codeposition]) = index;
 
 // increase code pointer 
 codeposition += sizeof(short unsigned int); 
}


// Is a given token a label? It is if its name ends with a ':'
int isLabel(char *token) {
 if (token == NULL) return 0;
 return (token[strlen(token)-1] == ':');	
}


/* We must prefix the names of the labels because they are only
   unique in their own scopes and we do global assembling of labels
   and constants */
void setLabelPosition(char *name) {
  
  LABELADDRESS *newLabel = NULL;
  LABELADDRESS **pList = NULL;

  // generate unique name for label
  char *uniqueName = strconcat(currentName, name);
 
  // Add the label 	
  newLabel = NEW(LABELADDRESS);	
  newLabel->label = uniqueName;
  newLabel->offset = codeposition;	
  newLabel->next = NULL;
 
  // Link it into the global list of labels.
  pList = &asmLabels;
  while (*pList) {
   pList = &(*pList)->next;
  }
  *pList = newLabel;  
}



/*  Get the number of a certain int constant in the constant pool */
unsigned int getIntConstNr(int val) {
 CONSTANT *temp = asmConstants;
 CONSTANT *newConst = NULL;	
 CONSTANT **pList;

 // first try to find label in list 
 while (temp != NULL) {
  if (temp->type == INT_CONST && temp->val.intval == val) 
    return temp->nr;
 
  temp = temp->next; 	
 }	
  
 	
 // Constant has not been defined yet, so we create a new one. 	
 newConst = NEW(CONSTANT);	
 newConst->nr = nextconst++;
 newConst->type = INT_CONST;
 newConst->val.intval = val;
 newConst->next = NULL; 
 
 // Link it in 
 pList = &asmConstants;
 while (*pList) {
  pList = &(*pList)->next;
 }  
 *pList = newConst;  
  
 return newConst->nr;	
}


unsigned int getStrConstNr(char *val) {
 CONSTANT *temp = asmConstants;
 CONSTANT *newConst = NULL;	
 CONSTANT **pList;

 // first try to find label in list 
 while (temp != NULL) {
  if (temp->type == ZSTRING_CONST && strcmp(temp->val.str, val) == 0) 
    return temp->nr;
    
  temp = temp->next; 	
 }	
  	
 // Constant has not been defined yet, so we create a new one. 	
 newConst = NEW(CONSTANT);	
 newConst->nr = nextconst++;
 newConst->type = ZSTRING_CONST;
 newConst->val.str = val;
 newConst->next = NULL;
 
 // Link it in
 pList = &asmConstants;
 while (*pList) {
  pList = &(*pList)->next;
 }  
 *pList = newConst;  

 return newConst->nr;	
}




/* The most boring function in the assembler */
void asmCODE(char *token) {
  int intparam;
  char *param;
       
  if (strcmp(token, "nop") == 0) {
    addCode(nopC);
  } else
  if (strcmp(token, "imul") == 0) {
    addCode(imulC);
  } else
  if (strcmp(token, "ineg") == 0) {
    addCode(inegC);
  } else
  if (strcmp(token, "irem") == 0) {
    addCode(iremC);
  } else
  if (strcmp(token, "isub") == 0) {
    addCode(isubC);
  } else
  if (strcmp(token, "idiv") == 0) {
    addCode(idivC);
  } else
  if (strcmp(token, "iadd") == 0) {
    addCode(iaddC);
  } else
  if (strcmp(token, "aadd") == 0) {
    addCode(aaddC);
  } else 
  if (strcmp(token, "goto") == 0) {
    addCode(gotoC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "ifeq") == 0) {
    addCode(ifeqC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "ifne") == 0) {
    addCode(ifneC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "if_acmpeq") == 0) {
    addCode(if_acmpeqC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "if_acmpne") == 0) {
    addCode(if_acmpneC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "if_icmpeq") == 0) {
    addCode(if_icmpeqC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "if_icmpgt") == 0) {
    addCode(if_icmpgtC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "if_icmplt") == 0) {
    addCode(if_icmpltC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "if_icmple") == 0) {
    addCode(if_icmpleC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "if_icmpge") == 0) {
    addCode(if_icmpgeC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "if_icmpne") == 0) {
    addCode(if_icmpneC);
    param = getToken(sourceFILE);
    addPlug(param); /* label */
  } else
  if (strcmp(token, "ireturn") == 0) {
    addCode(ireturnC);
  } else
  if (strcmp(token, "areturn") == 0) {
    addCode(areturnC);
  } else
  if (strcmp(token, "return") == 0) {
    addCode(returnC);
  } else
  if (strcmp(token, "aload") == 0) {
    addCode(aloadC);
    intparam = atoi(getToken(sourceFILE));
    addInt16(intparam);
  } else
  if (strcmp(token, "astore") == 0) {
    addCode(astoreC);
    intparam = atoi(getToken(sourceFILE));
    addInt16(intparam);
  } else
  if (strcmp(token, "iload") == 0) {
    addCode(iloadC);
    intparam = atoi(getToken(sourceFILE));
    addInt16(intparam);
  } else
  if (strcmp(token, "istore") == 0) {
    addCode(istoreC);
    intparam = atoi(getToken(sourceFILE));
    addInt16(intparam);
  } else
  if (strcmp(token, "dup") == 0) {
    addCode(dupC);
  } else
  if (strcmp(token, "pop") == 0) {
    addCode(popC);
  } else
  if (strcmp(token, "iconst_0") == 0) {
    addCode(iconst_0C);
  } else 	
  if (strcmp(token, "iconst_1") == 0) {
	  addCode(iconst_1C);
 	} else 
  if (strcmp(token, "iconst_2") == 0) {
	  addCode(iconst_2C);
	} else 
  if (strcmp(token, "iconst_3") == 0) {
	  addCode(iconst_3C);
	} else 
  if (strcmp(token, "iconst_4") == 0) {
	  addCode(iconst_4C);
	} else 
  if (strcmp(token, "iconst_5") == 0) {
   	addCode(iconst_5C);
  } else 
  if (strcmp(token, "ldc_int") == 0) {
    addCode(ldc_intC);
    intparam = atoi(getToken(sourceFILE));
    /* index to constant pool */
    addIndex(getIntConstNr(intparam));
  } else	 
  if (strcmp(token, "ldc_string") == 0) {
    addCode(ldc_stringC);
    param = getStringToken(sourceFILE); 
    /* index to constant pool */
    addIndex(getStrConstNr(param));
  } else
  if (strcmp(token, "call") == 0) {
    addCode(callC);
    param = getToken(sourceFILE);
    /* index to constant pool */
    addIndex(getStrConstNr(param));
  } else
  if (strcmp(token, "setint_mdl") == 0) {
    addCode(setint_mdlC);
  } else
  if (strcmp(token, "setint_particle") == 0) {
    addCode(setint_particleC);
  } else
  if (strcmp(token, "setint_ply") == 0) {
    addCode(setint_plyC); 
  } else
  if (strcmp(token, "setint_light") == 0) {
    addCode(setint_lightC);
  } else
  if (strcmp(token, "setint_cam") == 0) {
    addCode(setint_camC);
  } else
  if (strcmp(token, "sleep") == 0) {
    addCode(sleepC);
  } else     
  if (strcmp(token, "sleep_trig") == 0) {
    addCode(sleep_trigC);
  } else     
  if (strcmp(token, "cast_inttostring") == 0) {
    addCode(cast_inttostringC);
  } else         
  if (strcmp(token, "cast_stringtoint") == 0) {
    addCode(cast_stringtointC);
  } else
  if (strcmp(token, "cast_booltostring") == 0) {
  	// This opcode is needed even if bools are represented by ints in the VM (can you think why?)
    addCode(cast_booltostringC);
  }             
  else {
    printf("FATAL ERROR - unhandled opcode in assembler '%s'\n", token);
  }
}



// Write the constant pool chunk to the output file.
void emitConstants() {
  char id = CONSTANTS_ID;
  CONSTANT *constantList = asmConstants;	
  char ctype;
  int intval;
  
  // write ID 
  fwrite(&id, 1, 1, emitFILE);
  
  // write number of constants 
  fwrite(&nextconst, sizeof(unsigned int), 1, emitFILE);
  
  // Loop over all constants 
  while (constantList) {
   ctype = constantList->type;
   fwrite(&ctype, 1, 1, emitFILE);
   switch (ctype) {
    case INT_CONST:
     intval = constantList->val.intval;
     fwrite(&intval, sizeof(int), 1, emitFILE);
     break;
    case ZSTRING_CONST:
     writeZString(constantList->val.str, emitFILE);
     break;
   }   	
   constantList = constantList->next;	
  }
}


// Write the code segment chunk to the file.
void emitCodeSegment() {
 char id = CODE_ID;
 
 /* write ID */
 fwrite(&id, 1, 1, emitFILE);
 
 /* write codesize */
 fwrite(&codeposition, sizeof(unsigned int), 1, emitFILE);  
  
 /* write bytecode */ 
 fwrite(bytecode, 1, codeposition, emitFILE);  
}




/* ****************** ASSEMBLER ******************* */

void AssembleFile(char *fn) 
{
  char *token = NULL;
  sourceFILE = fopen("emitted.a","r");
  emitFILE = fopen(fn, "wb");
  
  if (sourceFILE == NULL) {
  	printf("ERROR - Couldn't open source file 'emitted.a'\n");
  	return;
  }
  
  if (emitFILE == NULL) {
  	printf("ERROR - Couldn't open output file '%s'\n", fn);
  	return;
  }
  
  
  /* initialize the byte code buffer */
  curCodeArraySize = START_SIZE;
  bytecode = (unsigned char *)Malloc(START_SIZE);
  
  token = getToken(sourceFILE);  
      
  while (token != NULL) {
   // Which top-level token did we read?
   if (strcmp(token, ".function") == 0)
    AssembleFunction();
   else
   if (strcmp(token, ".program") == 0)
    AssembleProgram();
   else
    reportError(line, "Illegal top-level token in assembly file");	
  
   /* Get next top-level */  	
   token = getToken(sourceFILE);	
  }
  
  /* fill in the plugs */
  fillPlugs();
  
  /* Now emit all constants and code */
  emitConstants();
  emitCodeSegment();
    
  fclose(emitFILE);
  fclose(sourceFILE);	
}



// Assemble a function
void AssembleFunction() {
 char id;
 char *token;
 char *tmp;
 int end = 0;
 
 // Create a new function header struct
 FUNCTIONHEADER *header = NEW(FUNCTIONHEADER);
 
 // The functions code will start here:
 header->startCode = codeposition;
 
    
 // First get name token and extract parameter info from it 
 token = getToken(sourceFILE);
 tmp = token;
 header->inputs = 0;
 header->outputs = 0;
 
 // Search for end of name.
 while (*tmp != '(') {
  end++;
  tmp++;
 } 
 
 // Count number of inputs to this function
 while (*tmp != ')') {
  tmp++;
  header->inputs++;
 }
 header->inputs--; // We counted one too much in the above.
 
 // Check if there is a return value from this function
 tmp++;
 if (*tmp != 'V') // Check if return type is non-VOID 
  header->outputs = 1;
 
 // Zero-terminate token where the name ends.
 token[end] = 0;
 header->name = token; 
 
 // the prefix for our label lookup. The function name is unique 
 currentName = header->name; 
   
 // Now assemble the function  
 do {
  token = getToken(sourceFILE);		
 	
  if (isLabel(token)) { 
    token[strlen(token)-1] = 0;
    setLabelPosition(token);	
  }	
  else
  if (strcmp(token, ".limit_locals") == 0) {
    token = getToken(sourceFILE);	
    header->localLimit = atoi(token);
  }
  else
  if (strcmp(token, ".limit_stack") == 0) {
    token = getToken(sourceFILE);	
    header->stackLimit = atoi(token);
  }
  else
  if (strcmp(token, ".end_function") == 0) {
    // Do nothing
  }
  else {
   // If nothing else matches this must be a token from the functions code body. 
   asmCODE(token);
 	}
 } while (token != NULL && (strcmp(token, ".end_function") != 0));
 
 // This is where the code ends (points to the first byte code AFTER the function)
 header->endCode = codeposition;
 
   
 // Write function to the output file 
 id = FUNCTION_ID;
 fwrite(&id, 1, 1, emitFILE); // Write a function chunk.
 // write header 
 writeZString(header->name, emitFILE);
 fwrite(&header->inputs, 1, 1, emitFILE);
 fwrite(&header->outputs, 1, 1, emitFILE);
 fwrite(&header->localLimit, 1, 1, emitFILE);
 fwrite(&header->stackLimit, sizeof(unsigned short int), 1, emitFILE);
 fwrite(&header->startCode, sizeof(unsigned int), 1, emitFILE);
 fwrite(&header->endCode, sizeof(unsigned int), 1, emitFILE);

 // Echo some of the info to the screen. 
 printf("func : '%s', inputs %i, outputs %i, codesize %i\n", 
        header->name, header->inputs, header->outputs,  header->endCode - header->startCode ); 
  
}


// Pretty much the same as above. Look for the changes yourself
void AssembleProgram() {
 char id;
 char *token = NULL;
 PROGRAMHEADER *header = NEW(PROGRAMHEADER);
 header->startCode = codeposition;
 header->triggerArgument = NULL;
 
 // read name 
 header->name = getToken(sourceFILE);
 
 // the prefix for our label lookup 
 currentName = header->name; 
   
 do {
  token = getToken(sourceFILE);		
 
  if (isLabel(token)) { 
    token[strlen(token)-1] = 0;
    setLabelPosition(token);	
  }	
  else
  if (strcmp(token, ".limit_locals") == 0) {
    token = getToken(sourceFILE);	
    header->localLimit = atoi(token);
  }
  else
  if (strcmp(token, ".limit_stack") == 0) {
    token = getToken(sourceFILE);	
    header->stackLimit = atoi(token);
  }
  else
  if (strcmp(token, ".trigger_never") == 0) {
    header->triggertype = trigger_neverK;
  }
  else
  if (strcmp(token, ".trigger_on_init") == 0) {
    header->triggertype = trigger_on_initK;
  }
  else
  if (strcmp(token, ".trigger_on_click") == 0) {
    header->triggertype = trigger_on_clickK;
    token = getStringToken(sourceFILE); 
    header->triggerArgument = token;
  }
  else
  if (strcmp(token, ".trigger_on_collide") == 0) {
    header->triggertype = trigger_on_collideK;
    token = getStringToken(sourceFILE); 
    header->triggerArgument = token; 
  }
  else
  if (strcmp(token, ".trigger_on_pickup") == 0) {
    header->triggertype = trigger_on_pickupK;
    token = getStringToken(sourceFILE); 
    header->triggerArgument = token;
  }
  else 
  if (strcmp(token, ".end_program") == 0) {
  	// Do nothing
  }	
  else {
    asmCODE(token);
 	}
 } while (token != NULL && (strcmp(token, ".end_program") != 0));

 
 header->endCode = codeposition;
 
 // Write program 
 id = PROGRAM_ID;
 fwrite(&id, 1, 1, emitFILE);
 // write header 
 writeZString(header->name, emitFILE);
 fwrite(&header->localLimit, 1, 1, emitFILE);
 fwrite(&header->stackLimit, sizeof(unsigned short int), 1, emitFILE);
 fwrite(&header->triggertype, 1, 1, emitFILE);
 writeZString(header->triggerArgument, emitFILE);
 fwrite(&header->startCode, sizeof(unsigned int), 1, emitFILE);
 fwrite(&header->endCode, sizeof(unsigned int), 1, emitFILE);

 // Echo to screen
 printf("triggertype = %i, trigger Argument '%s'\n", header->triggertype, header->triggerArgument);
 printf("prog : '%s' - codesize %i\n", header->name, header->endCode - header->startCode ); 
}

/* ***************************************************

   ** And we're done!  That wasn't so hard was it?? **

   ** Congrats on completing your compiler!         **
   
   *************************************************** */
