/* pxdscript symbol.c
 *
 * History:
 */
#include <string.h>
#include "symbol.h"
#include "memory.h"
#include "error.h"


/* The hash-code function */
int Hash(char *str)
{ unsigned int hash = 0;
  while (*str) hash = (hash << 1) + *str++; 
  return hash % HashSize;
}

/* Create and initialize an empty symbol table. */
SymbolTable *initSymbolTable()
{ SymbolTable *t;
  int i;
  t = NEW(SymbolTable);
  for (i=0; i < HashSize; i++) t->table[i] = NULL;
  t->parent = NULL;
  return t;
}

/* Add a empty child symbol table to the linked list of symbol tables. This
   is done when entering a new scope level */
SymbolTable *scopeSymbolTable(SymbolTable *parent)
{ SymbolTable *t;
  t = initSymbolTable();
  t->parent = parent;
  return t;
}


SYMBOL *putSymbol(SymbolTable *t, char *name, SymbolKind kind)
{ 
  int i;
  SYMBOL *s;
  i = Hash(name);
  for (s = t->table[i]; s; s = s->next) {
      if (strcmp(s->name,name)==0) return s;
  }
  s = NEW(SYMBOL);
  s->name = name;
  s->kind = kind;
  s->next = t->table[i];
  t->table[i] = s;
  return s;
}
 
 
SYMBOL *getSymbol(SymbolTable *t, char *name)
{ int i;
  SYMBOL *s;
  i = Hash(name);
  for (s = t->table[i]; s; s = s->next) {
      if (strcmp(s->name,name)==0) return s;
  }
  if (t->parent==NULL) return NULL;
  return getSymbol(t->parent,name);
}
 
 
 
int defSymbol(SymbolTable *t, char *name)
{ int i;
  SYMBOL *s;
  i = Hash(name);
  for (s = t->table[i]; s; s = s->next) {
      if (strcmp(s->name,name)==0) return 1;
  }
  return 0;
}



/* the functions that build the symboltable */



/* The main function for the symbol checking phase. */
void symSCRIPTCOLLECTION(SCRIPTCOLLECTION *s)
{
  sym1PassSCRIPTCOLLECTION(s);
  /* call errorCheck to make sure that parsetree is valid */
  errorCheck();
  sym2PassSCRIPTCOLLECTION(s);
}

/*** First pass: ***/

void sym1PassSCRIPTCOLLECTION(SCRIPTCOLLECTION *s)
{
  s->sym = initSymbolTable();
  
  if (s->toplevels != NULL)
    sym1PassTOPLEVEL(s->toplevels, s->sym);
}

void sym1PassTOPLEVEL(TOPLEVEL *t, SymbolTable *sym)
{
  switch (t->kind) {
  case functionK:
    sym1PassFUNCTION(t->val.functionT, sym);
    break;
  case programK:
    sym1PassPROGRAM(t->val.programT, sym);
    break;
  }
  
  if (t->next != NULL)
    sym1PassTOPLEVEL(t->next, sym);
}

void sym1PassFUNCTION(FUNCTION *f, SymbolTable *sym)
{
  struct SYMBOL *symbol;
  
  if (defSymbol(sym, f->name)) {
    reportError(f->lineno, "Duplicate declaration of function '%s'", f->name);
  } else {
    symbol = putSymbol(sym, f->name, functionSym);
    symbol->val.functionS = f;
    
    f->sym = scopeSymbolTable(sym);
    if (f->formals != NULL)
      sym1PassDECL(f->formals, f->sym);
    if (f->stms != NULL)   
      sym1PassSTM(f->stms, f->sym);
  }
}

void sym1PassPROGRAM(PROGRAM *s, SymbolTable *sym)
{
  struct SYMBOL *symbol;
    
  if (defSymbol(sym, s->name)) {
    reportError(s->lineno, "Duplicate declaration of program '%s'", s->name);
  } else {
    symbol = putSymbol(sym, s->name, programSym);
    symbol->val.programS = s;
    
    s->sym = scopeSymbolTable(sym);
    if (s->stms != NULL)    
     sym1PassSTM(s->stms, s->sym);
    
  }
}


