#include <stdio.h>
#include <stdlib.h>

int fun(int a,int b) 
{
	int arr[] = { 255, a*b };
	return arr[a * b <= 255];
}


int main(int argc, char **argv)
{
	printf("R: %d\n", fun(100, 100));
	printf("R: %d\n", fun(1000, 1000));
	system("pause");
	
	return 0;
}
