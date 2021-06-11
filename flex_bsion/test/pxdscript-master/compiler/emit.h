#ifndef __EMIT_H__
#define __EMIT_H__

/* u1comp emit.h
 *
 * History:
 * 30.10.2000 - created
 */

#include "tree.h"
#include "typedef.h"

void emitSCRIPTCOLLECTION(SCRIPTCOLLECTION *s);
void emitTOPLEVEL(TOPLEVEL *t);
void emitFUNCTION(FUNCTION *f);
void emitPROGRAM(PROGRAM *s);
void emitTYPE(TYPE *type);
void emitDECL(DECL *d);
void emitFORINIT(FORINIT *f);
void emitSTM(STM *stm);
void emitIDENTIFIER(IDENTIFIER *i);
void emitEXP(EXP *e);
void emitLVALUE(LVALUE *l);


#endif
