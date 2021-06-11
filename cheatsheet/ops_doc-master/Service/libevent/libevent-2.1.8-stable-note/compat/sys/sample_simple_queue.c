#include <stdio.h>
#include "queue.h"

struct Data
{
        SIMPLEQ_ENTRY(Data) next;
        int m_iValue;
};

int main(void)
{
    struct Data *pIndex = NULL;
    struct Data tData1 = { NULL, 1 };
    struct Data tData2 = { NULL, 2 };
    struct Data tData3 = { NULL, 3 };
    struct Data tData4 = { NULL, 4 };
    struct Data tData5 = { NULL, 5 };

    //定义一个队列头
    SIMPLEQ_HEAD(Head, Data) Head;
    //初始化队列头
    SIMPLEQ_INIT(&Head);
    //判断队列是否是空的
    if (SIMPLEQ_EMPTY(&Head))
            printf("this sample queue is empty!\r\n");
    //在队列的头插入tData1
    SIMPLEQ_INSERT_HEAD(&Head, &tData1, next);
    //在队列的尾部插入tData2
    SIMPLEQ_INSERT_TAIL(&Head, &tData2, next);
    printf("*****************\r\n");
    //遍历队列
    SIMPLEQ_FOREACH(pIndex, &Head, next)
    {
            if (pIndex != NULL)
                    printf("pIndex = %d\r\n", pIndex->m_iValue);
    }
    //在tData1之后插入tData3
    SIMPLEQ_INSERT_AFTER(&Head, &tData1, &tData3, next);
    //在tData3之后插入tData4
    SIMPLEQ_INSERT_AFTER(&Head, &tData3, &tData4, next);
    //在队列的头插入tData5
    SIMPLEQ_INSERT_HEAD(&Head, &tData5, next);
    printf("*****************\r\n");
    //遍历队列
    SIMPLEQ_FOREACH(pIndex, &Head, next)
    {
            if (pIndex != NULL)
                    printf("pIndex = %d\r\n", pIndex->m_iValue);
    }
    //从队列头移除tData5
    SIMPLEQ_REMOVE_HEAD(&Head, &tData5, next);
    printf("*****************\r\n");
    //遍历队列
    SIMPLEQ_FOREACH(pIndex, &Head, next)
    {
            if (pIndex != NULL)
                    printf("pIndex = %d\r\n", pIndex->m_iValue);
    }

    return 0;
}
