#ifndef __PROCESS_C__
#define __PROCESS_C__

enum {
    /* Catch stdout and stderr */
    MODE_CATCH_BOTH = 0,

    /* Only catch stdout */
    MODE_CATCH_STDOUT = 1,

    /* Only catch stderr */
    MODE_CATCH_STDERR = 2,

    /* Catch all, but stderr will be redirect to stdout */
    MODE_CATCH_MERGE = 3
};

typedef void (*output_cb) (void *data, int len, void *addition);

int run_process (char *cmd, int mode, output_cb stdoutcb, output_cb stderrcb, void *addition);

#endif
