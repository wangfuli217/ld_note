/*
 * =====================================================================================
 *
 *       Filename:  list.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  09.03.10 21:40
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef		LIST_H_ZY
#define		LIST_H_ZY

/*-----------------------------------------------------------------------------
 *  list.c includes list.h, so no "extern"
 *-----------------------------------------------------------------------------*/
#ifndef		extern
#ifndef		LIST_IMP_ZY
#define		extern			extern
#else
#define		extern		
#endif
#endif

/*-----------------------------------------------------------------------------
 *  define LIST_T_ZY before include list.h
 *-----------------------------------------------------------------------------*/
#ifndef		LIST_T_ZY
#define		LIST_T_ZY		int
#endif

typedef int (* less_than)(void * a, void * b);

struct list_n_zy {
	struct list_n_zy * link;
	LIST_T_ZY x;
};
typedef struct list_n_zy list_n_zy;

struct list_t_zy {
	struct list_t_zy * this;
	struct list_n_zy * head;
	size_t cnt;

	size_t (* length)(struct list_t_zy *);
	void (* push)(struct list_t_zy *, int);
	int (* pop)(struct list_t_zy *);
	int (* append)(struct list_t_zy *, int);
	size_t (* search_method)(struct list_t_zy *, LIST_T_ZY);
	size_t (* insert)(struct list_t_zy *, int, 
			  size_t(*)(struct list_t_zy *, LIST_H_ZY));
};
typedef struct list_t_zy list_t_zy;

#endif
