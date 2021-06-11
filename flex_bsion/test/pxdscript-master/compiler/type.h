#ifndef __TYPE_H__
#define __TYPE_H__

/* wig type.h
 *
 * History:
 * 04.11.2000 - created
 */

#include "tree.h"
#include "error.h"

extern TYPE *undefinedTYPE; 

TYPE *greaterType(TYPE *l, TYPE *r);

void typeSCRIPTCOLLECTION(SCRIPTCOLLECTION *s);
void typeTOPLEVEL(TOPLEVEL *t);
void typeFUNCTION(FUNCTION *f);
void typePROGRAM(PROGRAM *s);
void typeDECL(DECL *d);
void typeFORINIT(FORINIT *f);
void typeSTM(STM *stm, TYPE *returnType);
void typeEXP(EXP *e);
void typeLVALUE(LVALUE *l);

#endif
