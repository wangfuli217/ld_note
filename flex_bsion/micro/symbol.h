#ifndef	SYMBOL_H
#define	SYMBOL_H
/* $Id: symbol.h,v 1.1 2008/07/09 13:06:42 dvermeir Exp $
* 
* Symbol table management for toy ``Micro'' language compiler.
*/
extern int symbol_insert(char* name,int type);
extern void symbol_declare(int i);

extern int symbol_find(char* name);
extern char* symbol_name(int i);
extern int symbol_type(int i);
extern int symbol_declared(int i);
#endif
