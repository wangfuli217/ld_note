#include <stdio.h>

int intcompare(const int *i, const int *j)
{
    return (*i - *j);
}

int main()
{
    int a[10] = {3, 2, 4, 5, 6, 7, 9, 0, 1, 8},i;
    for(i=0; i<10; i++)
     {
         printf("%d ",a[i]);
     }
     printf("\n");
    qsort(a,
          10,
          sizeof(int),
          (int (*)(const void *, const void *))intcompare
      );
     for(i=0; i<10; i++)
     {
         printf("%d ",a[i]);
     }
     printf("\n");
}
