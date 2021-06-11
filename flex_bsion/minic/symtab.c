/*	symtab.c(1.5)	10:07:40	97/12/10
*	
*	Symbol table management
*/
#include	<stdlib.h>	/* for malloc() and friends */
#include	<stdio.h>	/* for fprintf() and friends */

#include	"util.h"
#include	"symtab.h"
#include	"types.h"

SYM_TAB*
symtab_open(SYM_TAB * enclosing_scope)
{
SYM_TAB	*st	= fmalloc(sizeof(SYM_TAB));

st->parent	= enclosing_scope;
st->list	= 0;
if (enclosing_scope)
	st->function	= enclosing_scope->function;
return st;
}

SYM_INFO*
symtab_find(SYM_TAB *st,char *name)
{
SYM_INFO	*i;

for ( ; (st); st = st->parent)
	if ((i=symtab_list_find(st->list,name)))
		return i;
return 0;
}

SYM_INFO*
symtab_insert(SYM_TAB *st,char *name,T_INFO* t)
{
SYM_INFO* i	= symtab_info_new(name,t);
st->list	= symtab_list_insert(st->list,i);

return i;
}

static int
symtab_info_equal(SYM_INFO* i1,SYM_INFO* i2)
{
/* rely on names and types being stored in a pool ``without duplicates'' */
return ((i1->name==i2->name)&&(i1->type==i2->type));
}

int
symtab_list_equal(SYM_LIST* l1,SYM_LIST* l2)
{
if (l1==l2)
	return 1;

while (l1&&l2)
	if (symtab_info_equal(l1->info,l2->info))
		{
		l1 = l1->next;
		l2 = l2->next;
		}
	else
		return 0;
if (l1) /* l2 == 0 */
	return 0;
else
	return (l1==l2);
}

SYM_LIST*
symtab_list_insert(SYM_LIST* l,SYM_INFO* i)
{
SYM_LIST* nl	= fmalloc(sizeof(SYM_LIST));
nl->info	= i;
nl->next	= l;
return nl;
}

SYM_INFO*
symtab_list_find(SYM_LIST* l,char* name)
{
for (; (l); l = l->next)
	if (l->info->name==name) /* this works if all names in string pool */
		return l->info;
return 0;
}

void
symtab_list_release(SYM_LIST* l)
{
if (l)
	{
	symtab_list_release(l->next);
	free(l);
	}
}

SYM_INFO*
symtab_info_new(char* name,T_INFO* t)
{
SYM_INFO* i	= fmalloc(sizeof(SYM_INFO));
i->name	= name;
i->type	= t;
return i;
}

void
symtab_info_print(FILE* f,SYM_INFO* info)
{
types_print(f,info->type);
fprintf(f," %s",info->name);
}

void
symtab_list_print(FILE* f,SYM_LIST* l,char* separator)
{
while (l)
	{
	symtab_info_print(f,l->info);
	if (l->next)
		fprintf(f,"%s",separator);
	l = l->next;
	}
}

void
symtab_print(FILE *f,SYM_TAB *tab)
{
if (!tab)
	fprintf(f,"<null symtab>");
else	
	while (tab)
		{
		symtab_list_print(f,tab->list,"\n");
		if (tab->parent)
			fprintf(f,"--------");
		tab = tab->parent;
		}
}
