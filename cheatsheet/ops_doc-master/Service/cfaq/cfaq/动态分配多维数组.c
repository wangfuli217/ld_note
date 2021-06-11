#include <stdlib.h> 
int **array1 = malloc(nrows * sizeof(int *)); 
for(i = 0; i < nrows; i++) 
    array1[i] = malloc(ncolumns * sizeof(int));

    当然, 在真实代码中, 所有的 malloc 返回值都必须检查。你也可以使用 sizeof(*array1)  
和 sizeof(**array1) 代替 sizeof(int *) 和 sizeof(int)。

你可以让数组的内容连续, 但在后来重新分配列的时候会比较困难, 得使用一点指针算术:
    int **array2 = malloc(nrows * sizeof(int *));
    array2[0] = malloc(nrows * ncolumns * sizeof(int));
    for(i = 1; i < nrows; i++)
        array2[i] = array2[0] + i * ncolumns;
在两种情况下, 动态数组的成员都可以用正常的数组下标 arrayx[i][j] 来访问  
(for 0 <= i <nrows 和 0 <= j <ncolumns)。
   
   如果上述方案的两次间接因为某种原因不能接受, 你还可以同一个单独的动态分配 的一维数组来模拟二维数组:
    int *array3 = malloc(nrows * ncolumns * sizeof(int));
    #define Arrayaccess(a, i, j) ((a)[(i) * ncolumns + (j)])