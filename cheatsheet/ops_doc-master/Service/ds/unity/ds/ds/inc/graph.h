#ifndef GRAPH_H
#define GRAPH_H

struct graph_list_node
{
  int dest;
  struct graph_list_node * next;
};


struct graph_list
{
  struct graph_list_node * head;
};


struct graph
{
  int vertex;
  struct graph_list * array;
};


struct graph_list_node * graph_list_node_create (int dest)
{
  struct graph_list_node * n = (struct graph_list_node *)malloc(sizeof(struct graph_list_node));
  n->dest = dest;
  n->next = NULL;
  return n;
}


struct graph * graph_create (int vertex)
{
  struct graph * g = (struct graph *)malloc(sizeof(struct graph));
  g->vertex = vertex;
  g->array = (struct graph_list_node *)malloc(vertex*sizeof(struct graph_list));

  int i;
  for (i = 0; i < vertex; ++i)
  {
    g->array[i].head = NULL;
  }

  return g;
}


void graph_edge_add (struct graph * g, int src, int dest)
{
  struct graph_list_node * n = graph_list_node_create(dest);
  n->next = g->array[src].head;
  g->array[src].head = n;

  n = graph_list_node_create (src);
  n->next = g->array[dest].head;
  g->array[dest].head = n;
}


void graph_traverse (struct graph * g)
{
  int v;
  for (v = 0; v < g->vertex; ++v)
  {
    struct graph_list_node * list = g->array[v].head;
    printf("\n adjacency list of vertex %d\n head", v);
    while (list)
    {
      printf("-> %d", list->dest);
      list = list->next;
    }
  }
}


#endif
