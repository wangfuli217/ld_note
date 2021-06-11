/* pxdscript emit.c
 *
 * History:
  */

#include "emit.h"
#include "memory.h"
#include "error.h"

/* ************************* UTILITY FUNCTIONS *************************** */

/* a few globals */
FILE *emitFILE;
LABEL *emitLabels;  /* a pointer to the labels of the function or program we're currently emitting */
static int maxStackSize; /* Used in limitCODE() */


static int max(int a, int b) {
  if (a < b)
    return b;
  else
    return a;
}



/* We emit as symbolic assembly code so we use label names instead of their addresses */
void emitLABEL(int label)
{ fprintf(emitFILE,"%s_%i",emitLabels[label].name,label);
}


/* For those opcodes who has special versions for commonly used arguments */
void localmem(char *opcode, int offset)
{ 
	/*
	if (offset >=0 && offset <=3) {
     fprintf(emitFILE,"%s_%i",opcode,offset);
  } else {
  */	
  fprintf(emitFILE,"%s %i",opcode,offset);
  //}
}


/* calculate the total stack change a function call will result in based on the
   signature we calculated during code generation (chapter 8) */
static int signature2StackChange(char *signature)
{
  int stackChange = 0;
    
  /* Seek to Parameters: */
  while (*signature != '(')
    signature++;

  signature++;
    
  /* Count the parameters: Each parameter reduce stack height by 1*/
  while (*signature != ')'){
    stackChange--;
    signature++;
  }
    
  /* Check the return type: if non-void stack change is increased by 1 as we
     leave the result on the stack */
  signature++;
  if (*signature != 'V')
    stackChange++;
    
  /* Account for the object reference too: */
  stackChange--;

  return stackChange;
}





/* This is the recursive function which calculates the max stack change */
static void findLimit(CODE *c, int currentSize)
{
  /* only adjust & recurse if we haven't already visited this CODE node. */ 
  if (!c->visited){ 
    c->visited = 1;

    switch(c->kind){
    case nopCK:
      /* no changes */
      break;
    case imulCK: 
      currentSize -= 1;
      break;
    case inegCK: 
      /* no changes */
      break;
    case iremCK: 
      currentSize -= 1;
      break;
    case isubCK: 
      currentSize -= 1;
      break;
    case idivCK: 
      currentSize -= 1;
      break;
    case iaddCK: 
      currentSize -= 1;
      break;
    case aaddCK: 
      currentSize -= 1;
      break;  
    case labelCK: 
      /* no changes */
      break;
    case gotoCK: 
      findLimit(emitLabels[c->val.gotoC].position, currentSize);
      /* Stop recursion */
      return;
    case ifeqCK: 
      currentSize -= 1;
      findLimit(emitLabels[c->val.ifeqC].position, currentSize);
      break;
    case ifneCK: 
      currentSize -= 1;
      findLimit(emitLabels[c->val.ifneC].position, currentSize);
      break;
    case if_acmpeqCK: 
      currentSize -= 2;
      findLimit(emitLabels[c->val.if_acmpeqC].position, currentSize);
      break;
    case if_acmpneCK: 
      currentSize -= 2;
      findLimit(emitLabels[c->val.if_acmpneC].position, currentSize);
      break;
    case if_icmpeqCK: 
      currentSize -= 2;
      findLimit(emitLabels[c->val.if_icmpeqC].position, currentSize);
      break;
    case if_icmpgtCK: 
      currentSize -= 2;
      findLimit(emitLabels[c->val.if_icmpgtC].position, currentSize);
      break;
    case if_icmpltCK: 
      currentSize -= 2;
      findLimit(emitLabels[c->val.if_icmpltC].position, currentSize);
      break;
    case if_icmpleCK: 
      currentSize -= 2;
      findLimit(emitLabels[c->val.if_icmpleC].position, currentSize);
      break;
    case if_icmpgeCK: 
      currentSize -= 2;
      findLimit(emitLabels[c->val.if_icmpgeC].position, currentSize);
      break;
    case if_icmpneCK: 
      currentSize -= 2;
      findLimit(emitLabels[c->val.if_icmpneC].position, currentSize);
      break;
    case ireturnCK: 
      /* stop recursion */
      return;
    case areturnCK: 
      /* stop recursion */
      return;
    case returnCK: 
      /* stop recursion */
      return;
    case aloadCK: 
      currentSize += 1;
      maxStackSize = max(currentSize, maxStackSize);
      break;
    case astoreCK: 
      currentSize -= 1;
      break;
    case iloadCK: 
      currentSize += 1;
      maxStackSize = max(currentSize, maxStackSize);
      break;
    case istoreCK: 
      currentSize -= 1;
      break;
    case dupCK: 
      currentSize += 1;
      maxStackSize = max(currentSize, maxStackSize);
      break;
    case popCK: 
      currentSize -= 1;
      break;
    case ldc_intCK: 
      currentSize += 1;
      maxStackSize = max(currentSize, maxStackSize);
      break;
    case ldc_stringCK: 
      currentSize += 1;
      maxStackSize = max(currentSize, maxStackSize);
      break;
    case callCK: 
      currentSize += signature2StackChange(c->val.callVals.callSignatureC);
      maxStackSize = max(currentSize, maxStackSize);
      break;
    case setint_mdlCK:
      currentSize -= 3;
      break; 
    case setint_particleCK:
      currentSize -= 3;
      break; 
    case setint_plyCK:
      currentSize -= 3;
      break; 
    case setint_lightCK:
      currentSize -= 3;
      break; 
    case setint_camCK:
      currentSize -= 3;
      break; 
    case sleepCK:
      currentSize -= 1;
      break;
    case sleep_trigCK:
      break;
    case cast_inttostringCK:
      break;
    case cast_stringtointCK:
      break;
    case cast_booltostringCK:
      break;
    
    }
    
    /* continue along the CODEs next pointer */
    if(c->next != NULL)
      findLimit(c->next, currentSize);
  }
}

