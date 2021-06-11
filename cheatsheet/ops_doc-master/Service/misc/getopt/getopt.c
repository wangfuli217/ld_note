/*************************************************************************
 > File Name: getopt.c
 > Author: suchao.wang
 > Mail: suchao.wang@advantech.com.cn
 > Created Time: Wed 03 Dec 2014 07:42:29 PM CST
 ************************************************************************/

#include<stdio.h>
#include <stdlib.h>
#include <errno.h>
#include<unistd.h>

int main(int argc, char **argv)

{

	int ch;
	opterr = 0;
	unsigned long loop,loops;
	char *loopsuffix;

	loops = 1;
	while ((ch = getopt(argc, argv, "a:bcdel:")) != -1)
	{
		printf("optind:%d\n",optind);
		switch (ch)
		{

		case 'a':
			printf("option a:’%s’", optarg);
			if(argc > optind && argv[optind][0] != '-')
			{
				printf(" '%s'",argv[optind]);
				optind++;
			}
			printf("\n");
			break;

		case 'b':
			printf("option b :b\n");
			break;
		case 'l':
			loops = strtoul(optarg, &loopsuffix, 0);
			if (errno != 0)
			{
				fprintf(stderr, "failed to parse number of loops");
			}
			if (*loopsuffix != '\0')
			{
				fprintf(stderr, "loop suffix %c\n", *loopsuffix);
			}
			printf("option b :b\n");
					break;

		default:
			printf("other option :%c\n", ch);

		}

		printf("optopt +%c\n", optopt);

	}

	for(loop=1; ((!loops) || loop <= loops); loop++) {
	        printf("Loop %lu", loop);
	        if (loops) {
	                    printf("/%lu", loops);
	        }
	        printf("\n");
	        sleep(1);
	}
	return 0;
}
