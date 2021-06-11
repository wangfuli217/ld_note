/*
   结构休演示
   */
#include<stdio.h>
typedef struct
{
	char name[10];
	float height;
	float weight;
	int age;
}person;
int main()
{
    person person1={"zjh",1.73f,35.6f,32};
	printf("姓名是:%s\n",person1.name);
	printf("身高是:%g\n",person1.height);
	printf("体重是:%g\n",person1.weight);
	printf("年龄是:%d\n",person1.age);
	return 0;
}
