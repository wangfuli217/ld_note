/* pxdscript code.c
 *
 * history:
 * 4/3 - Created with an empty recursion through tree
 */

#include "code.h"
#include "memory.h"
#include "tree.h"
#include "error.h"
#include <string.h>
#include <stdlib.h>

/* *************************** UTILITY FUNCTIONS ********************** */

CODE *currentcode;
CODE *currenttail;
LABEL *currentlabels;

void appendCODE(CODE *c)
{ if (currentcode==NULL) {
     currentcode = c;
     currenttail = c;
  } else {
     currenttail->next = c;
     currenttail = c;
  }
}

void code_nop()
{ appendCODE(makeCODEnop(NULL));
}


void code_imul()
{ appendCODE(makeCODEimul(NULL));
}
 
void code_ineg()
{ appendCODE(makeCODEineg(NULL));
}
 
void code_irem()
{ appendCODE(makeCODEirem(NULL));
}

void code_isub()
{ appendCODE(makeCODEisub(NULL));
}
 
void code_idiv()
{ appendCODE(makeCODEidiv(NULL));
}

void code_iadd()
{ appendCODE(makeCODEiadd(NULL));
}

void code_aadd()
{ appendCODE(makeCODEaadd(NULL));
}

CODE *code_label(char *name, int label)
{ currentlabels[label].name = name;
  currentlabels[label].sources = 1;
  appendCODE(makeCODElabel(label,NULL));
  currentlabels[label].position = currenttail;
  return currenttail;
}

void code_goto(int label)
{ appendCODE(makeCODEgoto(label,NULL));
}

void code_ifeq(int label)
{ appendCODE(makeCODEifeq(label,NULL));
}

void code_ifne(int label)
{ appendCODE(makeCODEifne(label,NULL));
}

void code_if_acmpeq(int label)
{ appendCODE(makeCODEif_acmpeq(label,NULL));
}

void code_if_acmpne(int label)
{ appendCODE(makeCODEif_acmpne(label,NULL));
}

void code_if_icmpeq(int label)
{ appendCODE(makeCODEif_icmpeq(label,NULL));
}

void code_if_icmpgt(int label)
{ appendCODE(makeCODEif_icmpgt(label,NULL));
}

void code_if_icmplt(int label)
{ appendCODE(makeCODEif_icmplt(label,NULL));
}

void code_if_icmple(int label)
{ appendCODE(makeCODEif_icmple(label,NULL));
}

void code_if_icmpge(int label)
{ appendCODE(makeCODEif_icmpge(label,NULL));
}

void code_if_icmpne(int label)
{ appendCODE(makeCODEif_icmpne(label,NULL));
}

void code_ireturn()
{ appendCODE(makeCODEireturn(NULL));
}

void code_areturn()
{ appendCODE(makeCODEareturn(NULL));
}

void code_return()
{ appendCODE(makeCODEreturn(NULL));
}
 
void code_aload(int arg)
{ appendCODE(makeCODEaload(arg,NULL));
}

void code_iload(int arg)
{ appendCODE(makeCODEiload(arg,NULL));
}

void code_astore(int arg)
{ appendCODE(makeCODEastore(arg,NULL));
}

void code_istore(int arg)
{ appendCODE(makeCODEistore(arg,NULL));
}

void code_dup()
{ appendCODE(makeCODEdup(NULL));
}

void code_pop()
{ appendCODE(makeCODEpop(NULL));
}


void code_ldc_int(int arg)
{ appendCODE(makeCODEldc_int(arg,NULL));
}

void code_ldc_string(char *arg)
{ appendCODE(makeCODEldc_string(arg,NULL));
}

void code_call(char* arg, char* signature)
{ appendCODE(makeCODEcall(arg,signature,NULL));
}


void code_setint(EntityKind kind)
{ appendCODE(makeCODEsetint(kind, NULL));
}

void code_sleep()
{ appendCODE(makeCODEsleep(NULL));
}

