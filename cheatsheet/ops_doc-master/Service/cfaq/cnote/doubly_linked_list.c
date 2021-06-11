#include <stdio.h>
#include <stdlib.h>
/* This data is not always stored in a structure, but it is sometimes for ease of use */
struct Node {
  /* Sometimes a key is also stored and used in the functions */
  int data;
  struct Node* next;
  struct Node* previous;
};
void insert_at_beginning(struct Node **pheadNode, int value);
void insert_at_end(struct Node **pheadNode, int value);
void print_list(struct Node *headNode);
void print_list_backwards(struct Node *headNode);
void free_list(struct Node *headNode);
int main(void) {
  /* Sometimes in a doubly linked list the last node is also stored */
  struct Node *head = NULL;
  printf("Insert a node at the beginning of the list.\n");
  insert_at_beginning(&head, 5);
  print_list(head);
  printf("Insert a node at the beginning, and then print the list backwards\n");
  insert_at_beginning(&head, 10);
  print_list_backwards(head);
  printf("Insert a node at the end, and then print the list forwards.\n");
  insert_at_end(&head, 15);
  print_list(head);
  free_list(head);
  return 0;
}
void print_list_backwards(struct Node *headNode) {
  if (NULL == headNode)
  {
    return;
  }
  /*
  Iterate through the list, and once we get to the end, iterate backwards to print
  out the items in reverse order (this is done with the pointer to the previous node).
  This can be done even more easily if a pointer to the last node is stored.
  */
  struct Node *i = headNode;
  while (i->next != NULL) {
   i = i->next; /* Move to the end of the list */
  }
  while (i != NULL) {
    printf("Value: %d\n", i->data);
    i = i->previous;
  }
}
void print_list(struct Node *headNode) {
  /* Iterate through the list and print out the data member of each node */
  struct Node *i;
  for (i = headNode; i != NULL; i = i->next) {
    printf("Value: %d\n", i->data);
  }
}
void insert_at_beginning(struct Node **pheadNode, int value) {
  struct Node *currentNode;
  if (NULL == pheadNode){
    return;
  }
  /*
  This is done similarly to how we insert a node at the beginning of a singly linked
  list, instead we set the previous member of the structure as well
  */
  currentNode = malloc(sizeof *currentNode);
  currentNode->next = NULL;
  currentNode->previous = NULL;
  currentNode->data = value;
  if (*pheadNode == NULL) { /* The list is empty */
    *pheadNode = currentNode;
    return;
  }
  currentNode->next = *pheadNode;
  (*pheadNode)->previous = currentNode;
  *pheadNode = currentNode;
}
void insert_at_end(struct Node **pheadNode, int value) {
  struct Node *currentNode;
  if (NULL == pheadNode){
    return;
  }
  /*
  This can, again be done easily by being able to have the previous element.  It
  would also be even more useful to have a pointer to the last node, which is commonly
  used.
  */
 
  currentNode = malloc(sizeof *currentNode);
  struct Node *i = *pheadNode;
  currentNode->data = value;
  currentNode->next = NULL;
  currentNode->previous = NULL;
  if (*pheadNode == NULL) {
    *pheadNode = currentNode;
    return;
  }
  while (i->next != NULL) { /* Go to the end of the list */
    i = i->next;
  }
  i->next = currentNode;
  currentNode->previous = i;
}
void free_list(struct Node *node) {
  while (node != NULL) {
    struct Node *next = node->next;
    free(node);
    node = next;
  }
}