void sym1PassDECL(DECL *d, SymbolTable *sym)
{
  struct SYMBOL *symbol;
  
  switch (d->kind) {
  case formalK:
    if (defSymbol(sym, d->val.formalD.name))
      reportError(d->lineno, "Duplicate declaration of formal '%s'", d->val.formalD.name);
    else {
      symbol = putSymbol(sym, d->val.formalD.name, declSym);
      symbol->val.declS = d;
    }
    break;
  case variableK:
    /* Recurse on initialization first, so the variable declared is not used there. 
       (Otherwise int i = i; would be valid) */
    if (d->val.variableD.initialization != NULL)    
      sym1PassEXP(d->val.variableD.initialization, sym);

    sym1PassIDENTIFIER(d->val.variableD.identifiers, d, sym);

    d->val.variableD.symbol = getSymbol(sym, d->val.variableD.identifiers->name);
    break;
  case simplevarK:
    /* Recurse on initialization first, so the variable declared is not used there. */
    if (d->val.simplevarD.initialization != NULL)    
      sym1PassEXP(d->val.simplevarD.initialization, sym);
    
    if (defSymbol(sym, d->val.simplevarD.name))
      reportError(d->lineno, "Duplicate declaration of variable '%s'", d->val.simplevarD.name);
    else {
      symbol = putSymbol(sym, d->val.simplevarD.name, declSym);
      symbol->val.declS = d;
    }
    break;
  }
  
  if (d->next != NULL)
    sym1PassDECL(d->next, sym);
}

void sym1PassFORINIT(FORINIT *f, SymbolTable *sym)
{
  switch (f->kind) {
  case declforinitK:
    sym1PassDECL(f->val.declforinitF, sym);
    break;
  case expforinitK:
    sym1PassEXP(f->val.expforinitF, sym);
    break;
  }
  
  if (f->next != NULL)
    sym1PassFORINIT(f->next, sym);
}

void sym1PassSTM(STM *s, SymbolTable *sym)
{
  
  switch (s->kind) {
   case skipK:
    break;
  case expK:
    sym1PassEXP(s->val.expS, sym);
    break;
  case declstmK:
    sym1PassDECL(s->val.declstmS, sym);
    break;
  case returnK:
    if(s->val.returnS.exp != NULL)
      sym1PassEXP(s->val.returnS.exp, sym);
    break;
  case ifK:
    sym1PassEXP(s->val.ifS.condition, sym);
    sym1PassSTM(s->val.ifS.body, sym);
    break;
  case ifelseK:
    sym1PassEXP(s->val.ifelseS.condition, sym);
    sym1PassSTM(s->val.ifelseS.thenpart, sym);
    sym1PassSTM(s->val.ifelseS.elsepart, sym);
    break;
  case whileK:
    sym1PassEXP(s->val.whileS.condition, sym);
    sym1PassSTM(s->val.whileS.body, sym);
    break;
  case forK:
    sym1PassFORINIT(s->val.forS.inits, sym);
    sym1PassEXP(s->val.forS.condition, sym);
    sym1PassEXP(s->val.forS.updates, sym);
    sym1PassSTM(s->val.forS.body, sym);
    break;
  case sequenceK:
    sym1PassSTM(s->val.sequenceS.first, sym);
    sym1PassSTM(s->val.sequenceS.second, sym);
    break;
  case scopeK:
    /* Create an empty symbol table, add to the list and call on the statements inside
       the scope with the new, empty symbol table. */
    s->val.scopeS.sym = scopeSymbolTable(sym);
    sym1PassSTM(s->val.scopeS.stm, s->val.scopeS.sym);
    break;
  case setintK:
    sym1PassEXP(s->val.setintS.modelname, sym);
    sym1PassEXP(s->val.setintS.nr, sym);
    sym1PassEXP(s->val.setintS.val, sym);
    break;
  case sleepK:
    sym1PassEXP(s->val.sleepS.time, sym);  
    break;
  }
}