void code_sleepUntilTriggered()
{ appendCODE(makeCODEsleepUntilTriggered(NULL));
}

void code_cast(TYPE *source, TYPE *dest)
{ appendCODE(makeCODEcast(source, dest, NULL));
}



char *strcat2(char *s1, char *s2)
{ char *s;
  s = (char *)Malloc(strlen(s1)+strlen(s2)+1);
  sprintf(s,"%s%s",s1,s2);
  return s;
}

char *strcat3(char *s1, char *s2, char *s3)
{ char *s;
  s = (char *)Malloc(strlen(s1)+strlen(s2)+strlen(s3)+1);
  sprintf(s,"%s%s%s",s1,s2,s3);
  return s;
}

char *strcat4(char *s1, char *s2, char *s3, char *s4)
{ char *s;
  s = (char *)Malloc(strlen(s1)+strlen(s2)+strlen(s3)+strlen(s4)+1);
  sprintf(s,"%s%s%s%s",s1,s2,s3,s4);
  return s;
}

char *strcat5(char *s1, char *s2, char *s3, char *s4, char *s5)
{ char *s;
  s = (char *)Malloc(strlen(s1)+strlen(s2)+strlen(s3)+strlen(s4)+strlen(s5)+1);
  sprintf(s,"%s%s%s%s%s",s1,s2,s3,s4,s5);
  return s;
}

/* JVM style - except for better names ;) */

char *codeType(TYPE *t)
{ switch (t->kind) {
    case intK:
         return "I";
         break;
    case boolK:
         return "B";
         break;
    case voidK:
         return "V";
         break;
    case stringK:
         return "S";
         break;	
  }
  return NULL;
}

char *codeFormals(DECL *f)
{ if (f==NULL) return "";
  return strcat2(codeFormals(f->next),codeType(f->type));
}


/* The function signature is used in a later module to calculate the stack change
   a call to that function will result in */
char *codeSignature(DECL *f, TYPE *t)
{ return strcat4("(",codeFormals(f),")",codeType(t));
}



/* ************************ TREE RECURSION ************************ */






void codeSCRIPTCOLLECTION(SCRIPTCOLLECTION *s)
{

  if(s->toplevels != NULL)
    codeTOPLEVEL(s->toplevels);

}

void codeTOPLEVEL(TOPLEVEL *t)
{
  
  switch(t->kind){
  case functionK:
    codeFUNCTION(t->val.functionT);
    break;
  case programK:
    codePROGRAM( t->val.programT);
    break;
  }
    
  if(t->next != NULL)
    codeTOPLEVEL(t->next);
}



void codeFUNCTION(FUNCTION *f)
{
  // Create signature string first
  f->signature = codeSignature(f->formals,f->type);
  
  currentcode = NULL;
  f->labels = Malloc(f->labelcount*sizeof(LABEL));
  currentlabels = f->labels;
   
  if(f->stms != NULL)
    codeSTM(f->stms);
  
  /* code the implicit return of 'void' functions*/
  if (f->type->kind==voidK) 
   code_return();
  else 
   code_nop();
   
  f->opcodes = currentcode;
}



void codePROGRAM(PROGRAM *s)
{
  
  currentcode = NULL;
  s->labels = Malloc(s->labelcount*sizeof(LABEL));
  currentlabels = s->labels;

  if(s->stms != NULL)
    codeSTM(s->stms);
    
  s->opcodes = currentcode;
  
}





/* Build code for a variable declaration. This means build code for any *initialization*
   of the variable - the declaration itself does not produce any code! 
   As mentioned in chapter 7 variableK and simplevarK are treated the same because of
   the transformation of the AST that we do in the weeding phase.*/
