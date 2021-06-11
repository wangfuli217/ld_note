#ifndef STACK_LIST_H
#define STACK_LIST_H

struct stacknode
{
  int data;
  struct stacknode * next;
};


struct stacknode * stacknode_create (int data)
{
  struct stacknode * snode = (struct stacknode *)malloc(sizeof(struct stacknode));
  snode->data = data;
  snode->next = NULL;
  return snode;
}


int stacklist_isempty (struct stacknode * root)
{
  return !root;
}

void stacklist_push (struct stacknode ** root, int data)
{
  struct stacknode * snode = stacknode_create (data);
  snode->next = *root;
  *root = snode;
  printf("%d pushed to stack\n", data);
}


int stacklist_pop (struct stacknode ** root)
{
  if (stacklist_isempty(*root))
    return INT_MIN;

  struct stacknode * tmp = * root;
  *root = (*root)->next;
  int popped = tmp->data;
  free(tmp);

  return popped;
}


int stacklist_peek (struct stacknode * root)
{
  if (stacklist_isempty(root))
    return INT_MIN;

  return root->data;
}


#endif
