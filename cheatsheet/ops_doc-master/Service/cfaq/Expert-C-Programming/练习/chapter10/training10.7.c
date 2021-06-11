//动态表的生成
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
int current_element = 0;
int total_element = 1;
char *dynamic = NULL;

void add_element(char c)
{
    if(current_element == total_element-1)
    {
        total_element *= 2;
        dynamic = (char *)realloc(dynamic, total_element);
        if(dynamic == NULL) printf("Couldn't expand the table");
    }
    current_element++;
    dynamic[current_element] = c;
}

void Print_element(){
 int i = 0;
 for(i=0; i<=current_element; i++){
  printf("dynamic[%d] = %c\n", i, dynamic[i]);
 }
 return ;
}

int main()
{
    dynamic = malloc(total_element);
    dynamic[0] = 'a';
    add_element('b');
    printf("size of block memory: %d\n",_msize(dynamic));
    printf("current elements: %d\n",current_element);
    Print_element();
    free(dynamic);
}
