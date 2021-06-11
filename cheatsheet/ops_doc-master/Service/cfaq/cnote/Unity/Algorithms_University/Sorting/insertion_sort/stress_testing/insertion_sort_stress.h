#ifndef __SORT_H__KJAHC38DJ__
#define __SORT_H__KJAHC38DJ__

typedef void (*TestFunction)(void*);
struct entry {
  int id;
  char str[32];
  int val;
  float decimal;
};

typedef struct entry* pEntry;

struct param {
  pEntry* aEntry;
  size_t sizeAEntry;
};

#endif
