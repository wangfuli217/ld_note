/* u1comp resource.c
 *
 * History:
 * 30.10.2000 - created, made framework for recursing through tree, ress doublescope
 */

#include "resource.h"
#include "error.h"

/* ****************** UTILITY FUNCTIONS ******************** */

int label;
int offset;
int localslimit;

int nextlabel()
{ return label++;
}

int nextoffset()
{ offset++;
  if (offset > localslimit) localslimit = offset;
  return offset;
}


/* **************** RECURSION ********************** */



void resSCRIPTCOLLECTION(SCRIPTCOLLECTION *s)
{
  if(s->toplevels != NULL)
    resTOPLEVEL(s->toplevels);
}

void resTOPLEVEL(TOPLEVEL *t)
{
  switch(t->kind){
  case functionK:
    resFUNCTION(t->val.functionT);
    break;
  case programK:
    resPROGRAM(t->val.programT);
    break;
  }

  if(t->next != NULL)
    resTOPLEVEL(t->next);
}

void resFUNCTION(FUNCTION *f)
{
  offset = 0;
  localslimit = 0;
  label = 0;
    
  if(f->formals != NULL)
    resDECL(f->formals);
  
  if(f->stms != NULL) 
    resSTM(f->stms);
  
  f->labelcount = label;
  /* +1 because offset is zero-based, but count should be actual number of locals */
  f->localslimit = localslimit+1; 
  

}

void resPROGRAM(PROGRAM *s)
{
  offset = 0;
  localslimit = 0;
  label = 0;
  
  if(s->stms != NULL)
    resSTM(s->stms);
  
  s->labelcount = label;
  s->localslimit = localslimit+1;
  
}


void resDECL(DECL *d)
{
  switch(d->kind){
  case formalK:
    d->val.formalD.offset = nextoffset();
    break;
  case variableK:
    /* at this point no difference because of weeding */
    d->val.variableD.offset = nextoffset();
      
    if(d->val.variableD.initialization != NULL)
      resEXP(d->val.variableD.initialization);
    break;
  case simplevarK:
    
    d->val.simplevarD.offset = nextoffset();
  
    if(d->val.simplevarD.initialization != NULL)
      resEXP(d->val.simplevarD.initialization);
    break;
  }

  if(d->next != NULL)
    resDECL(d->next);
}

void resFORINIT(FORINIT *f)
{
  switch(f->kind){
  case declforinitK:
    /* a declaration like 'int a=0' */
    resDECL(f->val.declforinitF);
    break;
  case expforinitK:
    /* an expression on existing variables 'a=0' */
    resEXP(f->val.expforinitF);
    break;
  }

  if(f->next != NULL)
    resFORINIT(f->next);
}


void resSTM(STM *s)
{
  int baseoffset;
  
  switch(s->kind){
  case skipK:
    break;
  case expK:
    resEXP(s->val.expS);
    break;
  case declstmK:
    resDECL(s->val.declstmS);
    break;
  case returnK:
    if(s->val.returnS.exp != NULL)
      resEXP(s->val.returnS.exp);
    break;
  case ifK:
    s->val.ifS.stoplabel = nextlabel();
    resEXP(s->val.ifS.condition);
    resSTM(s->val.ifS.body);
    break;
  case ifelseK:
    s->val.ifelseS.elselabel = nextlabel();
    s->val.ifelseS.stoplabel = nextlabel();
    resEXP(s->val.ifelseS.condition);
    resSTM(s->val.ifelseS.thenpart);
    resSTM(s->val.ifelseS.elsepart);
    break;
  case whileK:
    s->val.whileS.startlabel = nextlabel();
    s->val.whileS.stoplabel = nextlabel();
    resEXP(s->val.whileS.condition);
    resSTM(s->val.whileS.body);
    break;
  case forK:
    s->val.forS.startlabel = nextlabel();
    s->val.forS.stoplabel = nextlabel();
    resFORINIT(s->val.forS.inits);
    resEXP(s->val.forS.condition);
    resEXP(s->val.forS.updates);
    resSTM(s->val.forS.body);
    break;
  case sequenceK:
    resSTM(s->val.sequenceS.first);
    resSTM(s->val.sequenceS.second);
    break;
  case scopeK:
    /* Notice how we save offset to be able to go back to it */
    baseoffset = offset;
    resSTM(s->val.scopeS.stm);
    offset = baseoffset;
    break;
  case setintK:
    resEXP(s->val.setintS.modelname);
    resEXP(s->val.setintS.nr);
    resEXP(s->val.setintS.val);
    break;
  case sleepK:
    resEXP(s->val.sleepS.time);
    break;
  }
}


