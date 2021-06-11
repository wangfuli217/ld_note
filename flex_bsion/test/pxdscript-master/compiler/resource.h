#ifndef __RESOURCE_H__
#define __RESOURCE_H__

/* u1comp resource.h
 *
 * History:
 * 30.10.2000 - created
 */

#include "tree.h"
#include "typedef.h"

void resSCRIPTCOLLECTION(SCRIPTCOLLECTION *s);
void resTOPLEVEL(TOPLEVEL *t);
void resFUNCTION(FUNCTION *f);
void resPROGRAM(PROGRAM *s);
void resDECL(DECL *d);
void resFORINIT(FORINIT *f);
void resSTM(STM *stm);
void resEXP(EXP *e);

#endif
