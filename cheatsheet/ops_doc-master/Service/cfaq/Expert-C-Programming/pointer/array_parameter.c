#include <stdio.h>
 
void func(int *array, int size)
{
   int i;

   for (i = 0; i < size; i++) {
      printf("array[%d]..%d\n", i, array[i]);
   }
}
 
int main(void)
{
    int array[] = {1, 2, 3, 4, 5};
 
    func(array, sizeof(array) / sizeof(int));
 
    return 0;
}

// 想要将类型 T 的数组作为参数进行传递，可以考虑传递“指向 T 的指针”。可是，作为被调用方是不知道数组的元素个数的，所以在必要的情况下，需要使用其他方式进行参数传递。
