/* u1comp type.c
 *
 * History:
 * 04.11.2000 - created
 */

#include "type.h"
#include "error.h"
#include "symbol.h"
#include "memory.h"
#include <string.h>
#include "tree.h"
#include "typedef.h"

TYPE *undefinedTYPE;
static TYPE *voidTYPE, *boolTYPE, *intTYPE, *stringTYPE;

void initTypes()
{
  undefinedTYPE = NULL;
  
  voidTYPE = makeTYPEvoid();
  boolTYPE = makeTYPEbool();
  intTYPE = makeTYPEint();
  stringTYPE = makeTYPEstring();
}

char *typeToString(TYPE *t)
{
  switch(t->kind) {
  case boolK:
    return "bool";
  case intK:
    return "int";
  case stringK:
    return "string";
  case voidK:
    return "void";
  }
  
  return "N/A";
}


/* Create a string with the function signature - ie. 'int myfunc(int a, int b)'   */
char *functionToSignatureString(FUNCTION *f)
{
  DECL *formal;
  int stringLength=1;
  char *signature;
  
  /* Count length of formal types: */
  formal = f->formals;
  while (formal != NULL) {
    stringLength += strlen(typeToString(formal->type));
    
    /* Possibly add length of separating comma and space: */
    if (formal->next != NULL)
      stringLength += 2;
    
    formal = formal->next;
  }
  
  /* Add length of return type, function name and parantheses: */
  stringLength += strlen(typeToString(f->type)) + 1 + strlen(f->name) + 2;
  
  /* Construct string: */
  signature = (char*)Malloc(stringLength);
  signature[0] = 0; /* make empty string */
  
  strcat(signature, typeToString(f->type));
  strcat(signature, " ");
  strcat(signature, f->name);
  strcat(signature, "(");
  
  formal = f->formals;
  while (formal != NULL) {
    strcat(signature, typeToString(formal->type));
    
    /* Possibly add separating comma and space: */
    if (formal->next != NULL)
      strcat(signature, ", ");
    
    formal = formal->next;
  }
  
  strcat(signature, ")");
  
  return signature;
}



/* The 'greatest' type of the two */
TYPE *greaterType(TYPE *l, TYPE *r)
{
  
  /* Pass on undefinedTYPE: */
  if (l == undefinedTYPE || r == undefinedTYPE)
    return undefinedTYPE;
  
  /*bool*/
  if(l->kind == boolK && r->kind == boolK)
    return boolTYPE;
  /*int*/
  if(l->kind == intK && r->kind == intK)
    return intTYPE;
  /*string*/
  if(l->kind == stringK && ( r->kind == stringK || r->kind == intK || r->kind == boolK))
    return stringTYPE;
  
  /* l is not greater than or equal to r */
  return undefinedTYPE;
}



TYPE *greatestCommonType(TYPE *t1, TYPE *t2)
{
  TYPE *type;

  if((type = greaterType(t1,t2)) != undefinedTYPE)
    return type;
  else if((type = greaterType(t2,t1)) != undefinedTYPE)
    return type;

  return undefinedTYPE;
}



/* Can we assign right type to left? */
bool assignable(TYPE *left, TYPE *right)
{
  /* undefinedTYPE always yields success: */
  if (left == undefinedTYPE || right == undefinedTYPE)
    return true;
  
  if (greaterType(left, right) != undefinedTYPE)
    return true;
  else
    return false;
}


/* Small function to retrieve the type of a given symbol (from the symbol check phase)*/
TYPE *symbolType(SYMBOL *symbol)
{
  switch(symbol->kind) {
  case functionSym:
    return symbol->val.functionS->type;
  case programSym:
    return voidTYPE;
  case declSym:
    return symbol->val.declS->type;
  }
  
  /* Should not be possible: */
  return undefinedTYPE;
}


/* Is the given type a void type? */
bool voidType(TYPE *type)
{
  /* undefinedTYPE always yields success: */
  if (type == undefinedTYPE)
    return true;
  
  if (type->kind == voidK)
    return true;
  
  return false;
}

