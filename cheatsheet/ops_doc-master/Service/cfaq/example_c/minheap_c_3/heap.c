#include "heap.h"

/* i 节点的父节点是 (i - 1)/2  左孩子是：2 * i + 1 右孩子：2*i + 2 */

#define hsize(h, t) (sizeof h) / sizeof(t)
#define swap(a, b) do { 		\
	a ^= b;						\
	b ^= a;						\
	a ^= b;						\
} while(0)

static void
MinHeapFixup(int a[], int i)
{
  int j, temp;  
    
  temp = a[i];  
  j = (i - 1) / 2;      //父结点  
  while (j >= 0 && i != 0) {  
      if (a[j] <= temp) break;  
        
      a[i] = a[j];     //把较大的子结点往下移动,替换它的子结点  
      i = j;  
      j = (i - 1) / 2;  
  }
  
  a[i] = temp;  	
}

static void
MinHeapFixdown(int a[], int i, int n)
{
   int j, temp;  
 
   temp = a[i];  
   j = 2 * i + 1;
  
   while (j < n) {  
       if (j + 1 < n && a[j + 1] < a[j])  j++;//在左右孩子中找最小的  
 
       if (a[j] >= temp) break;  
 
       a[i] = a[j];     //把较小的子结点往上移动,替换它的父结点  
       i = j;  
       j = 2 * i + 1;  
   }  

   a[i] = temp;  
}

void
MakeMinHeap(int a[], int n)
{
	for (int i = n / 2 - 1; i >= 0; i--)  MinHeapFixdown(a, i, n);  
}

void 
MinHeapDeleteNumber(int a[], int n) 
{
	swap(a[0], a[n - 1]); // 删除的时候只能删除a[0], 所以只能交换 a[0] 与最后的元素，再进行fixdown
	MinHeapFixdown(a, 0, n - 1);
}

void
MinHeapAddNumber(int a[], int n)
{
	int sz = hsize(a, int);
	
	a[sz] = n; /* 添加的时候只能从最后的元素添加，所以需要进行fixup */
	MinHeapFixup(a, sz);
}