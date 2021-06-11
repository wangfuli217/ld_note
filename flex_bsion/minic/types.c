/*	types.c(1.5)	17:11:14	97/12/08
*	
*	Type pool management
*/
#include	<stdlib.h>	/* for malloc() and friends */
#include	<stdio.h>	/* for fprintf() and friends */
#include	<assert.h>	/* for assert(condition) */

#include	"util.h"
#include	"symtab.h"
#include	"types.h"

static T_LIST	*types	= 0;

static int
types_equal(T_INFO *t1, T_INFO *t2)
{
if (t1==t2)
	return 1;

if (t1->cons==t2->cons)
	switch (t1->cons)
		{
		case int_t:
		case float_t:
			return 1;
		case fun_t:
			if (!types_equal(t1->info.fun.target, t2->info.fun.target))
				return 0;
			else
				return types_list_equal(t1->info.fun.source, t2->info.fun.source);
		case array_t:
			return types_equal(t1->info.array.base, t2->info.array.base);
		case record_t:
			return symtab_list_equal(t1->info.record.fields, t2->info.record.fields);
		default:	assert(0);
		}
return 0;
}


void
types_list_release(T_LIST* l)
{
if (l) /* free memory held by list nodes, not by types in the nodes */
	{
	types_list_release(l->next);
	free(l);
	}
}

int
types_list_equal(T_LIST* t1,T_LIST *t2)
{
if (t1==t2)
	return 1;

while (t1&&t2)
	if (types_equal(t1->type,t2->type))
		{
		t1	= t1->next;
		t2	= t2->next;
		}
	else
		return 0;
	
if (t1)	/* t2 == 0 */
	return 0;
else	/* t1 == 0 */
	return (t1==t2);
}

static T_INFO*
types_find(T_INFO *t)
{
T_LIST	*tl;

for (tl=types;(tl);tl=tl->next)
	if (types_equal(t,tl->type))
		return tl->type;
return 0;
}

static T_INFO*
types_new(T_CONS c)
{
T_INFO	*t 	= fmalloc(sizeof(T_INFO));
T_LIST	*tl 	= fmalloc(sizeof(T_LIST));
t->cons		= c;
tl->type	= t;
tl->next	= types;
types		= tl;
return t;
}

T_INFO*
types_simple(T_CONS c)
{
T_INFO	t,*pt;
t.cons	= c;

if ((pt=types_find(&t)))
	return pt;
else
	return types_new(c);
}

T_INFO*
types_fun(T_INFO* target,T_LIST *source)
{
T_INFO	t,*pt;

t.cons			= fun_t;
t.info.fun.target	= target;
t.info.fun.source	= source;

if (!(pt=types_find(&t)))
	{
	pt = types_new(fun_t);
	pt->info.fun.source	= source;
	pt->info.fun.target	= target;
	}
else
	types_list_release(source);
return pt;
}

T_INFO*
types_record(SYM_LIST *fields)
{
T_INFO	t,*pt;

t.cons			= record_t;
t.info.record.fields	= fields;

if (!(pt=types_find(&t)))
	{
	pt = types_new(record_t);
	pt->info.record.fields	= fields;
	}
else
	symtab_list_release(fields);
return pt;
}

T_INFO*
types_array(T_INFO *base)
{
T_INFO	t,*pt;
t.cons			= array_t;
t.info.array.base	= base;

if (!(pt=types_find(&t)))
	{
	pt = types_new(array_t);
	pt->info.array.base	= base;
	}
return pt;
}

T_LIST*
types_list_insert(T_LIST* l,T_INFO *t)
{
T_LIST	*nl	= fmalloc(sizeof(T_LIST));
nl->type	= t;
nl->next	= l;
return nl;
}

void
types_print(FILE* f,T_INFO *t)
{
if (!t)
	fprintf(f,"<null_type>");
else
	switch (t->cons) {
		case int_t:
			fprintf(f,"int");
			break;
		case float_t:
			fprintf(f,"float");
			break;
		case fun_t:
			types_print(f,t->info.fun.target);
			fprintf(f,"(");
			types_list_print(f,t->info.fun.source,",");
			fprintf(f,")");
			break;
		case record_t:
			fprintf(f,"struct {");
			symtab_list_print(f,t->info.record.fields,";");
			fprintf(f,"}");
			break;
		case array_t:
			types_print(f,t->info.array.base);
			fprintf(f,"*");
			break;
		default:
			assert(0);
		}
/* fprintf(f,"[%x]",(unsigned int)t); */
}

void
types_list_print(FILE* f,T_LIST* tl,char* separator)
{
/* fprintf(f,"{%x}",(unsigned int)tl); */
while (tl)
	{
	types_print(f,tl->type);
	if (tl->next)
		fprintf(f,"%s",separator);
	tl = tl->next;
	}
}

void
types_print_all(FILE* f)
{
types_list_print(f,types,"\n");
}
