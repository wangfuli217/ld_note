#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "hash_stress.h"
#include "file.h"


// create a new node list
List* newList() {
  List* newlist = (List*) malloc(sizeof(List));
  newlist->first = NULL;
  newlist->last = NULL;
  return newlist;
}


// create a new node 
Node* newNode(Entry_p entry){
  Node* newnode = (Node*) malloc(sizeof(Node));
  newnode->entry = entry;
  newnode->next = NULL;
  return newnode;
}


// append to the end of a list a new node with payload "entry"
void append(List* list, Entry_p entry){
    Node* newnode = newNode(entry);

    if (list->first == NULL)
        list->first = newnode;

    if (list->last != NULL)
        list->last->next = newnode;
    
    list->last = newnode;
}


// parse the content of a file and assign the values to an array of pointer to structs
void parseContent(FILE* fp, Entry_p** aEntry, size_t* sizeAEntry){

  int matches, size = 0;
  List* entryList = newList();

  // parse lines and count the number of valid lines
  Entry_p tmpEntry = (Entry_p) malloc(sizeof(Entry_t));
  do {
    matches = fscanf(fp, "%i,%31[^,],%i,%f\n", &tmpEntry->id, (char*) &tmpEntry->str, &tmpEntry->val, &tmpEntry->dec);
    if (matches == 4){
      size++;
      append(entryList, tmpEntry);
      tmpEntry = (Entry_p) malloc(sizeof(Entry_t));
    } else if (matches == EOF){
      free(tmpEntry);
    }
  } while (matches != EOF);


  // create the array of correct size (number of valid lines)
  Entry_p* tEntry = (Entry_p*) malloc(sizeof(Entry_p) * size);


  // assign entry to the array and free the list
  Node* item = entryList->first;
  Node* fitem;
  for(int i=0; i < size; i++){
    tEntry[i] = item->entry;
    fitem = item; 
    item = item->next;
    free(fitem);
  }
  free(entryList);

  // assign array and size to the caller's variables
  *aEntry = tEntry;
  *sizeAEntry = size;

  printf("Size: %zu\n", *sizeAEntry);
}


// verify the existence of a file launch the parsing
bool loadFile(char* filename, Entry_p** aEntry, size_t* sizeAEntry){
  puts("Loading file...");
  FILE* fp = fopen(filename, "r");
  if (fp){
    parseContent(fp, aEntry, sizeAEntry);
    fclose(fp);
    return true;
  } else {
    puts("File not found!");
    return false;
  }
}

