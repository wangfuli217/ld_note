#ifndef	TYPES_H
#define	TYPES_H
/*
*	types.h(1.4)	17:11:16	97/12/08
*	
*	Type pool management
*/
#include	"symtab.h"

typedef enum { int_t, float_t, fun_t, record_t, array_t } T_CONS; /* type constructors */

typedef struct {
	SYM_LIST		*fields;
	} T_RECORD;

typedef struct {
	struct type_info	*target;
	struct types_list	*source;
	} T_FUN;

typedef struct array_type {
	struct type_info	*base;
	} T_ARRAY;


typedef struct type_info {
	T_CONS 	cons;
	union {
		T_FUN		fun;
		T_ARRAY		array;
		T_RECORD	record;
		} info;
	} T_INFO;

typedef struct types_list {
	T_INFO			*type;
	struct types_list	*next;
	} T_LIST;

T_INFO*	types_simple(T_CONS c);
T_INFO*	types_fun(T_INFO* target,T_LIST *source);
T_INFO*	types_record(SYM_LIST *fields);
T_INFO*	types_array(T_INFO *base);
T_LIST*	types_list_insert(T_LIST*,T_INFO*);
int	types_list_equal(T_LIST*,T_LIST*);
void	types_print(FILE*,T_INFO*);
void	types_list_print(FILE*,T_LIST*,char*);
void	types_list_release(T_LIST*);
void	types_print_all(FILE*);

#endif
