/*
实现类似STL中的rotate方法，front,middle,end（它是数组外的第一个元素地址）分别指向
一个数组的不同边界，需要将front到middle之前的数据移到end的后面
*/

#include <malloc.h>
#include <stdio.h>
#include <string.h>

void rotate(void *front, void *middle, void *end){
    int frontSize=(char *)middle - (char *)front;
    int backSize=(char *)end - (char *)middle;

    char buffer[frontSize];
    memcpy(buffer,front,frontSize);
    memmove(front,middle,backSize);
    memcpy((char*)end-frontSize,buffer,frontSize);
}

int main(){
    char *letter = strdup("ABCDEF");
    rotate(letter,&letter[3],&letter[6]);
    printf("%s\n", letter); /* DEFABC */
}

/*
         ┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐
         │ │ │ │ │ │ │ │ │ │ │ │ │
front->  └─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘ <─end
                 ^
                 └ middle
*/