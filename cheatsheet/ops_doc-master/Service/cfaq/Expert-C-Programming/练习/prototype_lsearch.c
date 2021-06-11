#include <malloc.h>
#include <stdio.h>

void* lsearch(void *key, void *base, int n,
              int elemSize, int(*cmpfn)(void*,void*)){
    int i;
    for(i=0; i<n; i++){
        void* elemAddr = (char*)base + i * elemSize;
        if(cmpfn(key, elemAddr) == 0)
            return elemAddr;
    }
    return NULL;
}

int IntCmp(void *elem1, void *elem2){
    int* ip1 = elem1;
    int* ip2 = elem2;
    return *ip1 - *ip2;
}

int StrCmp(void *elem1, void *elem2){
    char* str1 = *(char**)elem1;
    char* str2 = *(char**)elem2;
    return strcmp(str1, str2);
}

int main(void){
    int array[] = {4,2,3,7,11,6};
    int number = 7;

    int *found = lsearch(&number, array,
        sizeof(array)/sizeof(int), sizeof(int), IntCmp);
    if(found != NULL)
        printf("found: %d", *found);
    
    char *notes[]={"Ab","F#","B","Eb","Gb","D"};
    char *favoriteNote = "Eb";

    char **cfind = lsearch(&favoriteNote, notes,
        sizeof(notes)/sizeof(char*),sizeof(char*), StrCmp);
    if(cfind != NULL)
        printf(" cfind: %s", *cfind);
    
    return 0;
}

/*
void *lfind(const void *key, const void *base, size_t *nmemb,
        size_t size, int(*compar)(const void *, const void *));

void *lsearch(const void *key, void *base, size_t *nmemb,
        size_t size, int(*compar)(const void *, const void *));

*/