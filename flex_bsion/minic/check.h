#ifndef	CHECK_H
#define	CHECK_H
/*
*	check.h(1.3)	10:31:17	97/12/10
*
*	Semantic checks.
*/
#include	"types.h"
#include	"symtab.h"

void		check_assignment(T_INFO*,T_INFO*);
T_INFO*		check_record_access(T_INFO* t,char* field);
T_INFO*		check_array_access(T_INFO* ta,T_INFO* ti);
T_INFO*		check_arith_op(int token,T_INFO* t1,T_INFO* t2);
T_INFO*		check_relop(int token,T_INFO* t1,T_INFO* t2);
T_INFO*		check_fun_call(SYM_TAB*,char*,T_LIST**);
SYM_INFO*	check_symbol(SYM_TAB* scope,char* name);

#endif
