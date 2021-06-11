/* pxdscript weed.c
 *
 * History:
 * 30.10.2000 - created, made framework for recursing through tree, weeds doublescope
 */

#include "weed.h"
#include "error.h"

void weedSCRIPTCOLLECTION(SCRIPTCOLLECTION *s)
{
  if(s->toplevels != NULL)
    weedTOPLEVEL(s->toplevels);
}

void weedTOPLEVEL(TOPLEVEL *t)
{
  switch(t->kind){
  case functionK:
    weedFUNCTION(t->val.functionT);
    break;
  case programK:
    weedPROGRAM(t->val.programT);
    break;
  }

  if(t->next != NULL)
    weedTOPLEVEL(t->next);
}

void weedFUNCTION(FUNCTION *f)
{
  if(f->formals != NULL)
    weedDECL(f->formals);
  if(f->stms != NULL) {
    weedSTM(f->stms);
    if (weedSTMCheckReturns(f->stms) == false && f->type->kind != voidK )
      reportError(f->lineno,"Function must return a value");
  }
}

void weedPROGRAM(PROGRAM *s)
{
  if(s->stms != NULL)
    weedSTM(s->stms);
}


void weedDECL(DECL *d)
{
  DECL *temp;
  switch(d->kind){
  case formalK:
    break;
  case variableK:
    /* turn a list of identifiers into a list of decl's for easier emitting */
    if (d->val.variableD.identifiers->next != NULL) {
      temp = d->next;
      d->next = makeDECLvariable(d->val.variableD.modifier, 
				 d->type, 
				 d->val.variableD.identifiers->next, 
				 d->val.variableD.initialization);
      d->val.variableD.identifiers->next = NULL;
      d->next->next = temp;
    }
    weedIDENTIFIER(d->val.variableD.identifiers);
    if(d->val.variableD.initialization != NULL)
      weedEXP(d->val.variableD.initialization);
    break;
  case simplevarK:
    if(d->val.simplevarD.initialization != NULL)
      weedEXP(d->val.simplevarD.initialization);
    break;
  }

  if(d->next != NULL)
    weedDECL(d->next);
}

void weedFORINIT(FORINIT *f)
{
  switch(f->kind){
  case declforinitK:
    weedDECL(f->val.declforinitF);
    break;
  case expforinitK:
    weedEXP(f->val.expforinitF);
    break;
  }

  if(f->next != NULL)
    weedFORINIT(f->next);
}




bool weedSTMCheckReturns(STM *s)
{
  switch(s->kind){
  case returnK:
    return true;
  case ifelseK:
    return (weedSTMCheckReturns(s->val.ifelseS.thenpart) &&
            weedSTMCheckReturns(s->val.ifelseS.elsepart)); 
  case sequenceK:
    if (weedSTMCheckReturns(s->val.sequenceS.first) == true) {
      reportWarning(s->lineno, "Unreachable code");
      return true;
    } else
      return weedSTMCheckReturns(s->val.sequenceS.second); 
  case scopeK:
    return weedSTMCheckReturns(s->val.scopeS.stm);
  
  default: 
   return false;
  }
  return false;
}






void weedSTM(STM *s)
{
  switch(s->kind){
  case skipK:
    break;
  case expK:
    weedEXP(s->val.expS);
    break;
  case declstmK:
    weedDECL(s->val.declstmS);
    break;
  case returnK:
    if(s->val.returnS.exp != NULL)
      weedEXP(s->val.returnS.exp);
    break;
  case ifK:
    weedEXP(s->val.ifS.condition);
    weedSTM(s->val.ifS.body);
    break;
  case ifelseK:
    weedEXP(s->val.ifelseS.condition);
    weedSTM(s->val.ifelseS.thenpart);
    weedSTM(s->val.ifelseS.elsepart);
    break;
  case whileK:
    weedEXP(s->val.whileS.condition);
    weedSTM(s->val.whileS.body);
    break;
  case forK:
    weedFORINIT(s->val.forS.inits);
    weedEXP(s->val.forS.condition);
    weedEXP(s->val.forS.updates);
    weedSTM(s->val.forS.body);
    break;
  case sequenceK:
    weedSTM(s->val.sequenceS.first);
    weedSTM(s->val.sequenceS.second);
    break;
  case scopeK:
    /* weed 'doublescopes' */
    if(s->val.scopeS.stm->kind == scopeK){
      s->val.scopeS.stm = s->val.scopeS.stm->val.scopeS.stm;
    }
    weedSTM(s->val.scopeS.stm);
    break;
  case setintK:
    weedEXP(s->val.setintS.modelname);
    weedEXP(s->val.setintS.nr);
    weedEXP(s->val.setintS.val);
    break;
  case sleepK:
    weedEXP(s->val.sleepS.time);
    break;
  }
}

void weedIDENTIFIER(IDENTIFIER *i)
{
  if(i->next != NULL)
    weedIDENTIFIER(i->next);
}

void weedEXP(EXP *e)
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
    weedEXP(e->val.uminusE);
    break;
  case notK:
    weedEXP(e->val.notE.exp);
    break;
  case lvalueK:
    break;
  case assignmentK:
    weedEXP(e->val.assignmentE.right);
    break;
  case equalsK:
    weedEXP(e->val.equalsE.left);
    weedEXP(e->val.equalsE.right);
    break;
  case nequalsK:
    weedEXP(e->val.nequalsE.left);
    weedEXP(e->val.nequalsE.right);
    break;
  case lessK:
    weedEXP(e->val.lessE.left);
    weedEXP(e->val.lessE.right);
    break;
  case greaterK:
    weedEXP(e->val.greaterE.left);
    weedEXP(e->val.greaterE.right);
    break;
  case lequalsK:
    weedEXP(e->val.lequalsE.left);
    weedEXP(e->val.lequalsE.right);
    break;
  case gequalsK:
    weedEXP(e->val.gequalsE.left);
    weedEXP(e->val.gequalsE.right);
    break;
  case plusK:
    weedEXP(e->val.plusE.left);
    weedEXP(e->val.plusE.right);
    break;
  case minusK:
    weedEXP(e->val.minusE.left);
    weedEXP(e->val.minusE.right);
    break;
  case multK:
    weedEXP(e->val.multE.left);
    weedEXP(e->val.multE.right);
    break;
  case divK:
    weedEXP(e->val.divE.left);
    weedEXP(e->val.divE.right);
    break;
  case moduloK:
    weedEXP(e->val.moduloE.left);
    weedEXP(e->val.moduloE.right);
    break;
  case andK:
    weedEXP(e->val.andE.left);
    weedEXP(e->val.andE.right);
    break;
  case orK:
    weedEXP(e->val.orE.left);
    weedEXP(e->val.orE.right);
    break;
  case callK:
    if(e->val.callE.arguments != NULL)
      weedEXP(e->val.callE.arguments);
    break;
  case castK:
    weedEXP(e->val.castE.exp);
    break;
  } /* end switch */

  if(e->next != NULL)
    weedEXP(e->next);
}