void sym1PassIDENTIFIER(IDENTIFIER *i, DECL *decl, SymbolTable *sym)
{
  struct SYMBOL *symbol;
  
  if (defSymbol(sym, i->name)) {
    reportError(i->lineno, "Duplicate declaration of variable '%s'", i->name);
  } else {
    symbol = putSymbol(sym, i->name, declSym);
    symbol->val.declS = decl;
  }
  
  if (i->next != NULL)
    sym1PassIDENTIFIER(i->next, decl, sym);
}

void sym1PassEXP(EXP * e, SymbolTable *sym) 
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
    sym1PassEXP(e->val.uminusE, sym);
    break;
  case notK:
    sym1PassEXP(e->val.notE.exp, sym);
    break;
  case lvalueK:
    sym1PassLVALUE(e->val.lvalueE, sym);    
    break;
  case assignmentK:
    sym1PassLVALUE(e->val.assignmentE.left, sym);
    sym1PassEXP(e->val.assignmentE.right, sym);
    break;
  case equalsK:
    sym1PassEXP(e->val.equalsE.left, sym);
    sym1PassEXP(e->val.equalsE.right, sym);    
    break;
  case nequalsK:
    sym1PassEXP(e->val.nequalsE.left, sym);
    sym1PassEXP(e->val.nequalsE.right, sym);    
    break;
  case lessK:
    sym1PassEXP(e->val.lessE.left, sym);
    sym1PassEXP(e->val.lessE.right, sym);    
    break;
  case greaterK:
    sym1PassEXP(e->val.greaterE.left, sym);
    sym1PassEXP(e->val.greaterE.right, sym);    
    break;
  case lequalsK:
    sym1PassEXP(e->val.lequalsE.left, sym);
    sym1PassEXP(e->val.lequalsE.right, sym);    
    break;
  case gequalsK:
    sym1PassEXP(e->val.gequalsE.left, sym);
    sym1PassEXP(e->val.gequalsE.right, sym);    
    break;
  case plusK:
    sym1PassEXP(e->val.plusE.left, sym);
    sym1PassEXP(e->val.plusE.right, sym);    
    break;
  case minusK:
    sym1PassEXP(e->val.minusE.left, sym);
    sym1PassEXP(e->val.minusE.right, sym);    
    break;
  case multK:
    sym1PassEXP(e->val.multE.left, sym);
    sym1PassEXP(e->val.multE.right, sym);    
    break;
  case divK:
    sym1PassEXP(e->val.divE.left, sym);
    sym1PassEXP(e->val.divE.right, sym);    
    break;
  case moduloK:
    sym1PassEXP(e->val.moduloE.left, sym);
    sym1PassEXP(e->val.moduloE.right, sym);    
    break;
  case andK:
    sym1PassEXP(e->val.andE.left, sym);
    sym1PassEXP(e->val.andE.right, sym);    
    break;
  case orK:
    sym1PassEXP(e->val.orE.left, sym);
    sym1PassEXP(e->val.orE.right, sym);    
    break;
  case callK:
    /* function name check is in 2nd pass */
    if (e->val.callE.arguments != NULL) 
      sym1PassEXP(e->val.callE.arguments, sym);    
    break;
  case castK:
    sym1PassEXP(e->val.castE.exp, sym);   
    break;
  } /* end switch */
  
  if (e->next != NULL)
    sym1PassEXP(e->next, sym);

}


