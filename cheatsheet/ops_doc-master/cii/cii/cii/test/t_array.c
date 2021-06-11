#include<stdio.h>
#include"array.h"

struct gg{
    union {
        int i;
        float f;
        double d;
    }data;

    unsigned long stamp;

    struct gg *next;
};

int
main(int argc, char *argv[])
{
    array_t int_array;
    array_t gg_array;
    array_t c1_array;
    array_t c2_array;
    struct gg gg_data = {.data.f = 0.13f, .stamp = 1130L, .next = NULL};
    int *int_data_ptr, int_data;
    struct gg * gg_data_ptr;

    int_data = 85;

    int_array = array_new(1024, sizeof(int));
    gg_array = array_new(2048, sizeof(struct gg));

    printf("Length of int_array:%zd, length of gg_array:%zd\n", 
            array_length(int_array), array_length(gg_array));

    printf("Size of int_array:%zd, size of gg_array:%zd\n",
            array_size(int_array), array_size(gg_array));


    array_put(int_array, 1000, &int_data);
    array_put(gg_array, 1000, &gg_data);

    int_data_ptr = array_get(int_array, 1000);
    gg_data_ptr = array_get(gg_array, 1000);

    printf("Get int data:%d, get gg data with stamp:%ld\n",
            *int_data_ptr, gg_data_ptr->stamp);

    array_resize(int_array, 2048);
    array_resize(gg_array, 4096);

    array_put(int_array, 2000, &int_data);
    array_put(gg_array, 3000, &gg_data);

    c1_array = array_copy(int_array, 2001);
    c2_array = array_copy(gg_array, 3001);

    int_data_ptr = array_get(c1_array, 2000);
    gg_data_ptr = array_get(c2_array, 3000);

    printf("Get int data:%d, get gg data with stamp:%ld\n",
            *int_data_ptr, gg_data_ptr->stamp);
}
