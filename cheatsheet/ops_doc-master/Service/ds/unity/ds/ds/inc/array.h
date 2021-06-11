#ifndef ARRAY_H
#define ARRAY_H

void swap (int * x, int * y)
{
  int temp = * x;
  * x = * y;
  * y = temp;
}


int array_partition (int array[], int start, int end)
{
  int x = array[end];
  int i = (start - 1);

  int j;
  for (j = start; j <= end-1; j++)
  {
    if (array[j] <= x)
    {
      i++;
      swap (&array[i], &array[j]);
    }
  }
  swap (&array[i+1], &array[end]);

  return (i+1);
}


void array_quicksort (int A[], int start, int end)
{
  if (start < end)
  {
    int p = array_partition (A, start, end);
    array_quicksort (A, start, p-1);
    array_quicksort (A, p+1, end);
  }
}

#endif
