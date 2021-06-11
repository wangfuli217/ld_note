
#include <stdio.h>
#include <stdlib.h>
 
int main(void)
{
   int         *variable_array = NULL;
   int         size = 0;
   char        buf[256];
   int         i;
 
    while (fgets(buf, 256, stdin) != NULL) {
        size++;
        variable_array = realloc(variable_array, sizeof(int) * size);
        sscanf(buf, "%d", &variable_array[size-1]);
    }
 
    for (i = 0; i < size; i++) {
        printf("variable_array[%d]..%d\n", i, variable_array[i]);
    }
 
    return 0;
}
// 在需要获得类型 T 的可变长数组时，可以使用 malloc()来动态地给“指向 T 的指针”分配内存区域。
// 但此时需要程序员自己对数组的元素个数进行管理。
　