int limitCODE(CODE *c)
{
  maxStackSize = 0;
  findLimit(c, 0);
  return maxStackSize;
}


void emitCODE(CODE *c)
{ if (c!=NULL) {
     fprintf(emitFILE,"  ");
     switch(c->kind) {
       case nopCK:
            fprintf(emitFILE,"nop");
            break;
       case imulCK:
            fprintf(emitFILE,"imul");
            break;
       case inegCK:
            fprintf(emitFILE,"ineg");
            break;
       case iremCK:
            fprintf(emitFILE,"irem");
            break;
       case isubCK:
            fprintf(emitFILE,"isub");
            break;
       case idivCK:
            fprintf(emitFILE,"idiv");
            break;
       case iaddCK:
            fprintf(emitFILE,"iadd");
            break;
       case aaddCK:
            fprintf(emitFILE,"aadd");
            break;     
       case labelCK:
            emitLABEL(c->val.labelC);
            fprintf(emitFILE,":");
            break;
       case gotoCK:
            fprintf(emitFILE,"goto ");
            emitLABEL(c->val.gotoC);
            break;
       case ifeqCK:
            fprintf(emitFILE,"ifeq ");
            emitLABEL(c->val.ifeqC);
            break;
       case ifneCK:
            fprintf(emitFILE,"ifne ");
            emitLABEL(c->val.ifneC);
            break;
       case if_acmpeqCK:
            fprintf(emitFILE,"if_acmpeq ");
            emitLABEL(c->val.if_acmpeqC);
            break;
       case if_acmpneCK:
            fprintf(emitFILE,"if_acmpne ");
            emitLABEL(c->val.if_acmpneC);
            break;
       case if_icmpeqCK:
            fprintf(emitFILE,"if_icmpeq ");
            emitLABEL(c->val.if_icmpeqC);
            break;
       case if_icmpgtCK:
            fprintf(emitFILE,"if_icmpgt ");
            emitLABEL(c->val.if_icmpgtC);
            break;
       case if_icmpltCK:
            fprintf(emitFILE,"if_icmplt ");
            emitLABEL(c->val.if_icmpltC);
            break;
       case if_icmpleCK:
            fprintf(emitFILE,"if_icmple ");
            emitLABEL(c->val.if_icmpleC);
            break;
       case if_icmpgeCK:
            fprintf(emitFILE,"if_icmpge ");
            emitLABEL(c->val.if_icmpgeC);
            break;
       case if_icmpneCK:
            fprintf(emitFILE,"if_icmpne ");
            emitLABEL(c->val.if_icmpneC);
            break;
       case ireturnCK:
            fprintf(emitFILE,"ireturn");
            break;
       case areturnCK:
            fprintf(emitFILE,"areturn");
            break;
       case returnCK:
            fprintf(emitFILE,"return");
            break;
       case aloadCK:
            localmem("aload",c->val.aloadC);
            break;
       case astoreCK:
            localmem("astore",c->val.astoreC);
            break;
       case iloadCK:
            localmem("iload",c->val.iloadC);
            break;
       case istoreCK:
            localmem("istore",c->val.istoreC);
            break;
       case dupCK:
            fprintf(emitFILE,"dup");
            break;
       case popCK:
            fprintf(emitFILE,"pop");
            break;
       case ldc_intCK:
            if (c->val.ldc_intC >= 0 && c->val.ldc_intC <= 5) {
               fprintf(emitFILE,"iconst_%i",c->val.ldc_intC);
            } else {
               fprintf(emitFILE,"ldc_int %i",c->val.ldc_intC);
            }
            break;
       case ldc_stringCK:
            fprintf(emitFILE,"ldc_string \"%s\"",c->val.ldc_stringC);
            break;
       case callCK:
            fprintf(emitFILE,"call %s",c->val.callVals.callC);
            break;
       case setint_mdlCK:
            fprintf(emitFILE,"setint_mdl");
            break;
       case setint_particleCK:
            fprintf(emitFILE,"setint_particle");
            break;
       case setint_plyCK:
            fprintf(emitFILE,"setint_ply");
            break;
       case setint_lightCK:
            fprintf(emitFILE,"setint_light");
            break;
       case setint_camCK:
            fprintf(emitFILE,"setint_cam");
            break;
       case sleepCK:
            fprintf(emitFILE,"sleep");
            break;     
       case sleep_trigCK:
            fprintf(emitFILE,"sleep_trig");
            break;
       case cast_inttostringCK:
            fprintf(emitFILE,"cast_inttostring");
            break;          
       case cast_stringtointCK:
            fprintf(emitFILE,"cast_stringtoint");
            break;          
       case cast_booltostringCK:
            fprintf(emitFILE,"cast_booltostring");
            break;          
     
     }
     fprintf(emitFILE,"\n");
     emitCODE(c->next);
  }
}