/* Is the given type a boolean type? */
bool boolType(TYPE *type)
{
  /* undefinedTYPE always yields success: */
  if (type == undefinedTYPE)
    return true;
  
  if (type->kind == boolK)
    return true;
  
  return false;
}


/* Is the given type a numeric type? (note: in pxdscript this means int) */
bool numericType(TYPE *type)
{
  /* undefinedTYPE always yields success: */
  if (type == undefinedTYPE)
    return true;
  
  if (type->kind == intK)
    return true;
  
  return false;
}

/* Is the given type a int type? */
bool intType(TYPE *type)
{
  /* undefinedTYPE always yields success: */
  if (type == undefinedTYPE)
    return true;
  
  if (type->kind == intK)
    return true;
  
  return false;
}

/* Is the given type a string type? */
bool stringType(TYPE *type)
{
  /* undefinedTYPE always yields success: */
  if (type == undefinedTYPE)
    return true;
  
  if (type->kind == stringK)
    return true;
  
  return false;
}


/* Here you define the casting rules of your language. 
   Remember that what you deside here you have to pay for later
   by coding the code needed to maintain these rules ;) */
bool validCast(TYPE *source, TYPE *dest) {

  /* rules for cast int -> ?? */
  if (source->kind == intK)
    if (dest->kind == stringK || dest->kind == intK)
      return true;
  
   /* rules for cast string -> ?? */
  if (source->kind == stringK)
    if (dest->kind == intK || dest->kind == stringK )
      return true;
  
   /* rules for cast bool -> ?? */
  if (source->kind == boolK)
    if (dest->kind == stringK || dest->kind == boolK)
      return true;

  return false;
}




void typeSCRIPTCOLLECTION(SCRIPTCOLLECTION *s)
{
  /* Initialize the type structures we'll use to compare with in this phase */
  initTypes();
  
  /* Check all toplevels */
  if(s->toplevels != NULL)
    typeTOPLEVEL(s->toplevels);
}

void typeTOPLEVEL(TOPLEVEL *t)
{
  /* Which kind of toplevel? */
  switch(t->kind){
  case functionK:
    typeFUNCTION(t->val.functionT);
    break;
  case programK:
    typePROGRAM(t->val.programT);
    break;
  }

  if(t->next != NULL)
    typeTOPLEVEL(t->next);
}


void typeFUNCTION(FUNCTION *f)
{
  if(f->formals != NULL)
    typeDECL(f->formals);

  if(f->stms != NULL)
    typeSTM(f->stms, f->type);
}


void typePROGRAM(PROGRAM *s)
{
  if(s->stms != NULL)
    typeSTM(s->stms, voidTYPE);
}



/* Note that at this point the two variable types are treated identically. Originally the differences were
   that the simplevar could not have any modifiers (const) and you could not declare a list of variables
   (int x,t,b;). 
   The 'const' issue is not to be checked here (in the initialization) and in the weeding phase we translated
   a declaration like above into a bunch of single declarations... */
void typeDECL(DECL *d)
{
   
  switch(d->kind){
  case formalK:
    break;
  case variableK:
    if(d->val.variableD.initialization != NULL){
      typeEXP(d->val.variableD.initialization);
        
      if (!assignable(d->type, d->val.variableD.initialization->type))
        reportError(d->lineno, "Cannot assign %s value to %s lvalue",
		  typeToString(d->val.variableD.initialization->type), 
		  typeToString(d->type));
    
      if (d->type != undefinedTYPE && d->val.variableD.initialization->type != undefinedTYPE) {
        /* make implicit casts explicit */
        if (d->val.variableD.initialization->type->kind != d->type->kind){
      	   d->val.variableD.initialization = makeEXPcast(d->type, d->val.variableD.initialization);
	   d->val.variableD.initialization->type = d->type;
        }
      } 
    }
    break;
  case simplevarK:
    if(d->val.simplevarD.initialization != NULL) {
      typeEXP(d->val.simplevarD.initialization);
      
      if (!assignable(d->type, d->val.simplevarD.initialization->type))
        reportError(d->lineno, "Cannot assign %s value to %s lvalue",
		  typeToString(d->val.simplevarD.initialization->type), 
		  typeToString(d->type));

      if (d->type != undefinedTYPE && d->val.simplevarD.initialization->type != undefinedTYPE) {
        /* make implicit casts explicit */
        if (d->val.simplevarD.initialization->type->kind != d->type->kind){
      	   d->val.simplevarD.initialization = makeEXPcast(d->type, d->val.simplevarD.initialization);
	   d->val.simplevarD.initialization->type = d->type;
        }
      }
    }        
    break;
  }
  
  if(d->next != NULL)
    typeDECL(d->next);
    
   
}

