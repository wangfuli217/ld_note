#ifndef __WEED_H__
#define __WEED_H__

/* wig weed.h
 *
 * History:
 * 30.10.2000 - created
 */

#include "tree.h"
#include "typedef.h"

void weedSCRIPTCOLLECTION(SCRIPTCOLLECTION *s);
void weedTOPLEVEL(TOPLEVEL *t);
void weedFUNCTION(FUNCTION *f);
bool weedSTMCheckReturns(STM *s);
bool weedSTMCheckExits(STM *s);
void weedPROGRAM(PROGRAM *s);
void weedDECL(DECL *d);
void weedFORINIT(FORINIT *f);
void weedSTM(STM *stm);
void weedIDENTIFIER(IDENTIFIER *i);
void weedEXP(EXP *e);

#endif
