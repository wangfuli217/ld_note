/* pxdscript pretty.c
 *
 * History:
 * 21.10.2000 - created
 * 22.10.2000 - filled out some funcs'
 * 23.10.2000 - kasper : implemented prettyEXP, prettyIDENTIFIER and prettyLVALUE
 * 23.10.2000 - kasper : we desided to change the order of all lists, functions updated to reflect this.
 * 24.10.2000 - Mads : Setup for indented output.
 * 25.10.2000 - Kasper : all functions implemented
 * 27.10.2000 - Mads : Spaces between toplevels.
 */

#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "pretty.h"
#define TAB_SIZE 2


/* Indented print: (local to this file) */
static void indentprintf(int indent, const char *format, ...)
{
  va_list argList;
  
  /* Indent: */
  printf("%*s", indent*TAB_SIZE, "");
  
  /* Print: */
  va_start(argList, format);
  vprintf(format, argList);
  va_end(argList);
}

void prettyEntity(EntityKind kind) {
	
 switch (kind) {
      	case mdlEntity:
      	   printf("TYPE_MDL");
      	   break;
        case particleEntity:
      	   printf("TYPE_PARTICLE");
      	   break;   
        case playerEntity:
      	   printf("TYPE_PLY");
      	   break;   
        case lightEntity:
      	   printf("TYPE_LIGHT");
      	   break;
      	case cameraEntity:
      	   printf("TYPE_CAMERA");
      	   break;         
      }

}


/* Prettyprinter for each node in the AST: */

void prettyModifierKind(ModifierKind modifierKind)
{
  switch (modifierKind) {
    case noneMod:
      break;
    case constMod:
      printf("const ");
      break;
  }
}


void prettySCRIPTCOLLECTION(SCRIPTCOLLECTION *scriptcollection)
{
  printf("scripts\n{\n");
  #if (PRINTSYMBOL)
  prettySymbolTable(1,scriptcollection->sym);
  #endif
  if (scriptcollection->toplevels != NULL)
    prettyTOPLEVEL(1, scriptcollection->toplevels);
  printf("}\n");
}

void prettyTOPLEVEL(int indent, TOPLEVEL *toplevel)
{
  
  switch(toplevel->kind){
  case programK:
    prettyPROGRAM(indent, toplevel->val.programT);
    break;
  case functionK:
    prettyFUNCTION(indent, toplevel->val.functionT);
    break;
  }
  
  if(toplevel->next != NULL) {
    indentprintf(indent, "\n");
    prettyTOPLEVEL(indent, toplevel->next);
  }
}

void prettyFUNCTION(int indent, FUNCTION *function)
{
  indentprintf(indent, "");
  prettyTYPE(function->type);
  printf("%s(",function->name);
  if (function->formals != NULL)
    prettyDECL(indent, function->formals);
  printf(")\n");
  indentprintf(indent, "{\n");
  #if (PRINTSYMBOL)
    prettySymbolTable(indent+1, function->sym);
  #endif
  if (function->stms != NULL)
    prettySTM(indent+1, function->stms);
  indentprintf(indent, "}\n");
}

void prettyTRIGGER(TRIGGER *trigger)
{
  switch(trigger->kind) {
  case trigger_on_initK :	
    printf("trigger_on_init ");
    break;	
  case trigger_on_clickK :	
    printf("trigger_on_click(\"");
    printf("%s\") ", trigger->name);
    break;	
  case trigger_on_collideK :	
    printf("trigger_on_collide(\"");
    printf("%s\") ", trigger->name);
    break;	
  case trigger_on_pickupK :	
    printf("trigger_on_pickup(\"");
    printf("%s\") ", trigger->name);
    break;	  
  case trigger_neverK :	
    printf("trigger_never ");
    break;	  
  }
}


void prettyPROGRAM(int indent, PROGRAM *program)
{
  indentprintf(indent, "program %s ",program->name);
  if (program->trigger != NULL)
   prettyTRIGGER(program->trigger);
  printf("\n");
 
  indentprintf(indent, "{\n");
  #if (PRINTSYMBOL)
    prettySymbolTable(indent+1, program->sym);
  #endif
  if (program->stms != NULL)
    prettySTM(indent+1, program->stms);
  indentprintf(indent, "}\n");
}

void prettyTYPE(TYPE *type)
{
  switch(type->kind){
  case boolK:
    printf("bool ");
    break;
  case intK:
    printf("int ");
    break;
  case stringK:
    printf("string ");
    break;
  case voidK:
    printf("void ");
    break;
    }
}

