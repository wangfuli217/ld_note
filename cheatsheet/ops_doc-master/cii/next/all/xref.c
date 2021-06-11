#include<ctype.h>
#include<stdio.h>
#include<stdlib.h>
#include<limits.h>
#include<string.h>
#include<errno.h>
#include"mem.h"
#include"table.h"
#include"atom.h"
#include"set.h"
#include"getword.h"

static void xref(const char * file_name, FILE *fp, table_t id_tab);
static int  compare(const void *x, const void *y);
static int  compare_int(const void *x, const void *y);
static int  int_comp(const void *x, const void *y);
static unsigned long hash_int(const void *x);
static void print_table_files(table_t files);
static int first(int c);
static int rest(int c);

static linenum;

int
main(int argc, char *argv[])
{
    int i;
    void **array;
    table_t identifiers;
    
    
    identifiers = table_new(0, NULL, NULL);

    for(i = 1; i < argc; i++){
        FILE *fp = fopen(argv[i], "r");

        if(NULL == fp){
            fprintf(stderr, "%s: can't open '%s' (%s)\n",
                    argv[0], argv[i], strerror(errno));
            return EXIT_FAILURE;
        }else{
            xref(argv[i], fp, identifiers);
            fclose(fp);
        }
    }

    if(1 == argc)
        xref(NULL, stdin, identifiers);

    //<print the identifiers>
    array = table_to_array(identifiers, NULL);
    qsort(array, table_length(identifiers),
            2 * sizeof(*array), compare);
    for(i = 0; array[i]; i+=2){
        printf("%s", (char*)array[i]);
        print_table_files(array[i+1]);
    }
    FREE(array);

    return EXIT_SUCCESS;
}

static
void
xref(const char * file_name, FILE *fp, table_t id_tab)
{
    char buf[128];
    set_t set;
    table_t files;
    const char *id;
    int *p;

    if(NULL == file_name)
        file_name = "";

    file_name = atom_string(file_name);

    linenum = 1;

    while(getword(fp, buf, sizeof(buf), first, rest)){
        
        id = atom_string(buf);
        //<files <-file table in identifiers associated with id>
        files = table_get(id_tab, id);
        if(NULL == files){
            files = table_new(0, NULL, NULL);
            table_put(id_tab, id, files);
        }

        //<set <-set in files associated with name>
        set = table_get(files, file_name);
        if(NULL == set){
            set = set_new(0, int_comp, hash_int);
            table_put(files, file_name, set);
        }

        //<add linenum to set, if necessary>
        p = &linenum;
        if(!set_member(set, p)){
            NEW(p);
            *p = linenum;
            set_put(set, p);
        }
    }

    printf("exit xref function\n");
}

static
int
compare(const void *x, const void *y)
{
    return strcmp(*(char **)x, *(char **)y);
}

static
int
compare_int(const void *x, const void *y)
{
    if(**(int **)x < **(int **)y)
        return -1;
    else if(**(int **)x > **(int **)y)
        return 1;
    else
        return 0;
}

static
int  
int_comp(const void *x, const void *y)
{
    return compare_int(&x, &y);
}

static 
unsigned long 
hash_int(const void *x)
{
    return *(int *)x;
}

static
void
print_table_files(table_t files)
{
    int i, j, cur, prev, next;
    void **array, **lines;

    array = table_to_array(files, NULL);
    
    qsort(array, table_length(files), 2 * sizeof(*array), compare);

    for(i = 0; array[i]; i+=2){
        if(*(char *)array[i] != '\0')
            printf("\t%s:", (char *)array[i]);
        //<print the line numbers in the set array[i+1]>
        lines = set_to_array(array[i+1], NULL);
        qsort(lines, set_length(array[i+1]), sizeof(*lines), compare_int);

        for(j = 0, prev = INT_MIN, next = INT_MAX; lines[j]; j++){
            cur = *(int *)lines[j];
            
            if(lines[j+1])
                next = *(int *)lines[j+1];
            else
                next = INT_MAX;

            if((prev+1) == cur && (cur+1) == next)
                ;
            else if((prev+1) == cur )
                printf("-%d", cur);
            else
                printf(" %d", cur);

            prev = cur;
        }
        
        FREE(lines);

        printf("\n");
    }

    FREE(array);
}

static
int
first(int c)
{
    if('\n' == c)
        linenum ++;

    return isalpha(c) || '_' == c;
}

static
int
rest(int c)
{
    return isalpha(c) || '_' == c || isdigit(c);
}
