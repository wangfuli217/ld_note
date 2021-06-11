#include<ctype.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include"atom.h"
#include"mem.h"
#include"getword.h"
#include"bst.h"

static void wf(char *name, FILE *fp);
static int compare(const void *x, const void *y);
static void print(const void *key, void *cl);
static int first(int c);
static int rest(int c);

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
    bst_t bst, dummy;
    char buf[128];
    const char *word;
    int i, *count;
    void **array;


    word = atom_string("middle");
    

    bst = bst_new((void*)word);

    dummy = bst_successor(bst);
    if(NULL != dummy){
        printf("root's successor:%s\n", (char *)bst_get_key(dummy));
    }else{
        printf("root's successor is NULL\n");
    }


    while(getword(fp, buf, sizeof(buf), first, rest)){
        
        for(i = 0; buf[i] != '\0'; i++)
            buf[i] = tolower(buf[i]);


        word = atom_string(buf);


        bst_insert(bst, (void*)word, compare);

    }

    if(name)
        printf("%s:\n", name);

    bst_traverse(bst, print, stdout);


    dummy = bst_successor(bst);
    if(NULL != dummy){
        printf("root's successor:%s\n", (char *)bst_get_key(dummy));
    }

    dummy = bst_predecessor(bst);
    if(NULL != dummy){
        printf("root's predecessor:%s\n", (char *)bst_get_key(dummy));
    }
    
    printf("###############################################\n");

    bst_delete(dummy);
    bst_traverse(bst, print, stdout);


    dummy = bst_successor(bst);
    if(NULL != dummy){
        printf("root's successor:%s\n", (char *)bst_get_key(dummy));
    }

    dummy = bst_predecessor(bst);
    if(NULL != dummy){
        printf("root's predecessor:%s\n", (char *)bst_get_key(dummy));
    }
}

static
int 
compare(const void *x, const void *y)
{
    return strcmp((char *)x, (char *)y);
}

static
void
print(const void *key, void *cl)
{
    FILE *stream = cl;

    fprintf(stream, "%s\n", (char*)key);
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
