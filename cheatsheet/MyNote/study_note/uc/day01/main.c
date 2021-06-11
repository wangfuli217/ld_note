#include"circle.h"
int main(void)
{
	double r=0;
	printf("请输入一个半径:");
	scanf("%lg",&r);
	printf("圆的周长是:%g,面积是%g\n",length(r),area(r));
	return 0;
}
