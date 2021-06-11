#include <stdio.h>
#include <math.h>

#define PI 3.14156

double
AverageRandom(double min,double max)
{
	int minInteger = (int)(min*10000);

	int maxInteger = (int)(max*10000);

	int randInteger = rand()*rand();

	int diffInteger = maxInteger - minInteger;

	int resultInteger = randInteger % diffInteger + minInteger;

	return resultInteger/10000.0;
}

double 
Normal(double x,double miu,double sigma) //概率密度函数
{
	return 1.0/sqrt(2*PI*sigma) * exp(-1*(x-miu)*(x-miu)/(2*sigma*sigma));
}

double
NormalRandom(double miu, double sigma, double min, double max)//产生正态分布随机数
{
	double x;

	double dScope;

	double y;

	do {
		x = AverageRandom(min,max); 

		y = Normal(x, miu, sigma);

		dScope = AverageRandom(0, Normal(miu,miu,sigma));

	}while( dScope > y);

	return x;
}



int main(int argc, char **argv)
{
	for (int i = 1; i <= 100; i++) {
		printf("%u\n", (unsigned int)AverageRandom(1, 100));
	}
	
	system("pause");
	
	return 0;
}
