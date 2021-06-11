#include <stdio.h>
#include <stdlib.h>

int main()
{
    int matrix[][3] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8 ,9},
    };

    int (*p)[3] = matrix;
    printf("matrix[1][2] = %d\n", p[1][2]);
    printf("matrix[1][2] = %d\n", *(*(p+1) + 2));

    int array[5] = {10, 11, 12, 13, 14};
    int *ap = array + 3;
    printf("*(ap+1) = %d, array[4] = %d\n", *(ap+1), array[4]);
    printf("*(ap-1) = %d, ap[-1] = %d, array[2] = %d, 2[array] = %d\n", *(ap-1), ap[-1], array[2], 2[array]);
    /*
    Output/输出:
        matrix[1][2] = 6
        matrix[1][2] = 6
        *(ap+1) = 14, array[4] = 14
        *(ap-1) = 12, ap[-1] = 12, array[2] = 12, 2[array] = 12
    Explanation/解释：
        (1) 下标引用实际上只是间接访问表达式的另一种形式，即使在多维数组中也是如此。
        (2) 下标引用`array[i]`或者`i[array]`实际上会转换为*(array+i)，所以只要不越界，i的值为负值也是可以的！
        (3) 指针也可以结合下标引用，并且ptr[0] = *ptr
        (4) 【重要】 除了优先级不同以外， array[idx]和*(array+idx)是一样的！
    
    Knowledge/知识点：
        指针表达式可能比下标表达式的效率高，但下标表达式的效率绝不可能比指针表达式效率更高。(因为要做乘法运算，每次加相同值编译器可以优化)
    */
    return 0;
}