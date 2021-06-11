#include <stdio.h>
#include <stdlib.h>
#define NUM_ITEMS 10
struct Node {
  int data;
  struct Node *next;
};
void insert_node(struct Node **headNode, int nodeValue, int position);
void print_list(struct Node *headNode);
void reverse_list(struct Node **headNode);
int main(void) {
  int i;
  struct Node *head = NULL;
  for(i = 1; i <= NUM_ITEMS; i++) {
    insert_node(&head, i, i);
  }
  print_list(head);
  printf("I will now reverse the linked list\n");
  reverse_list(&head);
  print_list(head);
  return 0;
}
void print_list(struct Node *headNode) {
  struct Node *iterator;
  for(iterator = headNode; iterator != NULL; iterator = iterator->next) {
    printf("Value: %d\n", iterator->data);
  }
}
void insert_node(struct Node **headNode, int nodeValue, int position) {
  int i;
  struct Node *currentNode = (struct Node *)malloc(sizeof(struct Node));
  struct Node *nodeBeforePosition = *headNode;
  currentNode->data = nodeValue;
  if(position == 1) {
    currentNode->next = *headNode;
    *headNode = currentNode;
    return;
  }
  for (i = 0; i < position - 2; i++) {
    nodeBeforePosition = nodeBeforePosition->next;
  }
  currentNode->next = nodeBeforePosition->next;
  nodeBeforePosition->next = currentNode;
}
void reverse_list(struct Node **headNode) {
  struct Node *iterator = *headNode;
  struct Node *previousNode = NULL;
  struct Node *nextNode = NULL;
  while (iterator != NULL) {
    nextNode = iterator->next;
    iterator->next = previousNode;
    previousNode = iterator;
    iterator = nextNode;
  }
  /* Iterator will be NULL by the end, so the last node will be stored in
  previousNode.  We will set the last node to be the headNode */
  *headNode = previousNode;
}