void codeDECL(DECL *d)
{
  switch(d->kind){
  case formalK:
    break;
  case variableK:
    if(d->val.variableD.initialization != NULL) {
      
       /* Build code for the expression that makes up the initialization */
       codeEXP( d->val.variableD.initialization);
    
       /* Build code to store the result in the variables slot on the stack */
       if (d->type->kind==stringK) 
         code_astore(d->val.variableD.offset);
       else 
         code_istore(d->val.variableD.offset);  
    }  
    break;
  case simplevarK:
    if(d->val.simplevarD.initialization != NULL) {
      codeEXP(d->val.simplevarD.initialization);
    
      if (d->type->kind==stringK) 
         code_astore(d->val.simplevarD.offset);
      else 
         code_istore(d->val.simplevarD.offset);  
    }
    break;
  }

  if(d->next != NULL)
    codeDECL( d->next);
}






/* Remember what a FORINIT is - it's the first part of the for-loop where the user can
   do some initialization of variables before the loop is entered. A for-loop looks like this:
   
   for(a;b;c) { 
    
   }
   
   where 'a' is the FORINIT, 'b' and 'c' are the "condition" expression and the "update" expression
   
   There are two possibilities for what 'a' is - it can be a *declaration*:
   
   for (int a=0; a < 5; a=a+1) {
    
   }
   
   or 'a' can be an expression on already existing variables (just like 'b' and 'c'):
   
   int a;
   for (a=0; a < 5; a=a+1) {
    
   }
   
   The function below must produce slightly different code for each of the two cases mentioned
   above.
   
*/   
void codeFORINIT(FORINIT *f)
{
  switch(f->kind){
  case declforinitK:
    codeDECL(f->val.declforinitF);
    break;
  case expforinitK:
    codeEXP(f->val.expforinitF);
    if (f->val.expforinitF->type->kind != voidK) 
     code_pop();
    break;
  }

  if(f->next != NULL)
    codeFORINIT( f->next);
}








