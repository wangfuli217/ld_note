#include "QuickSort.h"

static
void
Swap(int& a, int& b)
{
	int t;
	t = a;
	a = b;
	b = t;
}

static
int
Partition(int* array, unsigned int low, unsigned int high)
{
	int pivot_key = array[low];  //枢轴值
	
	while(low < high)
	{
		while( low < high && array[high] >= pivot_key)
			high--;
		
		Swap(array[low], array[high]);
		
		while( low < high && array[low] <= pivot_key)
			low++;
		
		Swap(array[low], array[high]);
	}
	
	return low;
}


void
Quick_Sort(int* array, unsigned int low, unsigned int high)
{
	int pivot;
	
	if (low < high)
	{
		pivot = Partition(array, low, high);
		
		Quick_Sort(array, low, pivot - 1);
		Quick_Sort(array, pivot + 1, high);
	}
}