void prettyDECL(int indent, DECL *decl)
{
  switch(decl->kind){
  case formalK:
    prettyTYPE(decl->type);
    printf("%s",decl->val.formalD.name);
    if(decl->next != NULL)
      printf(", ");
    break;
  case variableK:
    indentprintf(indent, "");
    prettyModifierKind(decl->val.variableD.modifier);
    prettyTYPE(decl->type);
    prettyIDENTIFIER(decl->val.variableD.identifiers);
    if (decl->val.variableD.initialization != NULL) {
      printf(" = ");
      prettyEXP(decl->val.variableD.initialization);
    }
    printf(";\n");
    break;
  case simplevarK:
    prettyTYPE(decl->type);
    printf("%s",decl->val.simplevarD.name);
    if (decl->val.simplevarD.initialization != NULL) {
      printf(" = ");
      prettyEXP(decl->val.simplevarD.initialization);
    }
    if(decl->next != NULL)
      printf(", ");
    break;
  }
  
  if(decl->next != NULL)
    prettyDECL(indent, decl->next);
}

void prettyFORINIT(int indent, FORINIT *forinit)
{
  switch (forinit->kind) {
  case declforinitK:
    prettyDECL(indent, forinit->val.declforinitF);
    break;
  case expforinitK:
    prettyEXP(forinit->val.expforinitF);
    break;
  }
  
  if (forinit->next != NULL) {
    printf(",");
    prettyFORINIT(indent, forinit->next);
  }
}

void prettySTM(int indent, STM *stm)
{
  switch (stm->kind) {
    case skipK:
      indentprintf(indent, ";\n");
      break;
    case expK:
      indentprintf(indent, "");
      prettyEXP(stm->val.expS);
      printf(";\n");
      break;
     case declstmK:
      prettyDECL(indent, stm->val.declstmS);
      break;
    case returnK:
      indentprintf(indent, "return ");
      if (stm->val.returnS.exp != NULL)
        prettyEXP(stm->val.returnS.exp);
      printf(";\n");
      break;
    case ifK:
      indentprintf(indent, "if (");
      prettyEXP(stm->val.ifS.condition);
      printf(")");
      prettySTM(indent, stm->val.ifS.body);
      break;
    case ifelseK:
      indentprintf(indent, "if (");
      prettyEXP(stm->val.ifelseS.condition);
      printf(")");
      prettySTM(indent, stm->val.ifelseS.thenpart);
      indentprintf(indent, " else ");
      prettySTM(indent, stm->val.ifelseS.elsepart);
      break;
    case whileK:
      indentprintf(indent, "while (");
      prettyEXP(stm->val.whileS.condition);
      printf(") ");
      prettySTM(indent, stm->val.whileS.body);
      break;
    case forK:
      indentprintf(indent, "for (");
      prettyFORINIT(indent, stm->val.forS.inits);
      printf("; ");
      prettyEXP(stm->val.forS.condition);
      printf("; ");
      prettyEXP(stm->val.forS.updates);
      printf(") ");
      prettySTM(indent, stm->val.forS.body);
      break;
  case sequenceK:
      prettySTM(indent, stm->val.sequenceS.first);
      prettySTM(indent, stm->val.sequenceS.second);
      break;
  case scopeK:
      printf("\n");
      indentprintf(indent, "{ /* new scope */\n");
      #if (PRINTSYMBOL)
        prettySymbolTable(indent+2, stm->val.scopeS.sym);
      #endif
      prettySTM(indent+1, stm->val.scopeS.stm);
      indentprintf(indent, "}\n");
      break;
  case setintK:
      indentprintf(indent,"setint(");
      prettyEntity(stm->val.setintS.kind);
      printf(", ");
      prettyEXP(stm->val.setintS.modelname);
      printf(",");      
      prettyEXP(stm->val.setintS.nr);
      printf(",");
      prettyEXP(stm->val.setintS.val);
      printf(")");
      break;
  case sleepK:
      indentprintf(indent,"sleep(");
      prettyEXP(stm->val.sleepS.time);
      printf(")"); 
      break;
   }
}

void prettyIDENTIFIER(IDENTIFIER *identifier)
{
  printf("%s", identifier->name);
 
  if (identifier->next != NULL) {
    printf(",");
    prettyIDENTIFIER(identifier->next);
  }
}

