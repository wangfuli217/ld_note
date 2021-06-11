#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "adlist.h"

#define ALEN(a) (sizeof(a) / sizeof(a[0]))

void freeString(void *ptr)
{
    free(ptr);
}

int matchString(void *s1, void *s2)
{
    if (strcmp(s1, s2) == 0)
        return 1;
    else
        return 0;
}

char *newString(char *s)
{
    int len = strlen(s);
    char *news = (char *)malloc(sizeof(len+1));
    strcpy(news, s);
    return news;
}

void *dupString(void *s1)
{
   void *sdup = newString(s1); 
   return sdup;
}


list *createTestListFromArray(char *a[], int len)
{
    list *list = listCreate();
    listSetFreeMethod(list, freeString);
    listSetDupMethod(list, dupString);
    listSetMatchMethod(list, matchString);
    int i;
    for (i = 0; i < len; i++) {
        listAddNodeTail(list, (void *)a[i]);
    }
    return list;
}

int main(void)
{
    char *a[] = {
        newString("aa"),
        newString("bb"),
        newString("cc")
    };
    list *lt = createTestListFromArray(a, ALEN(a));
    listTraverse(lt, AL_START_HEAD);
    listTraverse(lt, AL_START_TAIL);

    listNode *node = listSearchKey(lt, "aa");
    if (node) {
        printf("Found Node:%s\n", node->value);
    } else {
        printf("Not Found");
    }

    node = listIndex(lt, 1);
    if (node) {
        printf("Found index 1 Node:%s\n", node->value);
    } else {
        printf("Not found\n");
    }

    list *listxx = listDup(lt);

    listDelNode(lt, node);
    printf("Del Node in index 1\n");

    listTraverse(lt, AL_START_HEAD);

    printf("Traverse dup list\n");

    listRelease(lt);
    return 0;
}
