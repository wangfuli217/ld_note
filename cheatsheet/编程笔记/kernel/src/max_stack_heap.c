#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

void *test(void *arg)
{
    static int i = 0;
    int buf[1024];
    printf("%d * 4k\n", i);
    ++i;
    test(NULL);
    return 0;
}

int main(int argc, const char *argv[])
{
    pthread_t p;
    pthread_create(&p, NULL, &test, NULL);
    sleep(100);
#if 0
    int i, cnt;
    unsigned long long max = 0;
    int blocksize[] = {1024 * 1024, 1024, 1};
    void *block;
    if (argc != 2) {
        fprintf(stderr, "Usage: `max_stack_heap stack|heap'\nto test max stack|heap size\n");
        exit(1);
    }
    if (!strncmp(argv[1], "stack", 5))
        test(NULL);
    for (i = 0; i < 3; ++i)
        for (cnt = 1; ; ++cnt)
            if ((block = malloc(max + blocksize[i] * cnt))) {
                max = max + blocksize[i] * cnt;
                free(block);
            } else break;
    printf("max malloc size = %llu mb\n", max >> 20);
#endif
    return 0;
}
