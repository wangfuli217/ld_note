#include <stdio.h>
#include <stdlib.h>

#include "array.h"

static void
d_array_char_test()
{
    d_array_t* a = d_array_create(1, 1);

    char* e = (char*)d_array_push(a, 10);

    strcpy(e, "123456789");

    e = d_array_push(a, 10);

    strcpy(e, "987654321");

    for (int i = 0; i < a->nelts; i++) {
        printf("char[%d]: %c\n", i, *((char*)a->elts + i));
    }

    d_array_destroy(a);
}

static void
d_array_int_test()
{
    d_array_t* a = d_array_create(sizeof(int), 1);

    int* e = (int*)d_array_push(a, 10);

    for (int i = 0; i < 10; i++) {
        *(e + i) = i;
    }

    e = (int*)d_array_push(a, 30);

    for (int i = 0; i < 30; i++) {
        *(e + i) = i * 30;
    }

    for (int i = 0; i < a->nelts; i++) {
        printf("int[%d]: %d\n", i, *((int*)a->elts + i));
    }

    d_array_destroy(a);
}

static void
d_array_struct_test()
{
    typedef struct {
        int             age;
        unsigned char   sex;
        char            name[10];
    } __attribute__((aligned(1))) human_s;

    typedef human_s human_t;

    d_array_t* a = d_array_create(sizeof(human_t), 1);

    human_t* e = d_array_push(a, 10);

    for (int i = 0; i < 10; i++) {
        (e + i)->age = i;
        (e + i)->sex = i;
        strcpy((e + i)->name, "chenbo");
    }

    e = d_array_push(a, 10);

    for (int i = 0; i < 10; i++) {
        (e + i)->age = i;
        (e + i)->sex = i;
        strcpy((e + i)->name, "chenbo");
    }

    for (int i = 0; i < a->nelts; i++) {
        printf("human[%d].age: %d\n", i, ((human_t*)a->elts + i)->age);
        printf("human[%d].sex: %d\n", i, ((human_t*)a->elts + i)->sex);
        printf("human[%d].name: %s\n", i, ((human_t*)a->elts + i)->name);
    }

    d_array_destroy(a);
}

int
main(int argc, char* argv[])
{
    d_array_char_test();

    d_array_int_test();

    d_array_struct_test();

    return 0;
}
