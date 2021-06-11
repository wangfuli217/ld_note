/* $Id: symbol.c,v 1.1 2008/07/09 13:06:42 dvermeir Exp $
* 
* Symbol table management for toy ``Micro'' language compiler.
* This is a trivial example: the only information kept
* is the name, the token type: READ, WRITE or NAME and, for NAMEs
* whether they have been declared in the JVM code.
*/
#include <stdio.h> /* for (f)printf(), std{out,int} */
#include <stdlib.h> /* for exit */
#include <string.h> /* for strcmp, strdup & friends */
#include "micro.tab.h" /* token type definitions from .y file */

#include "symbol.h"

typedef struct {
  char *name; 
  int type;  /* READ, WRITE, or NAME */
  int declared; /* NAME only: 1 iff already declared in JVM code, 0 else */
} ENTRY;

#define  MAX_SYMBOLS 100
static ENTRY symbol_table[MAX_SYMBOLS]; /* not visible from outside */
static int n_symbol_table = 0; /* number of entries in symbol table */

int
symbol_find(char* name) {
  /* Find index of symbol table entry, -1 if not found */
  int i;

  for (i=0; (i<n_symbol_table); ++i)
    if (strcmp(symbol_table[i].name, name)==0)
      return i;
  return -1;
}

int
symbol_insert(char* name,int type) {
  /* Insert new symbol with a given type into symbol table,
   * returns index new value */
  if (n_symbol_table>=MAX_SYMBOLS) {
    fprintf(stderr, "Symbol table overflow (%d) entries\n", n_symbol_table);
    exit(1);
  }
  symbol_table[n_symbol_table].name = strdup(name);
  symbol_table[n_symbol_table].type = type;
  symbol_table[n_symbol_table].declared = 0;
  return n_symbol_table++;
}

int
symbol_type(int i) {
  /* Return type of symbol at position i in table. */
  /* ASSERT ((0<=i)&&(i<n_symbol_table)) */
  return symbol_table[i].type;
}

void
symbol_declare(int i) {
  /* Mark a symbol in the table as declared */
  /* ASSERT ((0<=i)&&(i<n_symbol_table)&&(symbol_table[i].type==NAME)) */
  symbol_table[i].declared = 1;
}

int
symbol_declared(int i) {
  /* Return declared property of symbol */
  /* ASSERT ((0<=i)&&(i<n_symbol_table)&&(symbol_table[i].type==NAME)) */
  return symbol_table[i].declared;
}

char*
symbol_name(int i) {
  /* Return name of symbol */
  /* ASSERT ((0<=i)&&(i<n_symbol_table)) */
  return symbol_table[i].name;
}


