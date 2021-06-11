#ifndef __SKIP_LIST_H_
#define __SKIP_LIST_H_

typedef unsigned int KEY;
typedef unsigned int VALUE;

typedef struct tagNode
{
    KEY             key;
    VALUE           value;
    Node**          forward;
}Node;

typedef struct tagList
{
    unsigned short level;

    Node*          header;
}List;







#endif
