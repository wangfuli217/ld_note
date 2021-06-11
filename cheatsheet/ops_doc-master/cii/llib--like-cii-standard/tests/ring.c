#include <ring.h>
#include <mem.h>
#include <test.h>

void by2(void** i, void* v) {
    int* ip;
    (void)v;

    ip = (int*)*i;
    *ip = *ip * 2;
}

unsigned test_ring_apply() {
    int k = 0, *p, i, sum = 0;
    Ring_T ring = Ring_new();

    for(i=0; i < 10; i++) {
        NEW(p);
        *p = k++;
        Ring_push_front(ring, (void*) p);
    }

    Ring_map(ring, by2, NULL);

    for(i=0; i < 10; i++) {
        int* res = ((int*)Ring_pop_front(ring));
        sum += *res;
        FREE(res);
    }
    test_assert(sum == 90);

    Ring_free(&ring);
    return TEST_SUCCESS;
}
