#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "atom.h"

#define BUCKETS_SIZE 2048
#define MAX_LINKLIST_LENGTH 50

typedef const char *(*func_type)(const char *, int);

int getword(FILE *, char *, int);
void Atom_hash_analysis(void);
void add_words_from_file(FILE *fp, int count);
double call_time(func_type fun, const char *str, int len);

double run_time;

int main()
{
    FILE *fp = NULL;

    fp = fopen("../string.txt", "r");

    if (fp == NULL)
    {
        printf("can't open file...\n");
        return EXIT_FAILURE;
    }
    else
    {
        add_words_from_file(fp, 70000);
        fclose(fp);
    }

    Atom_hash_analysis();

    printf("Atom_new's total run time: %lf s\n", run_time);

    return 0;
}

void add_words_from_file(FILE *fp, int count)
{
    char word[128];
    int i;

    for (i = 0; i < count; i++)
    {
        getword(fp, word, sizeof(word));
        printf("%s ", word);
        // Atom_new(word, strlen(word));
        run_time += call_time(Atom_new, word, strlen(word));
    }
    printf("\n");
}

void Atom_hash_analysis(void)
{
    int result[BUCKETS_SIZE], analys[MAX_LINKLIST_LENGTH];
    int item_count = 0;
    double averge_length;
    int i, j;

    Atom_hash_count(result, BUCKETS_SIZE);

    for (i = 0; i < BUCKETS_SIZE; i++)
    {
        ++analys[result[i]];
        item_count += result[i];
    }

    for (i = 0; i < MAX_LINKLIST_LENGTH; i++)
    {
        if (analys[i] != 0)
        {
            // printf ("count of length %d: %d\n", i, analys[i]);
            printf ("count of length %2d: ", i);
            for (j = 0; j < analys[i]/10; j++)
            {
                printf("#");
            }
            printf("%d\n", analys[i]);
        }
    }

    printf("\nbucket size: %d\n", BUCKETS_SIZE);
    printf("item count: %d\n", item_count);
    printf("averge length: %0.2lf/%0.2lf\n", (double)item_count/(BUCKETS_SIZE-analys[0]), (double)item_count/BUCKETS_SIZE);
}

double call_time(func_type fun, const char *str, int len)
{
    time_t start, stop;
    int i;

    start = clock();

    for (i = 0; i < 500; i++)
    {
        fun(str, len);
    }

    stop = clock();

    return ((double)(stop - start)) / CLK_TCK;
}

int getword(FILE *fp, char *buf, int size)
{
	int c;
	int i = 0;

	c = getc(fp);
	for ( ; c != EOF && isspace(c); c = getc(fp))
	{
        ;
	}

	for ( ; c != EOF && !isspace(c); c = getc(fp))
	{
		if (i < size -1)
		{
			buf[i++] = c;
		}
	}

	if (i < size)
	{
		buf[i] = '\0';
	}

	if (c != EOF)
	{
		ungetc(c, fp);
	}

	return buf[0] != '\0';
}