void prettyEXP(EXP *exp)
{ 
  if (exp == NULL)
   return;
  
  switch(exp->kind) {
  case intconstK:
    printf("%i",exp->val.intconstE);   
    break;
  case boolconstK:
    if (exp->val.boolconstE == 1)
      printf("true");
    else
      printf("false");       
    break;
  case stringconstK:
    printf("\"%s\"", exp->val.stringconstE);   
    break;
  case uminusK:
    printf("-");
    prettyEXP(exp->val.uminusE);    
    break;
  case notK:
    printf("!");
    prettyEXP(exp->val.notE.exp);    
    break;
  case lvalueK:
    prettyLVALUE(exp->val.lvalueE);
    break;
  case assignmentK:
    prettyLVALUE(exp->val.assignmentE.left);
    printf("=");
    prettyEXP(exp->val.assignmentE.right);   
    break;
  case equalsK:
    printf("(");
    prettyEXP(exp->val.equalsE.left);
    printf("==");
    prettyEXP(exp->val.equalsE.right);
    printf(")");    
    break;
  case nequalsK:
    printf("(");
    prettyEXP(exp->val.nequalsE.left);
    printf("!=");
    prettyEXP(exp->val.nequalsE.right);
    printf(")");        
    break;
  case lessK:
    printf("(");
    prettyEXP(exp->val.lessE.left);
    printf("<");
    prettyEXP(exp->val.lessE.right);
    printf(")");            
    break;
  case greaterK:
    printf("(");
    prettyEXP(exp->val.greaterE.left);
    printf(">");
    prettyEXP(exp->val.greaterE.right);
    printf(")");         
    break;
  case lequalsK:
    printf("(");
    prettyEXP(exp->val.lequalsE.left);
    printf("<=");
    prettyEXP(exp->val.lequalsE.right);
    printf(")");             
    break;
  case gequalsK:
    printf("(");
    prettyEXP(exp->val.gequalsE.left);
    printf(">=");
    prettyEXP(exp->val.gequalsE.right);
    printf(")");            
    break;
  case plusK:
    printf("(");
    prettyEXP(exp->val.plusE.left);
    printf("+");
    prettyEXP(exp->val.plusE.right);
    printf(")");         
    break;
  case minusK:
    printf("(");
    prettyEXP(exp->val.minusE.left);
    printf("-");
    prettyEXP(exp->val.minusE.right);
    printf(")");       
    break;
  case multK:
    printf("(");
    prettyEXP(exp->val.multE.left);
    printf("*");
    prettyEXP(exp->val.multE.right);
    printf(")");     
    break;
  case divK:
    printf("(");
    prettyEXP(exp->val.divE.left);
    printf("/");
    prettyEXP(exp->val.divE.right);
    printf(")");         
    break;
  case moduloK:
    printf("(");
    prettyEXP(exp->val.moduloE.left);
    printf("%%");
    prettyEXP(exp->val.moduloE.right);
    printf(")");        
    break;
  case andK:
    printf("(");
    prettyEXP(exp->val.andE.left);
    printf("&&");
    prettyEXP(exp->val.andE.right);
    printf(")");       
    break;
  case orK:
    printf("(");
    prettyEXP(exp->val.orE.left);
    printf("||");
    prettyEXP(exp->val.orE.right);
    printf(")");         
    break;
  case callK:
    printf("%s", exp->val.callE.name);
    printf("(");
    if (exp->val.callE.arguments != NULL)
      prettyEXP(exp->val.callE.arguments);
    printf(")");    
    break;
  case castK:
    printf("(");
    prettyTYPE(exp->val.castE.type);
    printf(")");
    prettyEXP(exp->val.castE.exp);    
    break;
  
  }
  
  if(exp->next != NULL) {
    printf(",");  
    prettyEXP(exp->next);  
  }  
}



void prettyLVALUE(LVALUE *lvalue)
{
  switch(lvalue->kind) {
  case idK:
    printf("%s", lvalue->val.idL);   
    break;
  }
}



#if (PRINTSYMBOL)

void prettySymbolTable(int indent, SymbolTable *sym)
{
  int i;
  
  indentprintf(indent, "/*\n");
  indentprintf(indent+1, "SymbolTable:\n");  

  for (i=0; i<HashSize; i++){
    if (sym->table[i] != NULL)
      prettySYMBOL(indent+1, sym->table[i]);
  }
  indentprintf(indent, "*/\n\n");
}

void prettySYMBOL(int indent, SYMBOL *s)
{
  switch(s->kind) {
  case functionSym:
    indentprintf(indent, "Function ");
    break;
  case programSym:
    indentprintf(indent, "Program  ");
    break;
  case declSym:
    indentprintf(indent, "Variable ");
    break;
  }

  printf("%s\n", s->name);

  if (s->next != NULL)
    prettySYMBOL(indent, s->next);
}

#endif