void emitTYPE(TYPE *t)
{ switch (t->kind) {
    case intK:
         fprintf(emitFILE,"I");
         break;
    case boolK:
         fprintf(emitFILE,"B");
         break;
    case voidK:
         fprintf(emitFILE,"V");
         break;
    case stringK:
         fprintf(emitFILE,"S");
         break;
  }
}




/* ************************ TREE RECURSION ************************ */




/* Entry point for emitter module */
void emitSCRIPTCOLLECTION(SCRIPTCOLLECTION *s)
{
  /* open the file we'll emit to */
  emitFILE = fopen("emitted.a","w");
   
  if(s->toplevels != NULL)
    emitTOPLEVEL(s->toplevels);

  fclose(emitFILE);
}



void emitTOPLEVEL(TOPLEVEL *t)
{
  switch(t->kind){
  case functionK:
    emitFUNCTION(t->val.functionT);
    break;
  case programK:
    emitPROGRAM(t->val.programT);
    break;
  }

  if(t->next != NULL)
    emitTOPLEVEL(t->next);
}




void emitFUNCTION(FUNCTION *f)
{
   
  fprintf(emitFILE,".function %s%s\n",f->name, f->signature); /* the signature from code generation (chapter 8) */
  
  fprintf(emitFILE,"  .limit_locals %i\n",f->localslimit);    /* the locals limit from resource module (chapter 7)*/
  
  emitLabels = f->labels; /* set the global label variable to give easy access to the right labels in emitCODE */
  
  if (f->opcodes != NULL) { 
    fprintf(emitFILE,"  .limit_stack %i\n",limitCODE(f->opcodes));  /* calculate the stack limit (done in this module) */
    emitCODE(f->opcodes);
  }
  fprintf(emitFILE,".end_function\n\n");
 
}




void emitPROGRAM(PROGRAM *p)
{
 fprintf(emitFILE,".program %s\n", p->name);
 
 /* Emit the correct trigger type */
 switch(p->trigger->kind) {
  case trigger_neverK:
    fprintf(emitFILE,"  .trigger_never\n");	
    break;
  case trigger_on_initK:
    fprintf(emitFILE,"  .trigger_on_init\n");
    break;
  case trigger_on_clickK:
    fprintf(emitFILE,"  .trigger_on_click \"%s\"\n", p->trigger->name);
    break;
  case trigger_on_collideK:
    fprintf(emitFILE,"  .trigger_on_collide \"%s\"\n", p->trigger->name);
    break;
  case trigger_on_pickupK:
    fprintf(emitFILE,"  .trigger_on_pickup \"%s\"\n", p->trigger->name);
    break;     	 
 }
 
 fprintf(emitFILE,"  .limit_locals %i\n",p->localslimit); /* from resource module */
 
 emitLabels = p->labels;
 
 if (p->opcodes != NULL) {
  fprintf(emitFILE,"  .limit_stack %i\n",limitCODE(p->opcodes));  /* calculate the stack limit */
  emitCODE(p->opcodes);
 }
 fprintf(emitFILE,".end_program\n\n");
}







