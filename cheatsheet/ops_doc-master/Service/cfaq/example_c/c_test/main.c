#include <stdio.h>
#include <stdlib.h>

static void
__test_2()
{
	struct node {
		char a;  
		char b; 
		short c;  
		int d;
	};

	struct node s = { 3, 5, 6, 99 };
	struct node *pt = &s;
	printf("%d\n", *(int*)pt); /* 表示成int类型的数值时，按照little endian进行  |03 |05 | 06 00  ---> 00 06 05 03 */
}

/*&a是一个隐式的指向int [5]数组的指针，它和int* ptr是不一样的，如果真要定义这个指针，应该是int (*ptoa)[5]。
 * 所以ptoa每一次加一操作都相当于跨越int a[5]的内存步长（也就是5个int长度），也就是说&a + 1其实就是指向了a[5]这个位置，
 * 实际上内存里面这个位置是非法的，但是对ptr的强制转换导致了后面ptr-1的内存步长改为了1个int长度，所以ptr-1实际指向了a[4]。
 * 至于*(a+1)没什么好说的，值就是2。
 * */
static void
__test_3()
{
	int a[5] = { 1, 2, 3, 4, 5 };
	int *ptr = (int*)(&a + 1); /* &a == int (*)[5]  &a[0] == int*  prt = &a[5] 这是非法地址 */
	printf("%d %d\n", *(a + 1), *(ptr - 1)); /* *(prt - 1) == a[4] */
}

static void
__test_4()
{
	int a[2][2] = { 1, 2, 3, 4 }; /* {{1, 2}, {3, 4}} */
	
	int(*p)[2][2] = &a;
	
	int** ppp = (int**)a;
	
	int(*pp)[2] = &a[0];
	
	printf("%p\n", p);
	printf("%p\n", *((*p) + 1) + 1);
	printf("%d\n", *(*((*p) + 1) + 1));
	
	printf("%p\n", pp);
	printf("%p\n", *(pp + 1) + 1);
	printf("%d\n", *(*(pp + 1) + 1));

	printf("%p\n", ppp);	
	printf("%p\n", ppp + 1);
	printf("%d\n", *(*(ppp + 1) + 1));
}

static void
__test_5()
{
	int a, b, c, d;

	a = 3;

	b = 5;

	c = a, b; /* , 操作符前计算前半部再计算后半部并返回后半部的值 c = a */

	d = (a, b); /* d = b  */

	printf("c=%d\n", c);

	printf("d=%d\n", d);

}

int main(int argc, char **argv)
{
	
	__test_2();
	__test_3();
	//__test_4();
	__test_5();
	
	system("pause");
	
	return 0;
}
