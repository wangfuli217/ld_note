#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "graph.h"


void test_graph (void)
{
  int vertex = 5;
  struct graph * g = graph_create(vertex);
  graph_edge_add (g, 0, 1);
  graph_edge_add (g, 0, 4);
  graph_edge_add (g, 1, 2);
  graph_edge_add (g, 1, 3);
  graph_edge_add (g, 1, 4);
  graph_edge_add (g, 2, 3);
  graph_edge_add (g, 3, 4);

  graph_traverse (g);

  return 0;
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_graph);
  return UNITY_END ();
}
