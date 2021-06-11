#include<stdio.h>
#define MAXTITL 41
#define MAXAUTL	31

struct book{	//结构模板：标记是book
	char title[MAXTITL];
	char author[MAXAUTL];
	float value;
};

int main(void)
{
	struct book readfirst;
	int score;

	printf("Enter teast scorep:");
	scanf("%d",&score);

	if(score>=84)
		readfirst=(struct book){"Crime and Punishment",	//利用复合字面量给结构体变量赋值
				"Fyodor Dostoyevsky",
				11.25};
	else
		readfirst=(struct book){"Mr.Bouncy's Nice Hat",
				"Fred Winsome",
				5.99};
	printf("Your assigned reading:\n");
	printf("%s by %s:$%.2f\n",readfirst.title,readfirst.author,readfirst.value);
	return 0;
}