/* The next function builds the code templates for all the *statements* (STM) in our language.
   The important thing to remember here is that the stack invariant must be respected and
   therefore all STM code templates must leave the stack-height unchanged.
   
   See the tutorial text for more information on the stack invariant
*/   
void codeSTM(STM *s)
{
  
  switch(s->kind) {
  case skipK:
    break;
  case expK:
    /* an expression can be a "statement" if one is not concerned with the result. (For example
       if we calculate the expression but does not assign it to a variable)
       
       An example of where an expression becomes a statement could be:
       
       int a=5;
       int b=8;
       a+b;     <- This is legal in pxdscript (like in C/C++) but the expression 'a+b' is then
                   considered a statement
       
       Another example is a call to a void function. A function call is considered an expression -
       but if the function is of type 'void' it cant be placed on the right hand side of an 
       assignment. Thus a void function call is always an "expression statement"
       */
    codeEXP( s->val.expS);
    if (s->val.expS->type->kind!=voidK) // To respect stack invariant we must pop the result.
      code_pop();
    break;
  case declstmK:
    /* In pxdscript a variable declaration is considered a statement (like C++ but unlike C). 
       This is what allows us to declare variables everywhere in our code and not just in the
       beginning of a program or function (think about why this is so - look in lang.y for 
       inspiration :)
       */
    codeDECL( s->val.declstmS);
    break;
  case returnK:
    if (s->val.returnS.exp==NULL) /* if a 'void' return type */
      code_return();    /* will leave stack height unchanged */
    else {
      codeEXP( s->val.returnS.exp); /* will increse stack height by 1 */
      if (s->val.returnS.exp->type->kind==stringK) 
        code_areturn(); /* will decrease stack height by 1 */
      else 
        code_ireturn(); /* will decrease stack height by 1 */
    }
    break;
  case ifK:
    /* Note how we build the code templates for the following statements like described in the
       tutorial text. Read through them and make sure you understand why each of them is true
       to the stack invariant */
    codeEXP( s->val.ifS.condition);
    code_ifeq(s->val.ifS.stoplabel);
    codeSTM( s->val.ifS.body);
    code_label("stop",s->val.ifS.stoplabel);
    break;
  case ifelseK:
    codeEXP( s->val.ifelseS.condition);
    code_ifeq(s->val.ifelseS.elselabel);
    codeSTM( s->val.ifelseS.thenpart);
    code_goto(s->val.ifelseS.stoplabel);
    code_label("else",s->val.ifelseS.elselabel);
    codeSTM( s->val.ifelseS.elsepart);
    code_label("stop",s->val.ifelseS.stoplabel);
    break;
  case whileK:
    code_label("start",s->val.whileS.startlabel);
    codeEXP( s->val.whileS.condition);
    code_ifeq(s->val.whileS.stoplabel);
    codeSTM( s->val.whileS.body);
    code_goto(s->val.whileS.startlabel);
    code_label("stop",s->val.whileS.stoplabel);
    break;
  case forK:
    codeFORINIT( s->val.forS.inits);
    code_label("start",s->val.forS.startlabel);
    codeEXP( s->val.forS.condition);
    code_ifeq(s->val.forS.stoplabel);
    codeSTM( s->val.forS.body);
    if (s->val.forS.updates != NULL) {
      codeEXP( s->val.forS.updates);
      if (s->val.forS.updates->type->kind != voidK)
        code_pop(); 
    }  
    code_goto(s->val.forS.startlabel);
    code_label("stop",s->val.forS.stoplabel);
    break;
  case sequenceK:
    codeSTM( s->val.sequenceS.first);
    codeSTM( s->val.sequenceS.second);
    break;
  case scopeK:
    /* At this point the scope has served its use. On assembly form there
       is no such thing as scopes - it's all linear code */
    codeSTM( s->val.scopeS.stm);
    break;
  case setintK:
    codeEXP( s->val.setintS.modelname); /* stack +1 */
    codeEXP( s->val.setintS.nr);        /* stack +1 */
    codeEXP( s->val.setintS.val);       /* stack +1 */ 
    code_setint(s->val.setintS.kind);   /* stack -3 */
    break;
  case sleepK:
    if (s->val.sleepS.time == NULL) { 
      code_sleepUntilTriggered();      /* Stack height unchanged */
    }
    else {
      codeEXP( s->val.sleepS.time);    /* code expression for how long to sleep. Stack +1 */
      code_sleep();                    /* stack height -1 */
    }
    break;  
  }
}









