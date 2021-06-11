#include<stdio.h>
int main()
{
	float radius=0;
	float area=0;
	printf("请输入圆的半径:");
	scanf("%f",&radius);
	area=3.14*radius*radius;
	printf("%.3f\n",area);
	return 0;
}
