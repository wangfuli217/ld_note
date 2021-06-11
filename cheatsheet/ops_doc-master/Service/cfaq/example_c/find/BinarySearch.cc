#include "BinarySearch.h"

int
Binary_Search(int* array, unsigned int len, int key)
{
	unsigned int low, high, mid;
	
	low = high = mid = 0;
	
	low = 0;
	high = len - 1;
	
	while(low < high)
	{
		mid = (low + high) / 2;
		
		if ( key < array[mid])
		{
			high = mid - 1;
			continue;
		}
		
		if ( key > array[mid])
		{
			low = mid + 1;
			continue;
		}
	
		return mid;
	}
	
	return -1;
}