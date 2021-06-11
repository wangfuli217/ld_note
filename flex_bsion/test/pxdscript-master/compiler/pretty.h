#ifndef __PRETTY_H__
#define __PRETTY_H__


/* wig pretty.h
 *
 * History:
 * 21.10.2000 - created
 */

#define PRINTSYMBOL 0


#include <stdio.h>
#include "tree.h"

#if (PRINTSYMBOL)
#include "symbol.h"
#endif


void prettyModifierKind(ModifierKind modifierKind);
void prettySCRIPTCOLLECTION(SCRIPTCOLLECTION *scriptcollection);
void prettyTOPLEVEL(int indent, TOPLEVEL *toplevel);
void prettyFUNCTION(int indent, FUNCTION *function);
void prettyTRIGGER(TRIGGER *trigger);
void prettyPROGRAM(int indent, PROGRAM *program);
void prettyTYPE(TYPE *type);
void prettyDECL(int indent, DECL *decl);
void prettyFORINIT(int indent, FORINIT *forinit);
void prettySTM(int indent, STM *stm);
void prettyIDENTIFIER(IDENTIFIER *identifier);
void prettyEXP(EXP *exp);
void prettyLVALUE(LVALUE *lvalue);
/*
void prettySymbolTable(int indent, SymbolTable *sym);
void prettySYMBOL(int indent, SYMBOL *s);
*/
#endif
