#include "adlist.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct myData{
    int id;
    char name[10];
}myData;


int matchMyData(myData* myData, int* key){
    printf("match myData\n");
    return myData->id == key;
}

void* duoMyData(myData* old){
    printf("dup myData\n");
    myData* m = malloc(sizeof(myData));
    m->id = old->id*10;
    strcpy(m->name, old->name);
    return m;
}
void freeMyData(myData* my){
    printf("free myData\n");
    free(my);
}

int main(void){
    list* l = listCreate();
    listSetMatchMethod(l, matchMyData);
    listSetDupMethod(l, duoMyData);
    listSetFreeMethod(l, freeMyData);
    printf("default len:%d\n", l->len);
    
    size_t i = 0;
    for(i = 0; i < 10; i++){
        char buf[10];
        myData* d = malloc(sizeof(myData));
        d->id = i;
        sprintf(buf, "name-%d", i);
        strcpy(d->name, buf);
        listAddNodeHead(l, d);
    }
    
    listIter* it = listGetIterator(l, AL_START_HEAD);
    listNode* ln;
    while((ln = listNext(it)) != NULL){
        printf("id is:%d, name is:%s\n", ((myData*)ln->value)->id, ((myData*)ln->value)->name);
    }

    list* new = listDup(l);
    it = listGetIterator(new, AL_START_HEAD);
    while((ln = listNext(it)) != NULL){
        printf("id is:%d, name is:%s\n", ((myData*)ln->value)->id, ((myData*)ln->value)->name);
    }
    printf("%s\n",((myData*)listSearchKey(new, 10)->value)->name);
    listRelease(new);
    return 0;
}