void sym1PassLVALUE(LVALUE *l, SymbolTable *sym) 
{
  SYMBOL *symbol;
  switch(l->kind) {
  case idK:
    symbol = getSymbol(sym, l->val.idL);
    if (symbol == NULL)
      reportError(l->lineno, "Variable '%s' is referenced but not defined", l->val.idL);    
    else {
      if (symbol->kind != declSym)
	reportError(l->lineno, "Identifier '%s' is not a variable", 
		    l->val.idL);
      else { 
	l->symbol = symbol;
  
	/* Set the modifier: */
	if (l->symbol->val.declS->kind == variableK)
	  l->modifier = l->symbol->val.declS->val.variableD.modifier;
	else
	  l->modifier = noneMod;
      }
    }
   break;
 }
}


/*** Second pass: ***/

void sym2PassSCRIPTCOLLECTION(SCRIPTCOLLECTION *s)
{
  if (s->toplevels != NULL)
    sym2PassTOPLEVEL(s->toplevels, s->sym);
}

void sym2PassTOPLEVEL(TOPLEVEL *t, SymbolTable *sym)
{
  switch (t->kind) {
  case functionK:
    sym2PassFUNCTION(t->val.functionT, sym);
    break;
  case programK:
    sym2PassPROGRAM(t->val.programT, sym);
    break;
  }
  
  if (t->next != NULL)
    sym2PassTOPLEVEL(t->next, sym);
}

void sym2PassFUNCTION(FUNCTION *f, SymbolTable *sym)
{
  if (f->stms != NULL)   
    sym2PassSTM(f->stms, f->sym);
}

void sym2PassPROGRAM(PROGRAM *s, SymbolTable *sym)
{
  if (s->stms != NULL)   
    sym2PassSTM(s->stms, s->sym);
}

void sym2PassDECL(DECL *d, SymbolTable *sym)
{
  switch (d->kind) {
  case formalK:
    break;
  case variableK:
    if (d->val.variableD.initialization != NULL)    
      sym2PassEXP(d->val.variableD.initialization, sym);
    break;
  case simplevarK:
    if (d->val.simplevarD.initialization != NULL)    
      sym2PassEXP(d->val.simplevarD.initialization, sym);
    break;
  }
  
  if (d->next != NULL)
    sym2PassDECL(d->next, sym);
}

void sym2PassFORINIT(FORINIT *f, SymbolTable *sym)
{
  switch (f->kind) {
  case declforinitK:
    sym2PassDECL(f->val.declforinitF, sym);
    break;
  case expforinitK:
    sym2PassEXP(f->val.expforinitF, sym);
    break;
  }
  
  if (f->next != NULL)
    sym2PassFORINIT(f->next, sym);
}

void sym2PassSTM(STM *s, SymbolTable *sym)
{
  switch (s->kind) {
  case skipK:
    break;
  case expK:
    sym2PassEXP(s->val.expS, sym);
    break;
  case declstmK:
    sym2PassDECL(s->val.declstmS, sym);
    break;
  case returnK:
    if(s->val.returnS.exp != NULL)
      sym2PassEXP(s->val.returnS.exp, sym);
    break;
  case ifK:
    sym2PassEXP(s->val.ifS.condition, sym);
    sym2PassSTM(s->val.ifS.body, sym);
    break;
  case ifelseK:
    sym2PassEXP(s->val.ifelseS.condition, sym);
    sym2PassSTM(s->val.ifelseS.thenpart, sym);
    sym2PassSTM(s->val.ifelseS.elsepart, sym);
    break;
  case whileK:
    sym2PassEXP(s->val.whileS.condition, sym);
    sym2PassSTM(s->val.whileS.body, sym);
    break;
  case forK:
    sym2PassFORINIT(s->val.forS.inits, sym);
    sym2PassEXP(s->val.forS.condition, sym);
    sym2PassEXP(s->val.forS.updates, sym);
    sym2PassSTM(s->val.forS.body, sym);
    break;
  case sequenceK:
    sym2PassSTM(s->val.sequenceS.first, sym);
    sym2PassSTM(s->val.sequenceS.second, sym);
    break;
  case scopeK:
    sym2PassSTM(s->val.scopeS.stm, s->val.scopeS.sym);
    break;
  case setintK:
    sym2PassEXP(s->val.setintS.modelname, sym);
    sym2PassEXP(s->val.setintS.nr, sym);
    sym2PassEXP(s->val.setintS.val, sym);
    break;
  case sleepK:
    sym2PassEXP(s->val.sleepS.time, sym);
    break;
  }
}

