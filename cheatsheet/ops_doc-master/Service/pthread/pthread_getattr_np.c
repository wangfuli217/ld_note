#define _GNU_SOURCE     /* To get pthread_getattr_np() declaration */
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#define handle_error_en(en, msg) \
        do { errno = en; perror(msg); exit(EXIT_FAILURE); } while (0)

static void
display_stack_related_attributes(pthread_attr_t *attr, char *prefix)
{
    int s;
    size_t stack_size, guard_size;
    void *stack_addr;

    s = pthread_attr_getguardsize(attr, &guard_size);
    if (s != 0)
        handle_error_en(s, "pthread_attr_getguardsize");
    printf("%sGuard size          = %d bytes\n", prefix, guard_size);

    s = pthread_attr_getstack(attr, &stack_addr, &stack_size);
    if (s != 0)
        handle_error_en(s, "pthread_attr_getstack");
    printf("%sStack address       = %p", prefix, stack_addr);
    if (stack_size > 0)
        printf(" (EOS = %p)", (char *) stack_addr + stack_size);
    printf("\n");
    printf("%sStack size          = 0x%x (%d) bytes\n",
            prefix, stack_size, stack_size);
}

static void
display_thread_attributes(pthread_t thread, char *prefix)
{
    int s;
    pthread_attr_t attr;

    s = pthread_getattr_np(thread, &attr);
    if (s != 0)
        handle_error_en(s, "pthread_getattr_np");

    display_stack_related_attributes(&attr, prefix);

    s = pthread_attr_destroy(&attr);
    if (s != 0)
        handle_error_en(s, "pthread_attr_destroy");
}

static void *           /* Start function for thread we create */
thread_start(void *arg)
{
    printf("Attributes of created thread:\n");
    display_thread_attributes(pthread_self(), "\t");

    exit(EXIT_SUCCESS);         /* Terminate all threads */
}

static void
usage(char *pname, char *msg)
{
    if (msg != NULL)
        fputs(msg, stderr);
    fprintf(stderr, "Usage: %s [-s stack-size [-a]]"
            " [-g guard-size]\n", pname);
    fprintf(stderr, "\t\t-a means program should allocate stack\n");
    exit(EXIT_FAILURE);
}

static pthread_attr_t *   /* Get thread attributes from command line */
get_thread_attributes_from_cl(int argc, char *argv[],
                              pthread_attr_t *attrp)
{
    int s, opt, allocate_stack;
    long stack_size, guard_size;
            void *stack_addr;
    pthread_attr_t *ret_attrp = NULL;   /* Set to attrp if we initialize
                                           a thread attributes object */
    allocate_stack = 0;
    stack_size = -1;
    guard_size = -1;

    while ((opt = getopt(argc, argv, "ag:s:")) != -1) {
        switch (opt) {
        case 'a':   allocate_stack = 1;                     break;
        case 'g':   guard_size = strtoul(optarg, NULL, 0);  break;
        case 's':   stack_size = strtoul(optarg, NULL, 0);  break;
        default:    usage(argv[0], NULL);
        }
    }

    if (allocate_stack && stack_size == -1)
        usage(argv[0], "Specifying -a without -s makes no sense\n");

    if (argc > optind)
        usage(argv[0], "Extraneous command-line arguments\n");

    if (stack_size >= 0 || guard_size > 0) {
        ret_attrp = attrp;

        s = pthread_attr_init(attrp);
        if (s != 0)
            handle_error_en(s, "pthread_attr_init");
    }

    if (stack_size >= 0) {
        if (!allocate_stack) {
            s = pthread_attr_setstacksize(attrp, stack_size);
            if (s != 0)
                handle_error_en(s, "pthread_attr_setstacksize");
        } else {
            s = posix_memalign(&stack_addr, sysconf(_SC_PAGESIZE),
                               stack_size);
            if (s != 0)
                handle_error_en(s, "posix_memalign");
            printf("Allocated thread stack at %p\n\n", stack_addr);

            s = pthread_attr_setstack(attrp, stack_addr, stack_size);
            if (s != 0)
                handle_error_en(s, "pthread_attr_setstacksize");
        }
    }

    if (guard_size >= 0) {
        s = pthread_attr_setguardsize(attrp, guard_size);
        if (s != 0)
            handle_error_en(s, "pthread_attr_setstacksize");
    }

    return ret_attrp;
}

int
main(int argc, char *argv[])
{
    int s;
    pthread_t thr;
    pthread_attr_t attr;
    pthread_attr_t *attrp = NULL;    /* Set to &attr if we initialize
                                        a thread attributes object */

    attrp = get_thread_attributes_from_cl(argc, argv, &attr);

    if (attrp != NULL) {
        printf("Thread attributes object after initializations:\n");
        display_stack_related_attributes(attrp, "\t");
        printf("\n");
    }

    s = pthread_create(&thr, attrp, &thread_start, NULL);
    if (s != 0)
        handle_error_en(s, "pthread_create");

    if (attrp != NULL) {
        s = pthread_attr_destroy(attrp);
        if (s != 0)
            handle_error_en(s, "pthread_attr_destroy");
    }

    pause();    /* Terminates when other thread calls exit() */
}


/*
$ ulimit -s      # No stack imit ==> default stack size is 2MB
           unlimited
           $ ./a.out
           Attributes of created thread:
                   Guard size          = 4096 bytes
                   Stack address       = 0x40196000 (EOS = 0x40397000)
                   Stack size          = 0x201000 (2101248) bytes
$ ./a.out -g 4097
           Thread attributes object after initializations:
                   Guard size          = 4097 bytes
                   Stack address       = (nil)
                   Stack size          = 0x0 (0) bytes

           Attributes of created thread:
                   Guard size          = 8192 bytes
                   Stack address       = 0x40196000 (EOS = 0x40397000)
                   Stack size          = 0x201000 (2101248) bytes
 $ ./a.out -g 4096 -s 0x8000 -a
           Allocated thread stack at 0x804d000

           Thread attributes object after initializations:
                   Guard size          = 4096 bytes
                   Stack address       = 0x804d000 (EOS = 0x8055000)
                   Stack size          = 0x8000 (32768) bytes

           Attributes of created thread:
                   Guard size          = 0 bytes
                   Stack address       = 0x804d000 (EOS = 0x8055000)
                   Stack size          = 0x8000 (32768) bytes
*/
                   