void typeFORINIT(FORINIT *f)
{
  switch(f->kind){
  case declforinitK:
    typeDECL(f->val.declforinitF);
    break;
  case expforinitK:
    typeEXP(f->val.expforinitF);
    break;
  }

  if(f->next != NULL)
    typeFORINIT(f->next);
}



void typeSTM(STM *s, TYPE *returnType)
{
  switch(s->kind){
  case skipK:
    break;
  case expK:
    typeEXP(s->val.expS);
    break;
  case declstmK:
    typeDECL(s->val.declstmS);
    break;
  case returnK:
    if(s->val.returnS.exp != NULL){
      typeEXP(s->val.returnS.exp);
      if(!assignable(returnType, s->val.returnS.exp->type))
	reportError(s->lineno, "Function must return expression of type %s", 
		    typeToString(returnType));
    }
    else if(!voidType(returnType))
      reportError(s->lineno, "Function must return expression of type %s", 
		  typeToString(returnType));
    break;
  case ifK:
    typeEXP(s->val.ifS.condition);
    typeSTM(s->val.ifS.body, returnType);
    
    if (!boolType(s->val.ifS.condition->type))
      reportError(s->lineno, "Condition in if statement must be of type bool");
    break;
  case ifelseK:
    typeEXP(s->val.ifelseS.condition);
    typeSTM(s->val.ifelseS.thenpart, returnType);
    typeSTM(s->val.ifelseS.elsepart, returnType);
    
    if (!boolType(s->val.ifelseS.condition->type))
      reportError(s->lineno, "Condition in if statement must be of type bool");
    break;
  case whileK:
    typeEXP(s->val.whileS.condition);
    typeSTM(s->val.whileS.body, returnType);
    
    if (!boolType(s->val.whileS.condition->type))
      reportError(s->lineno, "Condition in while statement must be of type bool");
    break;
  case forK:
    typeFORINIT(s->val.forS.inits);
    typeEXP(s->val.forS.condition);
    typeEXP(s->val.forS.updates);
    typeSTM(s->val.forS.body, returnType);
    
    if (!boolType(s->val.forS.condition->type))
      reportError(s->lineno, "Condition in for statement must be of type bool");
    break;
  case sequenceK:
    typeSTM(s->val.sequenceS.first, returnType);
    typeSTM(s->val.sequenceS.second, returnType);
    break;
  case scopeK:
    typeSTM(s->val.scopeS.stm, returnType);
    break;
  case setintK:  
    typeEXP(s->val.setintS.modelname);
    typeEXP(s->val.setintS.nr);
    typeEXP(s->val.setintS.val);
    
    if (!intType(s->val.setintS.nr->type) || !intType(s->val.setintS.val->type) ||
        !stringType(s->val.setintS.modelname->type))
      reportError(s->lineno, "setint takes a type, a string and two integer arguments (type, modelname, nr, val)");
    
    break;
  case sleepK:
   typeEXP(s->val.sleepS.time);
   
   /* s->val.sleepS.time will be NULL if we use sleep without any params - ie. sleep(); */
   if (s->val.sleepS.time != NULL && !intType(s->val.sleepS.time->type))
     reportError(s->lineno, "sleep takes an integer argument (msec to sleep)");
    break;
  }
}


