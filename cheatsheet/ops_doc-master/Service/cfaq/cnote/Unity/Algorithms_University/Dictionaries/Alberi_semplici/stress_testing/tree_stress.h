#ifndef __SORT_H__KJAHC38DJ__
#define __SORT_H__KJAHC38DJ__

#include "../alberi_semplici.h"

typedef void (*TestFunction)(void*);

typedef enum {INT, STR, FLOAT} type;

struct entry {
  int id;
  char str[32];
  int val;
  float dec;
};

typedef struct entry* pEntry;

struct param {
  pEntry* aEntry;
  size_t asize;
  tree* albero;
  type val;
};

#endif
