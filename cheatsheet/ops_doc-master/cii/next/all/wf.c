#include<ctype.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include"atom.h"
#include"table.h"
#include"mem.h"
#include"getword.h"

static void wf(char *name, FILE *fp);
static int first(int c);
static int rest(int c);
static int compare(const void *x, const void *y);
static void vfree(const void *key, void **count, void *cl);

int
main(int argc, char *argv[])
{
    FILE *fp;
    int i;

    for(i = 1; i < argc; i++){
        fp = fopen(argv[i], "r");

        if(NULL == fp){
            fprintf(stderr, "%s: can't open '%s' (%s)\n",
                    argv[0], argv[i], strerror(errno));

            return EXIT_FAILURE;
        }else{
            wf(argv[i], fp);
            fclose(fp);
        }
    }

    if(1 == argc)
        wf(NULL, stdin);
    return EXIT_SUCCESS;
}

static
void
wf(char *name, FILE *fp)
{
    table_t table = table_new(0, NULL, NULL);
    char buf[128];
    const char *word;
    int i, *count;
    void **array;

    while(getword(fp, buf, sizeof(buf), first, rest)){
        
        for(i = 0; buf[i] != '\0'; i++)
            buf[i] = tolower(buf[i]);
        word = atom_string(buf);
        count = table_get(table, word);

        if(count)
            (*count)++;
        else{
            NEW(count);
            *count = 1;
            table_put(table, word, count);
        }
    }

    if(name)
        printf("%s:\n", name);

    //<print the words>
    {
        array = table_to_array(table, NULL); 
        
        qsort(array, table_length(table), 2 * sizeof(*array), compare);

        for(i = 0; array[i]; i +=2)
            printf("%d\t%s\n", *(int *)array[i+1],
                    (char *)array[i]);

        FREE(array);
    }

    //<deallocate the entries and table>
    {
        table_map(table, vfree, NULL);
        table_free(&table);
    }
}

static
int
first(int c)
{
    return isalpha(c);
}

static
int
rest(int c)
{
    return isalpha(c) || '_' == c;
}


static
int 
compare(const void *x, const void *y)
{
    return strcmp(*(char **)x, *(char **)y);
}

static
void
vfree(const void *key, void **count, void *cl)
{
    FREE(*count);
}
