#ifndef	SYMBOL_H
#define	SYMBOL_H
/*	symtab.h(1.5)	10:07:41	97/12/10
*	
*	Symbol table management
*/

typedef struct syminfo {
	char			*name;
	struct type_info	*type;
	} SYM_INFO;


typedef struct symcell {
	SYM_INFO	*info;
	struct symcell	*next;
	} SYM_LIST;

typedef struct symtab {
	struct symtab	*parent;
	SYM_INFO	*function; /* enclosing this scope */
	SYM_LIST	*list;
	} SYM_TAB;

SYM_TAB*	symtab_open(SYM_TAB* enclosing_scope);
SYM_INFO*	symtab_find(SYM_TAB*,char*);
SYM_INFO*	symtab_insert(SYM_TAB*,char*,struct type_info*);
int		symtab_list_equal(SYM_LIST*,SYM_LIST*);
SYM_LIST*	symtab_list_insert(SYM_LIST*,SYM_INFO*);
SYM_INFO*	symtab_list_find(SYM_LIST*,char*);
void		symtab_list_release(SYM_LIST*);
SYM_INFO*	symtab_info_new(char*,struct type_info*);

void		symtab_print(FILE*,SYM_TAB*);
void		symtab_info_print(FILE*,SYM_INFO*);
void		symtab_list_print(FILE*,SYM_LIST*,char* separator);
#endif
