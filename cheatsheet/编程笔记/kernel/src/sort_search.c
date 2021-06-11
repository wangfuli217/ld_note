#include <stdio.h>
#include <stdbool.h>

#define N	7
#define TYPE	int
#define foreach(cnt, start, times) \
	for (int cnt = start; cnt < times; cnt++)

void bubble_sort(TYPE *, int);
void quick_sort(TYPE *, int, int);
int  partition(TYPE *, int, int);
int  bin_search(TYPE *, int, int);

int
main()
{
	int  pos;
	TYPE need   = 3;
	TYPE arr[N] = {10, 1, 1, 9, 5, 0, 7};

	/* bubble_sort(arr, N); */
	quick_sort(arr, 0, N - 1);
	foreach(i, 0, N) {
		printf("arr: %d ", arr[i]);
	}
	printf("\n");

	pos = bin_search(arr, N, need);
	if (pos == 0) {
		printf("Not Found!\n");
	}
	else if (pos > 0 && pos <= N) {
		printf("%d in POS: %d\n", need, pos);
	}
	else {
		printf("Search Error!\n");
	}

	return 0;
}

void
bubble_sort(TYPE * array, int size)
{
	TYPE * p;
	bool   is_done = true;

	foreach(i, 0, size - 1) {
		foreach(j, 0, size - 1 - i) {
			p = array + j;
			if (*p > *(p + 1)) {
				/* Switch values */
				*p	 = *p ^ *(p + 1);
				*(p + 1) = *p ^ *(p + 1);
				*p	 = *p ^ *(p + 1);

				/* For checking whether the arr has already been sorted */
				is_done	 = false;
			}
		}

		if (is_done) {
			/* Jump out of the outer-foreach */
			break;
		}
	}
}

int
bin_search(TYPE * array, int size, int wanted)
{
	/* 0 --- size - 1 */
	int low  = 0;
	int high = size - 1;
	int mid  = (low + high) / 2;

	while (low <= high) {
		if (wanted > array[mid]) {
			low = mid + 1;
			mid = (low + high) / 2;
			continue;
		}
		if (wanted < array[mid]) {
			high = mid - 1;
			mid  = (low + high) / 2;
			continue;
		}
		if (wanted == array[mid]) {
			/* 1 --- size */
			return mid + 1;
		}
	}

	/* 0 means that find no in the array */
	return 0;
}

void
quick_sort(TYPE * array, int low, int high)
{
	int mid;

	if (low < high) {
		mid = partition(array, low, high);

		/* Recursion */
		quick_sort(array, low, mid - 1);
		quick_sort(array, mid + 1, high);
	}
}

int
partition(TYPE * array, int low, int high)
{
	/* like its name -- a lookout */
	int lookout = array[low];

	/* Regard every loop as started with HIGH-move, end with LOW-move */
	while (low < high) {
		if (lookout < array[high]) {
			high--;
			continue;
		}
		array[low] = array[high];

		low++;
		if (!(low < high)) {
			break;
		}

		/* It must b that when LOW == HIGH while ARRAY[LOW] < LOOKOUT,
		 * impossible is that  LOW >  HIGH while ARRAY[LOW] < LOOKOUT,
		 * so here is no need to add ' && low < high ' */
		while (array[low] < lookout) {
			low++;
		}

		/* Only 2 situation we would meet with:
		 * 1. -> LOW <  HIGH
		 * 2. -> LOW == HIGH + 1, namely LOW > HIGH */
		if (!(low < high)) {

			/* else ARRAY[LOW] = LOOKOUT below may evaluate LOOKOUT to the 
			 * out of space of ARRAY */
			low = high;
			break;
		}

		array[high] = array[low];
		high--;
	}

	/* Here LOW means the mid position in the array,
	 * namely the LOOKOUT's position */
	array[low] = lookout;
	return low;
}
