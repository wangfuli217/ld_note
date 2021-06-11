#ifndef __CODE_H__
#define __CODE_H__

#include "tree.h"

void codeSCRIPTCOLLECTION(SCRIPTCOLLECTION *s);
void codeTOPLEVEL(TOPLEVEL *t);
void codeFUNCTION(FUNCTION *f);
void codePROGRAM(PROGRAM *s);
void codeDECL(DECL *d);
void codeFORINIT(FORINIT *f);
void codeSTM(STM *stm);
void codeEXP(EXP *e);
void codeLVALUE(LVALUE *l);

#endif

