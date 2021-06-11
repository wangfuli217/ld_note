#include <time.h>
#include <sys/time.h>
#include <inttypes.h>

    
double monotonic_seconds() {
    struct timeval tv;
    gettimeofday(&tv,NULL);
    return tv.tv_sec + (tv.tv_usec * 0.000001);
}

uint64_t monotonic_useconds() {
    struct timeval tv;
    gettimeofday(&tv,NULL);
    return (uint64_t)(tv.tv_sec)*UINT64_C(1000000)+(uint64_t)(tv.tv_usec);
}

uint64_t monotonic_nseconds() {
    return monotonic_useconds()*1000;
}

const char* monotonic_method() {
    return "gettimeofday";
}

uint32_t monotonic_speed(void) {
    uint32_t i;
    uint64_t st,en;
    i = 0;
    st = monotonic_useconds() + 10000;
    do {
        en = monotonic_useconds();
        i++;
    } while (en < st);
    return i;
}


#if 0
#include <unistd.h>
#include <stdio.h>
int main(void) {
    double st,en;
    uint64_t stusec,enusec;
    uint64_t stnsec,ennsec;

    printf("used method: %s\n",monotonic_method());
    st = monotonic_seconds();
    stusec = monotonic_useconds();
    stnsec = monotonic_nseconds();
    sleep(1);
    en = monotonic_seconds();
    enusec = monotonic_useconds();
    ennsec = monotonic_nseconds();
    printf("%.6lf ; %"PRIu64" ; %"PRIu64"\n",en-st,enusec-stusec,ennsec-stnsec);
}
#endif
