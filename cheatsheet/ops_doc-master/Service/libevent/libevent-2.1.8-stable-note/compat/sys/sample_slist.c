#include <stdio.h>
#include "queue.h"

typedef struct Data
{
    SLIST_ENTRY(Data) next;
    int m_iData;
}Data;

int main()
{
    Data* pIndex=NULL;
    Data listDataElm1={NULL,1};
    Data listDataElm2={NULL,2};
    Data listDataElm3={NULL,3};
    Data listDataElm4={NULL,4};
    Data listDataElm5={NULL,5};

    SLIST_HEAD(myhead,Data) listHead;
    SLIST_INIT(&listHead);

    if(SLIST_EMPTY(&listHead))
        printf("list is empty\n");

    SLIST_INSERT_HEAD(&listHead,&listDataElm1,next);

    SLIST_INSERT_AFTER(&listDataElm1,&listDataElm2,next);
    SLIST_INSERT_AFTER(&listDataElm2,&listDataElm3,next);
    SLIST_INSERT_AFTER(&listDataElm3,&listDataElm4,next);
    SLIST_INSERT_AFTER(&listDataElm4,&listDataElm5,next);

    SLIST_FOREACH(pIndex,&listHead,next)
    {
        if(pIndex != NULL)
            printf("pIndex->m_iData = %d\n",pIndex->m_iData);
    }

    return 0;
}