void typeEXP(EXP *e)
{
  struct TYPE *type;
  int argumentNo;
  struct DECL *currentFormal;
  struct EXP **currentArgument;
 
  if (e == NULL)
   return;	

   
  
  switch (e->kind) {
  case intconstK:
    e->type = intTYPE;
    break;
  case boolconstK:
    e->type = boolTYPE;
    break;
  case stringconstK:
    e->type = stringTYPE;
    break;
  case uminusK:
    typeEXP(e->val.uminusE);
    
    e->type = e->val.uminusE->type;
    if (!numericType(e->type)) {
      reportError(e->lineno, "int or float type expected with unary minus operator");
      e->type = undefinedTYPE;
    }
    break;
  case notK:
    typeEXP(e->val.notE.exp);

    if (!boolType(e->val.notE.exp->type))
      reportError(e->lineno, "bool type expected with '!' operator");
    e->type = boolTYPE;
    break;
  case lvalueK:
    typeLVALUE(e->val.lvalueE);
    e->type = e->val.lvalueE->type;
    break;
  case assignmentK:
    typeLVALUE(e->val.assignmentE.left);
    typeEXP(e->val.assignmentE.right);
   
    if (e->val.assignmentE.left->modifier == constMod)
      reportError(e->lineno, "Cannot assign to const variable '%s'", e->val.assignmentE.left->val.idL); /* (only normal variables can be const) */
    
    e->type = e->val.assignmentE.left->type;
    type = e->val.assignmentE.right->type;
    if (!assignable(e->type, type))
      reportError(e->lineno, "Cannot assign %s value to %s lvalue",
		  typeToString(type), 
		  typeToString(e->type));
    
    if (e->type != undefinedTYPE && type != undefinedTYPE) {
      /* make implicit casts explicit */
      if (type->kind != e->type->kind){
      	e->val.assignmentE.right = makeEXPcast(e->type, e->val.assignmentE.right);
	      e->val.assignmentE.right->type = e->type;
      }
    }
    break;
  case equalsK:
    typeEXP(e->val.equalsE.left);
    typeEXP(e->val.equalsE.right);
    
    e->type = greatestCommonType(e->val.equalsE.left->type, e->val.equalsE.right->type);
    
    if (e->type == undefinedTYPE) {
      if (e->val.equalsE.left->type != undefinedTYPE  && e->val.equalsE.right->type != undefinedTYPE) {
	        reportError(e->lineno, "Cannot compare expressions of types %s and %s", 
		                  typeToString(e->val.equalsE.left->type), 
		                  typeToString(e->val.equalsE.right->type));
          break;
      }
    }

    /* make implicit casts explicit */
    if (e->val.equalsE.left->type->kind != e->type->kind){
      e->val.equalsE.left = makeEXPcast(e->type, e->val.equalsE.left);
      e->val.equalsE.left->type = e->type;
    }
    if (e->val.equalsE.right->type->kind != e->type->kind){
      e->val.equalsE.right = makeEXPcast(e->type, e->val.equalsE.right);
      e->val.equalsE.right->type = e->type;
    }

    e->type = boolTYPE;
    break;
  case nequalsK:
    typeEXP(e->val.nequalsE.left);
    typeEXP(e->val.nequalsE.right);

    e->type = greatestCommonType(e->val.equalsE.left->type, e->val.equalsE.right->type);
    
    if (e->type == undefinedTYPE) {
      if (e->val.nequalsE.left->type != undefinedTYPE && e->val.nequalsE.right->type != undefinedTYPE) {
	      reportError(e->lineno, "Cannot compare expressions of types %s and %s", 
		                typeToString(e->val.nequalsE.left->type), 
		                typeToString(e->val.nequalsE.right->type));
		    break;            
      }
    }
    /* make implicit casts explicit */
    if (e->val.equalsE.left->type->kind != e->type->kind){
      e->val.nequalsE.left = makeEXPcast(e->type, e->val.nequalsE.left);
      e->val.nequalsE.left->type = e->type;
    }
    if (e->val.nequalsE.right->type->kind != e->type->kind){
      e->val.nequalsE.right = makeEXPcast(e->type, e->val.nequalsE.right);
      e->val.nequalsE.right->type = e->type;
    }

    e->type = boolTYPE;
    break;
  case lessK:
    typeEXP(e->val.lessE.left);
    typeEXP(e->val.lessE.right);

    if(!numericType(e->val.lessE.left->type) || !numericType(e->val.lessE.right->type)) 
      reportError(e->lineno, "Cannot compare %s with %s", 
		  typeToString(e->val.lessE.left->type), 
		  typeToString(e->val.lessE.right->type));

    /* make implicit casts explicit */
    type = greatestCommonType(e->val.lessE.left->type, e->val.lessE.right->type);

    if (e->type != undefinedTYPE){
      if (e->val.lessE.left->type->kind != type->kind){
	       e->val.lessE.left = makeEXPcast(type, e->val.lessE.left);
	       e->val.lessE.left->type = type;
      }
      if (e->val.lessE.right->type->kind != type->kind){
	       e->val.lessE.right = makeEXPcast(type, e->val.lessE.right);
	       e->val.lessE.right->type = type;
      }
    }

    e->type = boolTYPE;
    break;
  case greaterK:
    typeEXP(e->val.greaterE.left);
    typeEXP(e->val.greaterE.right);

    if(!numericType(e->val.greaterE.left->type) || !numericType(e->val.greaterE.right->type)) 
      reportError(e->lineno, "Cannot compare %s with %s", 
		  typeToString(e->val.greaterE.left->type), 
		  typeToString(e->val.greaterE.right->type));


    /* make implicit casts explicit */
    type = greatestCommonType(e->val.greaterE.left->type, e->val.greaterE.right->type);

    if (e->type != undefinedTYPE){
      if (e->val.greaterE.left->type->kind != type->kind){
	e->val.greaterE.left = makeEXPcast(type, e->val.greaterE.left);
	e->val.greaterE.left->type = type;
      }
      if (e->val.greaterE.right->type->kind != type->kind){
	e->val.greaterE.right = makeEXPcast(type, e->val.greaterE.right);
	e->val.greaterE.right->type = type;
      }
    }
    e->type = boolTYPE;
    break;
  case lequalsK:
    typeEXP(e->val.lequalsE.left);
    typeEXP(e->val.lequalsE.right);

    if(!numericType(e->val.lequalsE.left->type) || !numericType(e->val.lequalsE.right->type)) 
      reportError(e->lineno, "Cannot compare %s with %s", 
		  typeToString(e->val.lequalsE.left->type), 
		  typeToString(e->val.lequalsE.right->type));
    /* make implicit casts explicit */
    type = greatestCommonType(e->val.lequalsE.left->type, e->val.lequalsE.right->type);

    if (e->type != undefinedTYPE){
      if (e->val.lequalsE.left->type->kind != type->kind){
	e->val.lequalsE.left = makeEXPcast(type, e->val.lequalsE.left);
	e->val.lequalsE.left->type = type;
      }
      if (e->val.lequalsE.right->type->kind != type->kind){
	e->val.lequalsE.right = makeEXPcast(type, e->val.lequalsE.right);
	e->val.lequalsE.right->type = type;
      }
    }
    e->type = boolTYPE;
    break;
  case gequalsK:
    typeEXP(e->val.gequalsE.left);
    typeEXP(e->val.gequalsE.right);

    if(!numericType(e->val.gequalsE.left->type) || !numericType(e->val.gequalsE.right->type) ) 
      reportError(e->lineno, "Cannot compare %s with %s", 
		  typeToString(e->val.gequalsE.left->type), 
		  typeToString(e->val.gequalsE.right->type));

    /* make implicit casts explicit */
    type = greatestCommonType(e->val.gequalsE.left->type, e->val.gequalsE.right->type);

    if (e->type != undefinedTYPE){
      if (e->val.gequalsE.left->type->kind != type->kind){
	e->val.gequalsE.left = makeEXPcast(type, e->val.gequalsE.left);
	e->val.gequalsE.left->type = type;
      }
      if (e->val.gequalsE.right->type->kind != type->kind){
	e->val.gequalsE.right = makeEXPcast(type, e->val.gequalsE.right);
	e->val.gequalsE.right->type = type;
      }
    }
    e->type = boolTYPE;
    break;
  case plusK:
    printf("left exp kind: %i\n", e->val.plusE.left->kind);
    printf("right exp kind: %i\n", e->val.plusE.right->kind);
    
    typeEXP(e->val.plusE.left);
    typeEXP(e->val.plusE.right);
    
    e->type = greatestCommonType(e->val.plusE.left->type, e->val.plusE.right->type);
    
    if (e->type == undefinedTYPE) {
      if (e->val.plusE.left->type != undefinedTYPE 
	  && e->val.plusE.right->type != undefinedTYPE) {
	reportError(e->lineno, "Cannot add expressions of types %s and %s", 
		    typeToString(e->val.plusE.left->type), 
		    typeToString(e->val.plusE.right->type));
	e->type = undefinedTYPE;
      }
    }
    
    /* make implicit casts explicit */
    if (e->type != undefinedTYPE){
      if (e->val.equalsE.left->type->kind != e->type->kind){
	e->val.equalsE.left = makeEXPcast(e->type, e->val.equalsE.left);
	e->val.equalsE.left->type = e->type;
      }
      if (e->val.equalsE.right->type->kind != e->type->kind){
	e->val.equalsE.right = makeEXPcast(e->type, e->val.equalsE.right);
	e->val.equalsE.right->type = e->type;
      }
    }
    break;
  case minusK:
    typeEXP(e->val.minusE.left);
    typeEXP(e->val.minusE.right);

    e->type = greatestCommonType(e->val.minusE.left->type, e->val.minusE.right->type);
    
    if (e->type == undefinedTYPE || !numericType(e->type)) {
      if (e->val.minusE.left->type != undefinedTYPE 
	  && e->val.minusE.right->type != undefinedTYPE) {
	reportError(e->lineno, "Cannot subtract expressions of types %s and %s", 
		    typeToString(e->val.minusE.left->type), 
		    typeToString(e->val.minusE.right->type));
	e->type = undefinedTYPE;
      }
    }
    /* make implicit casts explicit */
    if (e->type != undefinedTYPE){
      if (e->val.minusE.left->type->kind != e->type->kind){
	e->val.minusE.left = makeEXPcast(e->type, e->val.minusE.left);
	e->val.minusE.left->type = e->type;
      }
      if (e->val.minusE.right->type->kind != e->type->kind){
	e->val.minusE.right = makeEXPcast(e->type, e->val.minusE.right);
	e->val.minusE.right->type = e->type;
      }
    }
    break;
  case multK:
    typeEXP(e->val.multE.left);
    typeEXP(e->val.multE.right);

    e->type = greatestCommonType(e->val.multE.left->type, e->val.multE.right->type);
    
    if (e->type == undefinedTYPE || !numericType(e->type)) {
      if (e->val.multE.left->type != undefinedTYPE 
	  && e->val.multE.right->type != undefinedTYPE) {
	reportError(e->lineno, "Cannot multiply expressions of types %s and %s", 
		    typeToString(e->val.multE.left->type), 
		    typeToString(e->val.multE.right->type));
	e->type = undefinedTYPE;
      }
    }
    /* make implicit casts explicit */
    if (e->type != undefinedTYPE){
      if (e->val.multE.left->type->kind != e->type->kind){
	e->val.multE.left = makeEXPcast(e->type, e->val.multE.left);
	e->val.multE.left->type = e->type;
      }
      if (e->val.multE.right->type->kind != e->type->kind){
	e->val.multE.right = makeEXPcast(e->type, e->val.multE.right);
	e->val.multE.right->type = e->type;
      }
    }
    break;
  case divK:
    typeEXP(e->val.divE.left);
    typeEXP(e->val.divE.right);
    
    e->type = greatestCommonType(e->val.divE.left->type, e->val.divE.right->type);
    
    if (e->type == undefinedTYPE || !numericType(e->type)) {
      if (e->val.divE.left->type != undefinedTYPE 
	  && e->val.divE.right->type != undefinedTYPE) {
	reportError(e->lineno, "Cannot divide expressions of types %s and %s", 
		    typeToString(e->val.divE.left->type), 
		    typeToString(e->val.divE.right->type));
	e->type = undefinedTYPE;
      }
    }

    /* make implicit casts explicit */
    if (e->type != undefinedTYPE){
      if (e->val.divE.left->type->kind != e->type->kind){
	e->val.divE.left = makeEXPcast(e->type, e->val.divE.left);
	e->val.divE.left->type = e->type;
      }
      if (e->val.divE.right->type->kind != e->type->kind){
	e->val.divE.right = makeEXPcast(e->type, e->val.divE.right);
	e->val.divE.right->type = e->type;
      }
    }
    break;
  case moduloK:
    typeEXP(e->val.moduloE.left);
    typeEXP(e->val.moduloE.right);

    if (!intType(e->val.moduloE.left->type) || !intType(e->val.moduloE.right->type))
      reportError(e->lineno, "int types expected for '%%' operator");

    e->type = intTYPE;
    break;
  case andK:
    typeEXP(e->val.andE.left);
    typeEXP(e->val.andE.right);

    if(!boolType(e->val.andE.left->type) || !boolType(e->val.andE.right->type))
      reportError(e->lineno, "bool types expected for '&&' operator");

    e->type = boolTYPE;
    break;
  case orK:
    typeEXP(e->val.orE.left);
    typeEXP(e->val.orE.right);

    if(!boolType(e->val.orE.left->type) || !boolType(e->val.orE.right->type))
      reportError(e->lineno, "bool types expected for '||' operator");

    e->type = boolTYPE;
    break;
  case callK:
   
    if (e->val.callE.arguments != NULL)
      typeEXP(e->val.callE.arguments);
   
    if (e->val.callE.symbol->kind == functionSym) {
      /* It is a function */
      
      /* Check argument types against formal types: */
      argumentNo=1;
      currentFormal = e->val.callE.symbol->val.functionS->formals;
      currentArgument = &(e->val.callE.arguments);
      
      while (currentFormal != NULL && (*currentArgument) != NULL) {
	/* Test if current argument is assignable to current formal */
	if(!assignable(currentFormal->type, (*currentArgument)->type)) {
	  reportError(e->lineno,
		      "Argument %d cannot be assigned to formal %d in function '%s'",
		      argumentNo,
		      argumentNo,
		      functionToSignatureString(e->val.callE.symbol->val.functionS));

	}

	// make implicit casts explicit 
	type = greaterType(currentFormal->type, (*currentArgument)->type);
	if (type == undefinedTYPE) // if no greater type we know there has been an error and bails
	  break;
	
	
	if ((*currentArgument)->type->kind != type->kind){
	  *currentArgument = makeEXPcast(currentFormal->type, *currentArgument);
	  (*currentArgument)->type = currentFormal->type;
	}
	// Next: 
	argumentNo++;
	currentFormal = currentFormal->next;
	currentArgument = &((*currentArgument)->next);
      }
      
      // Report argument count errors: 
      if (currentFormal != NULL && (*currentArgument) == NULL)
	reportError(e->lineno, "Too few arguments to function '%s'",
		    functionToSignatureString(e->val.callE.symbol->val.functionS));
      else if (currentFormal == NULL && (*currentArgument) != NULL)
	reportError(e->lineno, "Too many arguments to function '%s'",
		    functionToSignatureString(e->val.callE.symbol->val.functionS));
    } else {
      // It is a program 
      reportError(e->lineno, "Programs cannot be called");
    }
    
    // Set expression's type to the returntype of the function: 
    e->type = symbolType(e->val.callE.symbol);
    break;
  case castK:
    typeEXP(e->val.castE.exp);
   
    if (e->val.castE.exp->type == undefinedTYPE || e->val.castE.type == undefinedTYPE)
      break;
   
    if (validCast(e->val.castE.exp->type, e->val.castE.type) == false)
      reportError(e->lineno, "cannot cast expression of type %s to type %s",
		  typeToString(e->val.castE.exp->type), typeToString(e->val.castE.type));
    else { 
      e->type = e->val.castE.type;
    }
    break;
 
  } // end switch 
 
  
  if(e->next != NULL)
    typeEXP(e->next);
    
}



void typeLVALUE(LVALUE *l)
{
  
  switch(l->kind){
  case idK:
    l->type = symbolType(l->symbol);
  break;
  }
}

