#include "minunit.h"
#include <atom.h>

const char *a = "abcdefg";
const char *b = "abcdefg";
const char *c = "abc";
const int d[] = {3,2,3,4,5,6};
const char *e = "123456";

const char *atom_a;
const char *atom_b;
const char *atom_c;
const char *atom_d;
const char *atom_e;
const char *atom_f;
const char *atom_tmp;


char *test_new()
{
    atom_d = atom_new((char *)d, 6*sizeof(int));
    atom_tmp = atom_new((char *)d, 6*sizeof(int));
    mu_assert(atom_d == atom_tmp, "atom_new did not return the same atom\n");
    return NULL;
}

char *test_string()
{
    atom_a = atom_string(a);
    atom_b = atom_string(b);
    mu_assert(atom_a == atom_b, "atom_string did not return the same atom.\n");
    atom_c = atom_string(c);
    mu_assert(atom_a != atom_c, "atom_string returns the same atom with different contents.\n")

    return NULL;
}

char *test_int()
{
    atom_f = atom_int(123456);
    atom_tmp = atom_int(123456);
    mu_assert(atom_f == atom_tmp, "atom_int did not return the same atom.\n");

    atom_e = atom_string(e);
    mu_assert(atom_e == atom_f, "atom_int & atom_string did not return the same atom\n");

    return NULL;
}

char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_new);
    mu_run_test(test_string);
    mu_run_test(test_int);

    return NULL;
}

RUN_TESTS(all_tests);
