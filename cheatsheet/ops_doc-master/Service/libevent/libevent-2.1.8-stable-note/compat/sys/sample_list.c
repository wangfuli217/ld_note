#include <stdio.h>
#include "queue.h"

typedef struct Data
{
    LIST_ENTRY(Data) next;
    int m_value;
}Data;

int main(int argc, char *argv[])
{
    Data *pIndex = NULL;
    Data tDataValue1 = { NULL, NULL, 1 };
    Data tDataValue2 = { NULL, NULL, 2 };
    Data tDataValue3 = { NULL, NULL, 3 };
    Data tDataValue4 = { NULL, NULL, 4 };
    Data tDataValue5 = { NULL, NULL, 5 };

    LIST_HEAD(listHead,Data) Head;
    LIST_INIT(&Head);

    if(LIST_EMPTY(&Head))
        printf("this list is empty\n");

    LIST_INSERT_HEAD(&Head,&tDataValue1,next);
    LIST_INSERT_AFTER(&tDataValue1,&tDataValue2,next);

    printf("××××××××××××\n");
    LIST_FOREACH(pIndex,&Head,next)
    {
        if(pIndex != NULL)
            printf("pIndex = %d\n",pIndex->m_value);
    }

    LIST_REPLACE(&tDataValue2,&tDataValue3,next);
    LIST_FOREACH(pIndex, &Head, next)
    {
        if (pIndex != NULL)
        {
                printf("pIndex = %d\r\n", pIndex->m_value);
        }
    }

    LIST_INSERT_AFTER(&tDataValue3, &tDataValue4, next);
    LIST_INSERT_AFTER(&tDataValue4, &tDataValue5, next);

    LIST_REMOVE(&tDataValue4, next);

    LIST_FOREACH(pIndex, &Head, next)
    {
        if (pIndex != NULL)
        {
                printf("pIndex = %d\r\n", pIndex->m_value);
        }
    }
    return 0;
}