/* The next function builds the code templates for all the *expressions* (EXP) in our language.
   The important thing to remember here is that the stack invariant must be respected and
   therefore all EXP code templates must leave the stack-height one heigher than before the EXP.
   
   See the tutorial text for more information on the stack invariant
*/   
void codeEXP( EXP *e)
{
  if (e == NULL)
   return;
 
  switch (e->kind) {
  case intconstK:
    /* Load an integer constant to the stack */
    code_ldc_int(e->val.intconstE);
    break;
  case boolconstK:
    /* Load a boolean constant to the stack. In the VM int and bool is the same */
    code_ldc_int(e->val.boolconstE);
    break;
  case stringconstK:
    /* Load a string constant to the stack */
    code_ldc_string(e->val.stringconstE);
    break;
  case uminusK:
    /* unary minus ( '-' applied with only one operand. Like in:   a = -(b*8); */
    codeEXP( e->val.uminusE); /* code the expression ('b*8' in the example above */
    code_ineg();              /* negate the integer on top of the stack */
    break;
  case notK:
    /* Build the 'not' template. See tutorial text for more info */
    codeEXP( e->val.notE.exp);                
    code_ifeq(e->val.notE.truelabel);         
    code_ldc_int(0);                          
    code_goto(e->val.notE.stoplabel);         
    code_label("true",e->val.notE.truelabel);
    code_ldc_int(1);
    code_label("stop",e->val.notE.stoplabel); 
    break;
  case lvalueK:
    codeLVALUE( e->val.lvalueE);
    break;
  case assignmentK:
    codeEXP( e->val.assignmentE.right);   /* code the right side of the assignment. That is just an expression */
    code_dup();                           /* Copy the top stack item (the expression above). The value is now 
                                             twice on the stack */
    
    if (e->val.assignmentE.left->symbol->kind != declSym)
     reportError(e->lineno, "Lvalue in assignment is not a decl symbol");
    else {
      switch(e->val.assignmentE.left->symbol->val.declS->kind) { /* OK - a bit evil ;) */
      	case formalK:
      	 /* assignment to a function parameter is allowed. */
      	 if (e->val.assignmentE.left->type->kind==stringK) 
           code_astore(e->val.assignmentE.left->symbol->val.declS->val.formalD.offset);
         else 
           code_istore(e->val.assignmentE.left->symbol->val.declS->val.formalD.offset);
         break;
      	case variableK:
      	 /* assignment to variable and simplevar is once again the same because of weeding */
      	 if (e->val.assignmentE.left->type->kind==stringK) 
           code_astore(e->val.assignmentE.left->symbol->val.declS->val.variableD.offset);
         else 
           code_istore(e->val.assignmentE.left->symbol->val.declS->val.variableD.offset);  
      	 break;
      	case simplevarK:
      	 if (e->val.assignmentE.left->type->kind==stringK) 
           code_astore(e->val.assignmentE.left->symbol->val.declS->val.simplevarD.offset);
         else 
           code_istore(e->val.assignmentE.left->symbol->val.declS->val.simplevarD.offset);  
      	 break;
     }	
    } 
     
    /* Note that the 'store' opcodes pop the value they store of the stack. This is why we took a copy - it's
       the copy that gets popped and stored.. the original result of the right-hand expression is still on the
       stack and thus the assignment EXP leaves the stack height increased by one as it should. */ 
     
    break;
  case equalsK:
    codeEXP( e->val.equalsE.left);
    codeEXP( e->val.equalsE.right);
    
    if (e->val.equalsE.left->type->kind==stringK) 
      code_if_acmpeq(e->val.equalsE.truelabel);
    else 
      code_if_icmpeq(e->val.equalsE.truelabel);
      
    code_ldc_int(0); /* if the code gets here the opcode above did not jump - so the arguments are not equal. */
    code_goto(e->val.equalsE.stoplabel);
    code_label("true",e->val.equalsE.truelabel);
    code_ldc_int(1);
    code_label("stop",e->val.equalsE.stoplabel);
    break;
  case nequalsK:
    codeEXP( e->val.nequalsE.left);
    codeEXP( e->val.nequalsE.right);
    if (e->val.nequalsE.left->type->kind==stringK) 
      code_if_acmpne(e->val.nequalsE.truelabel);
    else 
      code_if_icmpne(e->val.nequalsE.truelabel);
         
    code_ldc_int(0);
    code_goto(e->val.nequalsE.stoplabel);
    code_label("true",e->val.nequalsE.truelabel);
    code_ldc_int(1);
    code_label("stop",e->val.nequalsE.stoplabel);
    break;
  case lessK:
    codeEXP( e->val.lessE.left);
    codeEXP( e->val.lessE.right);
    code_if_icmplt(e->val.lessE.truelabel);
    code_ldc_int(0);
    code_goto(e->val.lessE.stoplabel);
    code_label("true",e->val.lessE.truelabel);
    code_ldc_int(1);
    code_label("stop",e->val.lessE.stoplabel);
    break;
  case greaterK:
    codeEXP( e->val.greaterE.left);
    codeEXP( e->val.greaterE.right);
    code_if_icmpgt(e->val.greaterE.truelabel);
    code_ldc_int(0);
    code_goto(e->val.greaterE.stoplabel);
    code_label("true",e->val.greaterE.truelabel);
    code_ldc_int(1);
    code_label("stop",e->val.greaterE.stoplabel);
    break;
  case lequalsK:
    codeEXP( e->val.lequalsE.left);
    codeEXP( e->val.lequalsE.right);
    code_if_icmple(e->val.lequalsE.truelabel);
    code_ldc_int(0);
    code_goto(e->val.lequalsE.stoplabel);
    code_label("true",e->val.lequalsE.truelabel);
    code_ldc_int(1);
    code_label("stop",e->val.lequalsE.stoplabel);
    break;
  case gequalsK:
    codeEXP( e->val.gequalsE.left);
    codeEXP( e->val.gequalsE.right);
    code_if_icmpge(e->val.gequalsE.truelabel);
    code_ldc_int(0);
    code_goto(e->val.gequalsE.stoplabel);
    code_label("true",e->val.gequalsE.truelabel);
    code_ldc_int(1);
    code_label("stop",e->val.gequalsE.stoplabel);
    break;
  case plusK:
    codeEXP( e->val.plusE.left);
    codeEXP( e->val.plusE.right);
    if (e->type->kind==intK) 
      code_iadd(); /* stack -1 (-2 to pop arguments and +1 to push result) */
    else 
      code_aadd();	
    break;
  case minusK:
    codeEXP( e->val.minusE.left);
    codeEXP( e->val.minusE.right);
    code_isub();
    break;
  case multK:
    codeEXP( e->val.multE.left);
    codeEXP( e->val.multE.right);
    code_imul();
    break;
  case divK:
    codeEXP( e->val.divE.left);
    codeEXP( e->val.divE.right);
    code_idiv();
    break;
  case moduloK:
    codeEXP( e->val.moduloE.left);
    codeEXP( e->val.moduloE.right);
    code_irem();
    break;
  case andK:
    /* see tutorial text for more info about the boolean expressions and their templates */
    codeEXP( e->val.andE.left);
    code_dup();
    code_ifeq(e->val.andE.falselabel);
    code_pop();
    codeEXP( e->val.andE.right);
    code_label("false",e->val.andE.falselabel);
    break;
  case orK:
    codeEXP( e->val.orE.left);
    code_dup();
    code_ifne(e->val.orE.truelabel);
    code_pop();
    codeEXP( e->val.orE.right);
    code_label("true",e->val.orE.truelabel);
    break;
  case callK:
    if(e->val.callE.arguments != NULL)
      codeEXP( e->val.callE.arguments);
    code_call(e->val.callE.name, e->val.callE.symbol->val.functionS->signature);
            
    break;
  case castK:
    codeEXP( e->val.castE.exp);
    
    /* if different types (otherwise no need to cast)*/
    if (e->val.castE.type->kind != e->val.castE.exp->type->kind)
      code_cast(e->val.castE.exp->type, e->val.castE.type); 
    
    break;
  } /* end switch */

  if(e->next != NULL)
    codeEXP( e->next);
}





/* Build code for an LVALUE - that is, code to fetch a variable from its store and put it on
   top of the stack. codeLVALUE is actually an expression and thus it leaves the stack height
   one heigher (by its aload and iload opcodes)
   Note that codeLVALUE is only called from codeEXP and it could actually be pasted into that
   function if we wanted. */
void codeLVALUE( LVALUE *l)
{
  switch(l->kind){
  case idK:
    switch(l->symbol->val.declS->kind) { 
      	case formalK:
      	 if (l->type->kind==stringK) 
          code_aload(l->symbol->val.declS->val.formalD.offset);
         else
          code_iload(l->symbol->val.declS->val.formalD.offset);
         break;
      	case variableK:
      	 if (l->type->kind==stringK) 
          code_aload(l->symbol->val.declS->val.variableD.offset);
         else 
          code_iload(l->symbol->val.declS->val.variableD.offset);
      	 break;
      	case simplevarK:
      	 if (l->type->kind==stringK) 
          code_aload(l->symbol->val.declS->val.simplevarD.offset);
         else 
          code_iload(l->symbol->val.declS->val.simplevarD.offset);
      	 break;
     }	
    break;
  }
}

