#include "slist.h"
#include "test.h"

unsigned test_slist() {

    SList_T l1 = SList_list("rob", "john", "bob");
    SList_T l2 = SList_list(NULL);

    test_assert_int (SList_length(l1), 3);
    test_assert_int (SList_length(l2), 0);

    SList_free(&l2);
    SList_free(&l1);

    return TEST_SUCCESS;
}

static int scomp(void** x, void* s) {

    char* x1s = *x;
    char* x2s = s;

    if (strcmp(x1s, x2s) == 0)
        return FOUND;
    else
        return NOT_FOUND;
}

unsigned test_slist_find() {

    SList_T l1 = SList_list("rob", "john", "bob");
    char* rs;
    //SList_T l2 = SList_list(NULL);

    int f = SList_find(l1, scomp, "rob", NULL);
    test_assert_int(f, FOUND);

    f = SList_find(l1, scomp, "rob1", NULL);
    test_assert_int(f, NOT_FOUND);

    f = SList_find(l1, scomp, "rob", &rs);
    test_assert_str(rs, "rob");

    SList_free(&l1);

    return TEST_SUCCESS;
}