void sym2PassEXP(EXP * e, SymbolTable *sym) 
{
  SYMBOL *symbol;
  if(e == NULL)
   return;
      
  switch (e->kind) {
  case intconstK:
    break;
  case boolconstK:
    break;
  case stringconstK:
    break;
  case uminusK:
    sym2PassEXP(e->val.uminusE, sym);
    break;
  case notK:
    sym2PassEXP(e->val.notE.exp, sym);
    break;
  case lvalueK:
    break;
  case assignmentK:
    sym2PassEXP(e->val.assignmentE.right, sym);
    break;
  case equalsK:
    sym2PassEXP(e->val.equalsE.left, sym);
    sym2PassEXP(e->val.equalsE.right, sym);    
    break;
  case nequalsK:
    sym2PassEXP(e->val.nequalsE.left, sym);
    sym2PassEXP(e->val.nequalsE.right, sym);    
    break;
  case lessK:
    sym2PassEXP(e->val.lessE.left, sym);
    sym2PassEXP(e->val.lessE.right, sym);    
    break;
  case greaterK:
    sym2PassEXP(e->val.greaterE.left, sym);
    sym2PassEXP(e->val.greaterE.right, sym);    
    break;
  case lequalsK:
    sym2PassEXP(e->val.lequalsE.left, sym);
    sym2PassEXP(e->val.lequalsE.right, sym);    
    break;
  case gequalsK:
    sym2PassEXP(e->val.gequalsE.left, sym);
    sym2PassEXP(e->val.gequalsE.right, sym);    
    break;
  case plusK:
    sym2PassEXP(e->val.plusE.left, sym);
    sym2PassEXP(e->val.plusE.right, sym);    
    break;
  case minusK:
    sym2PassEXP(e->val.minusE.left, sym);
    sym2PassEXP(e->val.minusE.right, sym);    
    break;
  case multK:
    sym2PassEXP(e->val.multE.left, sym);
    sym2PassEXP(e->val.multE.right, sym);    
    break;
  case divK:
    sym2PassEXP(e->val.divE.left, sym);
    sym2PassEXP(e->val.divE.right, sym);    
    break;
  case moduloK:
    sym2PassEXP(e->val.moduloE.left, sym);
    sym2PassEXP(e->val.moduloE.right, sym);    
    break;
  case andK:
    sym2PassEXP(e->val.andE.left, sym);
    sym2PassEXP(e->val.andE.right, sym);    
    break;
  case orK:
    sym2PassEXP(e->val.orE.left, sym);
    sym2PassEXP(e->val.orE.right, sym);    
    break;
  case callK:
    /* do function name check now */
    symbol = getSymbol(sym, e->val.callE.name);
    
    if (symbol == NULL)
      reportError(e->lineno, "Function or program '%s' is referenced but not defined",  e->val.callE.name);
    else if (symbol->kind != functionSym && symbol->kind != programSym)
      reportError(e->lineno, "Trying to use variable %s as a function", e->val.callE.name);
    else
      e->val.callE.symbol = symbol;
    
    if (e->val.callE.arguments != NULL) 
      sym2PassEXP(e->val.callE.arguments, sym);    
    break;
  case castK:
    sym2PassEXP(e->val.castE.exp, sym);   
    break;
  } /* end switch */
  
  if (e->next != NULL)
    sym2PassEXP(e->next, sym);
}



