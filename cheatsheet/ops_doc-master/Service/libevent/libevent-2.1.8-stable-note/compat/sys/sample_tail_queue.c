#include <stdio.h>
#include "queue.h"

struct MyStruct
{
    TAILQ_ENTRY(MyStruct) next;
    int m_iValue;
};

int main(void)
{
    struct MyStruct *pIndex = NULL;
    struct MyStruct tData1 = { { NULL, NULL }, 1 };
    struct MyStruct tData2 = { { NULL, NULL }, 2 };
    struct MyStruct tData3 = { { NULL, NULL }, 3 };
    struct MyStruct tData4 = { { NULL, NULL }, 4 };
    struct MyStruct tData5 = { { NULL, NULL }, 5 };

    //定义一个循环队列的头
    TAILQ_HEAD(Head, MyStruct) tHead;
    //初始化循环队列头
    TAILQ_INIT(&tHead);
    //判断循环队列是否为空
    if (TAILQ_EMPTY(&tHead))
        printf("this circular queue is empty!\r\n");
    //在队列头插入tData1
    TAILQ_INSERT_HEAD(&tHead, &tData1, next);
    //在队列的尾部插入tData2
    TAILQ_INSERT_TAIL(&tHead, &tData2, next);
    //在tData2之后插入tData3
    TAILQ_INSERT_AFTER(&tHead, &tData2, &tData3, next);
    //在tData2之前插前tData4
    TAILQ_INSERT_BEFORE(&tData2, &tData4, next);
    //用tData5之替换tData1
    TAILQ_REPLACE(&tHead, &tData1, &tData5, next);
    //移除tData3
    TAILQ_REMOVE(&tHead, &tData3, next);
    //正向遍历队列
    TAILQ_FOREACH(pIndex, &tHead, next)
    {
        if (pIndex != NULL)
            printf("pIndex = %d\r\n", pIndex->m_iValue);
    }
    printf("*****************\r\n");
    //反向遍历队列
    TAILQ_FOREACH_REVERSE(pIndex, &tHead, Head, next)
    {
        if (pIndex != NULL)
            printf("pIndex = %d\r\n", pIndex->m_iValue);
    }

    return 0;
}
