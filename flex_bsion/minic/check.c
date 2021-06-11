/*
*	check.c(1.4)	17:46:20	97/12/10
*/
#include	<stdio.h>		/* for fprintf() and friends */
#include	<stdlib.h>		/* for exit() */
#include	"check.h"

#include	"minic.tab.h"		/* for tokens */

extern int      lineno;			/* defined in minic.y */

static void
error(char *s1,char *s2,T_INFO* t1,char* s3,char* s4,T_INFO* t2)
{
fprintf(stderr,"type error on line %d: ",lineno);
if (s1)	fprintf(stderr,"%s",s1);
if (s2)	fprintf(stderr,"%s",s2);
if (t1)	types_print(stderr,t1);
if (s3)	fprintf(stderr,"%s",s3);
if (s4)	fprintf(stderr,"%s",s4);
if (t2)	types_print(stderr,t2);
fprintf(stderr,"\n");
exit(1);
}

void
check_assignment(T_INFO* tlexp,T_INFO* texp)
{
if (tlexp!=texp)
	error("cannot assign ",0,texp," to ",0,tlexp);
}

T_INFO*
check_record_access(T_INFO* t,char* field)
{
SYM_INFO	*i;

if (t->cons!=record_t)
	error("not a record: ",0,t," for field ",field,0);
if ((i=symtab_list_find(t->info.record.fields,field)))
	return i->type;
error("record type ",0,t," has no field ",field,0);
return 0;
}

T_INFO*
check_array_access(T_INFO* ta,T_INFO* ti)
{
if (ta->cons!=array_t)
	error("not an array type: ",0,ta,0,0,0);
if (ti->cons!=int_t)
	error("index for ",0,ta," must be integer, not ",0,ti);
return ta->info.array.base;
}

T_INFO*
check_arith_op(int token,T_INFO* t1,T_INFO* t2)
{
if (t1!=t2)
	error("type ",0,t1," does not match ",0,t2);
if ((t1->cons!=int_t)&&(t2->cons!=float_t))
	error("type ",0,t1," is not numeric",0,0);
return t1;
}

T_INFO*
check_relop(int token,T_INFO* t1,T_INFO* t2)
{
if (t1!=t2)
	error("type ",0,t1," does not match ",0,t2);
return types_simple(int_t);
}

SYM_INFO*
check_symbol(SYM_TAB* scope,char* name)
{
SYM_INFO* i = symtab_find(scope,name);

if (!i)
	error("undeclared variable \"",name,0,"\"",0,0);
return i;
}

T_INFO*
check_fun_call(SYM_TAB* scope,char* name,T_LIST** args)
{
SYM_INFO*	i = symtab_find(scope,name);
T_INFO*		ft;

if (!i)
	error("undeclared function \"",name,0,"\"",0,0);

ft = i->type;

if (ft->cons!=fun_t)
	error(name," is not a function",0,0,0,0);

if (types_list_equal(ft->info.fun.source,(args?*args:0)))
	{
	/* release type_list from args, replace by equal list
	*  from function type
	*/
	if (args) {
		types_list_release(*args);
		*args	= ft->info.fun.source;
		}
	return ft->info.fun.target;
	}
error("bad type of arguments for ",name,0,0,0,0);
return 0;
}
