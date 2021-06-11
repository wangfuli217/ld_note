#include "minunit.h"

char *test_caseA()
{
    return NULL;
}

char *test_caseB()
{
    return NULL;
}

char *test_caseC()
{
    return NULL;
}

char *test_caseD()
{
    return NULL;
}

char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_caseA);
    mu_run_test(test_caseB);
    mu_run_test(test_caseC);
    mu_run_test(test_caseD);

    return NULL;
}

RUN_TESTS(all_tests);
