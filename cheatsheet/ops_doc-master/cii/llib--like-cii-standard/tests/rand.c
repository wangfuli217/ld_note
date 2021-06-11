#include <math.h>

#include <rand.h>
#include <test.h>
#include <log.h>
#include <timer.h>
#include <stats.h>

unsigned test_rand() {
    int i, iters = 10000;
    long long tperf;
    Timer_T t;
    Stats_T stats = Stats_New();

    Rand_init(1);
    
    t = Timer_new_start();

    for(i = 0; i < iters; ++i) {
        double r = Rand_next();
        Stats_Add(stats, r);
    }
    
    tperf = Timer_elapsed_micro_dispose(t);


    //log_set(stderr, LOG_DBG);
    //log("Time to generate rnd: %f", tperf);
    //log_set(NULL, 0);

    test_assert_float(1 / sqrt(12.0), 0.01, stats->StdDev);
    test_assert_float(0.5, 1.96 * stats->StdErr, stats->Average);

    Stats_Free(&stats);

    return TEST_SUCCESS;
}

unsigned test_gauss() {
    int i, iters = 10000;
    Stats_T stats = Stats_New();

    Rand_init(1);

    for(i = 0; i < iters / 2; ++i) {
        double r1, r2;
        Rand_gauss(&r1, &r2);
        Stats_Add(stats, r1);
        Stats_Add(stats, r2);
    }

    test_assert_float(1., 0.01, stats->StdDev);
    test_assert_float(0, 1.96 * stats->StdErr, stats->Average);

    Stats_Free(&stats);
    return TEST_SUCCESS;
}

unsigned test_parallelrand1() {

    int iters = 10000, i;
    double sum12 = 0, sum1 = 0, sum2 = 0, covariance;

    Rand_init(1);
    Rand_init(2);

    for (i = 0; i < iters; ++i) {
        double r1 = Rand_next();
        double r2 = Rand_next();
        sum1 += r1;
        sum2 += r2;
        sum12 += r1 * r2;
    }

    covariance = (sum12 - sum1 * sum2 / iters) / iters;

    test_assert_float(0., 0.01, covariance);

    sum1 = 0, sum2 = 0, sum12 = 0;

    for (i = 0; i < iters / 2; ++i) {
        double r1, r2, r3, r4;
        Rand_gauss(&r1, &r2);
        Rand_gauss(&r3, &r4);
        sum1 += r1 + r2;
        sum2 += r3 + r4;
        sum12 += r1 * r3 + r2 * r4;
    }

    covariance = (sum12 - sum1 * sum2 / iters) / iters;

    test_assert_float(0., 0.01, covariance);


    return TEST_SUCCESS;
}