void resEXP(EXP *e)
{
  if (e == NULL)
    return;
  
  switch (e->kind) {
  case intconstK:
    break;
  case boolconstK:
    break;
  case stringconstK:
    break;
  case uminusK:
    resEXP(e->val.uminusE);
    break;
  case notK:
    e->val.notE.truelabel = nextlabel();
    e->val.notE.stoplabel = nextlabel();
    resEXP(e->val.notE.exp);
    break;
  case lvalueK:
    break;
  case assignmentK:
    resEXP(e->val.assignmentE.right);
    break;
  case equalsK:
    e->val.equalsE.truelabel = nextlabel();
    e->val.equalsE.stoplabel = nextlabel();
    resEXP(e->val.equalsE.left);
    resEXP(e->val.equalsE.right);
    break;
  case nequalsK:
    e->val.nequalsE.truelabel = nextlabel();
    e->val.nequalsE.stoplabel = nextlabel();
    resEXP(e->val.nequalsE.left);
    resEXP(e->val.nequalsE.right);
    break;
  case lessK:
    e->val.lessE.truelabel = nextlabel();
    e->val.lessE.stoplabel = nextlabel();
    resEXP(e->val.lessE.left);
    resEXP(e->val.lessE.right);
    break;
  case greaterK:
    e->val.greaterE.truelabel = nextlabel();
    e->val.greaterE.stoplabel = nextlabel();
    resEXP(e->val.greaterE.left);
    resEXP(e->val.greaterE.right);
    break;
  case lequalsK:
    e->val.lequalsE.truelabel = nextlabel();
    e->val.lequalsE.stoplabel = nextlabel();
    resEXP(e->val.lequalsE.left);
    resEXP(e->val.lequalsE.right);
    break;
  case gequalsK:
    e->val.gequalsE.truelabel = nextlabel();
    e->val.gequalsE.stoplabel = nextlabel();
    resEXP(e->val.gequalsE.left);
    resEXP(e->val.gequalsE.right);
    break;
  case plusK:
    resEXP(e->val.plusE.left);
    resEXP(e->val.plusE.right);
    break;
  case minusK:
    resEXP(e->val.minusE.left);
    resEXP(e->val.minusE.right);
    break;
  case multK:
    resEXP(e->val.multE.left);
    resEXP(e->val.multE.right);
    break;
  case divK:
    resEXP(e->val.divE.left);
    resEXP(e->val.divE.right);
    break;
  case moduloK:
    resEXP(e->val.moduloE.left);
    resEXP(e->val.moduloE.right);
    break;
  case andK:
    e->val.andE.falselabel = nextlabel();
    resEXP(e->val.andE.left);
    resEXP(e->val.andE.right);
    break;
  case orK:
    e->val.orE.truelabel = nextlabel();
    resEXP(e->val.orE.left);
    resEXP(e->val.orE.right);
    break;
  case callK:
    if(e->val.callE.arguments != NULL)
      resEXP(e->val.callE.arguments);
    break;
  case castK:
    resEXP(e->val.castE.exp);
    break;
  } /* end switch */

  if(e->next != NULL)
    resEXP(e->next);
}



