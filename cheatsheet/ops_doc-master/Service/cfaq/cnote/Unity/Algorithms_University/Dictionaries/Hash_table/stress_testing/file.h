#ifndef __FILE_H__KJAHC38DJ__
#define __FILE_H__KJAHC38DJ__

typedef struct {
  int id;
  char str[32];
  int val;
  float dec;
} Entry_t, *Entry_p;


typedef struct _Node {
    Entry_p entry;
    struct _Node* next;
} Node;

typedef struct {
    Node* first;
    Node* last;
} List;


List* newList();
Node* newNode(Entry_p entry);
void append(List* list, Entry_p entry);
void parseContent(FILE* fp, Entry_p** aEntry, size_t* sizeAEntry);
bool loadFile(char* filename, Entry_p** aEntry, size_t* sizeAEntry);

#endif
