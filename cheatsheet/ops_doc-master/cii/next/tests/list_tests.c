#include "minunit.h"
#include <stdbool.h>
#include <list.h>


int array[] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
list_t *lst = NULL;
list_t *run = NULL;

void print_list(list_t *lst)
{
    printf("list is: \n");
    for (; lst; lst = lst->rest) {
        printf("%d ", *(int *)lst->first);
    }
    printf("\n");
}

char *test_list()
{
    int i;
    lst = list_list(&array[0], &array[1], &array[2], &array[3], &array[4], &array[5], &array[6], &array[7], &array[8], NULL);
    list_t *tmp = lst;
    for (i=0; tmp; tmp = tmp->rest, i++) {
        mu_assert(tmp->first == &array[i], "list_list failed.\n");
    }
    return NULL;
}

bool list_equal(list_t *a, list_t *b)
{
    for(; a && b; a=a->rest, b=b->rest) {
        if (a->first != b->first) {
            return false;
        }
    }

    if (a!=NULL || b!=NULL) {
        return false;
    }

    return true;
}

char *test_copy()
{
    run = list_copy(lst);
    mu_assert(list_equal(lst, run), "list_copy error.\n");
    list_free(&run, NULL);
    mu_assert(run == NULL, "list_free is wrong.\n");
    return NULL;
}

char *test_append()
{
    list_t *a = NULL;
    list_t *b = NULL;
    a = list_list(&array[0], &array[1], &array[2], NULL);
    b = list_list(&array[3], &array[4], &array[5], &array[6], &array[7], &array[8], NULL);

    run = list_append(a, b);
    mu_assert(list_equal(run, lst), "list_append failed.");

    list_free(&run, NULL);
    mu_assert(run == NULL, "list_free is wrong.\n");
    return NULL;
}

char *test_push_pop()
{
    run = list_push(run, &array[1]);
    run = list_push(run, &array[2]);
    run = list_push(run, &array[3]);
    void *tmp;
    run = list_pop(run, &tmp);
    mu_assert(tmp == &array[3], "list_pop failed.\n");
    run = list_pop(run, &tmp);
    mu_assert(tmp == &array[2], "list_pop failed.\n");
    run = list_pop(run, &tmp);
    mu_assert(tmp == &array[1], "list_pop failed.\n");
    mu_assert(run == NULL, "list_pop failed.\n");

    run = list_pop(run, &tmp);
    mu_assert(run == NULL, "list_pop on an empty list failed.\n");
    return NULL;
}

char *test_reverse()
{
    int i;
    int nelts = sizeof(array)/sizeof(array[0]);
    for (i = 0; i < nelts; i++) {
        run = list_push(run, (void *)&array[i]);
    }
    run = list_reverse(run);
    mu_assert(list_equal(run, lst), "list_reverse generate wrong result.\n");
    return NULL;
}

char *test_length()
{
    mu_assert(list_length(lst) == 9, "list_length returned wrong result.\n");
    return NULL;
}

void addone(void **x, void *cl) 
{
    (void)cl;   /* cl not used, supress warning */
    int *tmp = (int *)(*x);
    *tmp = *tmp +1;
}

char *test_map()
{
    list_map(lst, addone, NULL);

    int i;
    int nelts = sizeof(array)/sizeof(array[0]);
    for (i = 0; i < nelts; i++) {
        mu_assert(array[i] == i+1, "list_map execution is wrong.\n");
    }
    return NULL;
}

char *test_array()
{
    void **x = list_to_array(lst, NULL);
    void **tmp = x;
    int n = 0;
    while (*tmp) {
        mu_assert(*(int *)(*tmp) == array[n], "list_to_array error.\n");
        n++;
        tmp++;
    }

    mu_assert(n==9, "list_to_array error.\n");

    return NULL;
}

char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_list);
    mu_run_test(test_copy);
    mu_run_test(test_append);
    mu_run_test(test_push_pop);
    mu_run_test(test_reverse);
    mu_run_test(test_length);
    mu_run_test(test_map);
    mu_run_test(test_array);

    return NULL;
}

RUN_TESTS(all_tests);
