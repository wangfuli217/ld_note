#ifndef __GRAPH_STRESS_H_2345__
#define __GRAPH_STRESS_H_2345__

#include "../graph.h"
#include "file.h"

typedef void (*TestFunction)(void*);

typedef enum {CON=1, MIN} type;

typedef struct _param {
  Entry_p* aEntry;
  size_t asize;
  Graph_p graph;
  char* vertex1;
  char* vertex2;
} Param_t, *Param_p;

#endif
