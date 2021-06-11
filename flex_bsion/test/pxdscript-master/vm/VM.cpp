#include "VM.h"
#include "Logger.h"
#include "Player.h"

#include <stdlib.h> // atoi

string intToString(int val) {
  char *str = new char[255];
  sprintf( str, "%i", val);
  string res(str);
  delete str;
  return res;   
}


VM::VM(char *code, HashMap<string, FUNCTIONHEADER *>* functionList, StackItem *cp) {
 CS = code;
 this->functionList = functionList;
 constantPool = cp;
}

VM::~VM() {
 // TODO 
}


/* The core of the VM */

void VM::run(ProgramInstance *prog, int maxInstructions) {
 int instructionsHandled = 0;
  
 while(prog->getPC() < prog->getEndCode() && !prog->dead && !prog->sleeping && instructionsHandled <= maxInstructions) { 
  
  // Fetch  
  char opcode = CS[prog->getPC()];
  prog->addPC(1);
  instructionsHandled++;
  
  // Dispatch:
  switch(opcode) {
  	case nopC: {
  		// Do nothing
  	} break; 
  	case imulC: {
  		// Multiply the two top integers on the stack and push the result:
  		int v1 = prog->popInt();
  		int v2 = prog->popInt();
  		prog->pushInt(v1*v2);
  	} break; 
  	case inegC: {
  		// negate the top integer
  		int v = prog->popInt();
  		prog->pushInt(-v);
  	} break; 
  	case iremC: {
      // push the modulo of the two top stack items. Notice how we first pop the right-hand value.
      // This is how it was encoded in the bytecode.. first it pushes the left value, then the right - so
      // the right-hand value is on top of the stack, right!?
  	  int v2 = prog->popInt();
  	  int v1 = prog->popInt();
  	  prog->pushInt(v1%v2);
  	} break; 
  	case isubC: {
  		int v2 = prog->popInt();
  		int v1 = prog->popInt();
  		prog->pushInt(v1-v2);
  	} break; 
  	case idivC: {
  		int v2 = prog->popInt();
  		int v1 = prog->popInt();
  		prog->pushInt(v1/v2);
  	} break; 
  	case iaddC: {
  		int v2 = prog->popInt();
  		int v1 = prog->popInt();
  		prog->pushInt(v1+v2);
  	} break; 
  	case aaddC: {
  		string v2 = prog->popStr();
  		string v1 = prog->popStr();
  		prog->pushStr(v1+v2);
  	} break; 
  	case gotoC: {
  		// unconditional jump in the code. Notice how we decode the address directly from the code segment.. that's how
  		// we decided to store them in the assembler.
  		unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->setPC(address);
		} break; 
  	case ifeqC: {
  		// jump if integer on top of stack is equal to zero - otherwise continue.
  		// if we should NOT jump we'll have to manually increase the PC to get past the address we just read. It should
	    // point to the next instruction after we finish the switch on the current bytecode.
	    unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
      prog->addPC(sizeof(unsigned int));
  
      if (prog->popInt() == 0) 
	      prog->setPC(address);
	 } break; 
  	case ifneC: {
  		// jump if top integer is different from zero.
      unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
      prog->addPC(sizeof(unsigned int));
	
	    if (prog->popInt() != 0)
 	      prog->setPC(address);
   } break; 
 	  case if_acmpeqC: {
 	    // jump if two topmost strings are equal:
 	  	unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
	    string v2 = prog->popStr();
	    string v1 = prog->popStr();
	
	    if (v1 == v2)
	      prog->setPC(address);
	  } break;
 	  case if_acmpneC: {
 	    // jump if two topmost strings are different:
 	  	unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
	    string v2 = prog->popStr();
	    string v1 = prog->popStr();
	
	    if (v1 != v2)
	      prog->setPC(address);
 	  } break;
 	  case if_icmpeqC: {
 	    // jump if two topmost integers are equal:
 	  	unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
	    int v2 = prog->popInt();
	    int v1 = prog->popInt();
	
	    if (v1 == v2)
	      prog->setPC(address);
 	  } break;
 	  case if_icmpgtC: {
 	    // jump if two topmost integers are equal:
 	  	unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
	    int v2 = prog->popInt();
	    int v1 = prog->popInt();
	
	    if (v1 > v2)
	      prog->setPC(address);
 	  } break;
 	  case if_icmpltC: {
	    // jump if two topmost integers are equal:
 	  	unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
	    int v2 = prog->popInt();
	    int v1 = prog->popInt();
	
	    if (v1 < v2)
	      prog->setPC(address);
 	  } break;
 	  case if_icmpleC: {
	    // jump if two topmost integers are equal:
 	  	unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
	    int v2 = prog->popInt();
	    int v1 = prog->popInt();
	
	    if (v1 <= v2)
	      prog->setPC(address);
 	  } break;
 	  case if_icmpgeC: {
 	    // jump if two topmost integers are equal:
 	  	unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
	    int v2 = prog->popInt();
	    int v1 = prog->popInt();
	
	    if (v1 >= v2)
	      prog->setPC(address);
 	  } break;
 	  case if_icmpneC: {
	    // jump if two topmost integers are equal:
 	  	unsigned int address = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
	    int v2 = prog->popInt();
	    int v1 = prog->popInt();
	
	    if (v1 != v2)
	      prog->setPC(address);
 	  } break;
 	  case ireturnC: {
 	  	// Return an integer value to the activation below this one.
 	  	
 	    // Get the result and arg count:
 	    int res = prog->getInt();
 	    int args = prog->getNumParams();
 	 
 	    //Pop the activation:
 	    prog->popActivation();
 	 
 	    // Pop the arguments in the old activation and push result:
 	    prog->pop(args);
 	    prog->pushInt(res);
 	  } break;
 	  case areturnC: {
 	  	// Return a string value to the activation below this one.
 	  	
 	    // Get the result and arg count:
 	    string res = prog->getStr();
 	    int args = prog->getNumParams();
 	 
 	    //Pop the activation:
 	    prog->popActivation();
 	 
 	    // Pop the arguments in the old activation and push result:
 	    prog->pop(args);
 	    prog->pushStr(res);
 	  } break;
 	  case returnC: {
 	  	// return from a void function to the activation below this one
 	  	
 	    // Get the arg count:
 	    int args = prog->getNumParams();
 	 
 	    //Pop the activation:
 	    prog->popActivation();
 	 
 	    // Pop the arguments in the old activation:
 	    prog->pop(args);
 	  } break;
    case aloadC: {
    	// load a string variable to the top of the stack
    	
    	// retrieve address of the variable from the code segment (stored as a 16bit integer by assembler) 
      short unsigned int address = *((short unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(short unsigned int));
	    
	    // Push the variable to the top of the stack
	    prog->pushStr(prog->getLocalStr(address));
    } break;
    case astoreC: {
      // store topmost string to its address in the stack:
      
    	// retrieve address of the variable from the code segment (stored as a 16bit integer by assembler) 
	    short unsigned int address = *((short unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(short unsigned int));
      
	    prog->setLocalStr(prog->popStr(), address);
	  } break;
    case iloadC: {
    	// retrieve address of the variable from the code segment and increase PC to point at next bytecode
	    short unsigned int address = *((short unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(short unsigned int));
	    
	    // Push the variable to the top of the stack
	    prog->pushInt(prog->getLocalInt(address));
    } break;
    case istoreC: {
      // store topmost string to its address in the stack:
	    short unsigned int address = *((short unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(short unsigned int));
      
	    prog->setLocalInt(prog->popInt(), address);
    } break;
  	case ldc_intC: {
  		// load an integer constant from the constant pool and push it to the stack.
  		// index is 32bit unsigned integer (as stored by assembler)
  		unsigned int index = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
      
      prog->pushInt(constantPool[index].intval);
  	} break; 
  	case iconst_0C: {
  		// simply push constant 0
  		prog->pushInt(0);
  	} break; 
  	case iconst_1C: {
      prog->pushInt(1);
  	} break; 
  	case iconst_2C: {
      prog->pushInt(2);
  	} break; 
  	case iconst_3C: {
      prog->pushInt(3);
  	} break; 
  	case iconst_4C: {
      prog->pushInt(4);
  	} break; 
  	case iconst_5C: {
      prog->pushInt(5);
  	} break; 
  	case ldc_stringC: {
  		// load a string constant from the constant pool and push it to the stack.
  		// index is 32bit unsigned integer (as stored by assembler)
  		unsigned int index = *((unsigned int*)&CS[prog->getPC()]);
	    prog->addPC(sizeof(unsigned int));
      
      prog->pushStr(constantPool[index].strval);
  	} break; 
  	case dupC: {
  		// dublicate the top stack item
      prog->pushStackItem(prog->getStackItem());
  	} break; 
  	case popC: {
  		// pop the top stack item
  		prog->pop();
  	} break; 
  	case callC: {
      // Call a function:
 
      // Get the index into the constant pool where the name of the function lies as a string:
 	    unsigned int index = *((unsigned int*)&CS[prog->getPC()]);
 	    prog->addPC(sizeof(unsigned int));

      // look up the function in the function hash-table:
      FUNCTIONHEADER *theFunction = NULL;
      bool found = functionList->get(constantPool[index].strval, &theFunction);
      
      if (found && theFunction != NULL) {
      	// Get the current stack pointer for this activation
 	      int curSP = prog->getSP();
 	      
 	      // push a new activation:
 	      prog->pushActivation();
 	      
 	      // Set the start and end byte code for this activation
        prog->setPC(theFunction->startCode);
        prog->setEC(theFunction->endCode);
        
        // Set the BSP to the first of the arguments to this new activation
        prog->setBSP(curSP - theFunction->inputs);
        
        // Set the new stack pointer to BSP + LocalsLimit
        prog->setSP(curSP - theFunction->inputs + theFunction->localLimit);
        
        // Save in activation how many input parameters it has (needed to pop it correctly later) 
        prog->setNumParams(theFunction->inputs);
      }
      else {
       // this should never happen.	
       Log("ERROR - function %s was not found in VM", constantPool[index].strval.c_str());
	    }
  	} break; 
  	case setint_mdlC: {
  		// Only the player case of these 'setint' opcodes are 'hooked up' against something in this
  		// example VM - but this is where you could plug in your own classes to control integer parameters
  		// in them..
  		int val = prog->popInt();
  		int nr = prog->popInt();
  		string name = prog->popStr();
      Log("setint called on MDL type - not implemented. Name=%s, nr=%i, val=%i", name.c_str(),nr,val);
    } break; 
  	case setint_particleC: {
  		int val = prog->popInt();
  		int nr = prog->popInt();
  		string name = prog->popStr();
      Log("setint called on PARTICLE type - not implemented. Name=%s, nr=%i, val=%i", name.c_str(),nr,val);
  	} break; 
  	case setint_plyC: {
  	  int val = prog->popInt();
  		int nr = prog->popInt();
  		string name = prog->popStr();
  		
  		// call into the 'engine' to modify some integer parameters in the player object
  		Player::instance()->setInt(name,nr,val);
  	} break; 
  	case setint_lightC: {
  		int val = prog->popInt();
  		int nr = prog->popInt();
  		string name = prog->popStr();
      Log("setint called on LIGHT type - not implemented. Name=%s, nr=%i, val=%i", name.c_str(),nr,val);
   	} break; 
  	case setint_camC: {
  		int val = prog->popInt();
  		int nr = prog->popInt();
  		string name = prog->popStr();
      Log("setint called on CAM type - not implemented. Name=%s, nr=%i, val=%i", name.c_str(),nr,val);
   	} break; 
  	case sleepC: {
	    int sleepTime = prog->popInt();
	    prog->sleeping = true;
	 	  prog->wakeuptime = GetTimeMsec() + sleepTime;
  	} break; 
  	case sleep_trigC: {
  		// sleep until triggered again (signalled to the script manager by setting the wakeup time to 0) 
      prog->sleeping = true;
      prog->wakeuptime = 0;
		} break;
		case cast_booltostringC: {
  		// pop a bool of the stack (stored as int), convert it to string and push the result:
      int v = prog->popInt();
      if (v == 0)
       prog->pushStr("false");
      else
       prog->pushStr("true");
    } break;    
  	case cast_inttostringC: { 
  		// pop an integer of the stack, convert it to string and push the result:
      int v = prog->popInt();
      string s = intToString(v);
      prog->pushStr(s);
  	} break; 
  	case cast_stringtointC: {
  		string s = prog->popStr();
  		int v = atoi(s.c_str());
  		prog->pushInt(v);
  	} break; 
    default:
      Log("Unknown opcode %i", CS[prog->getPC()]);
      break;
  } // end of switch	
 }

 if (prog->getPC() >= prog->getEndCode()) {
   Log("killing program %s  - pc is %i, end of code is %i", prog->getName(), prog->getPC(), prog->getEndCode());
   prog->dead = true;
 }
}
