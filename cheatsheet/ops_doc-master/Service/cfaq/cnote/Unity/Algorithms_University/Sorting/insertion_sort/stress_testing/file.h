#ifndef __FILE_H__KJAHC38DJ__
#define __FILE_H__KJAHC38DJ__

typedef struct _Node {
    pEntry entry;
    struct _Node* next;
} Node;

typedef struct {
    Node* first;
    Node* last;
} List;

List* newList();
Node* newNode(pEntry entry);
void append(List* list, pEntry entry);
void parseContent(FILE* fp, pEntry** aEntry, size_t* sizeAEntry);
bool loadFile(char* filename, pEntry** aEntry, size_t* sizeAEntry);

#endif
