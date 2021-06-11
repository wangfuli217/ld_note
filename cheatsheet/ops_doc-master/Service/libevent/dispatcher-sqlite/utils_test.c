#include <stdio.h>
#include <stdlib.h>
#include "debug.h"
#include "unit.h"
#include "utils.h"

char *http_get_test () {
    struct cUrl_response_t content;

    memset (&content, 0, sizeof (content));
    http_get ("https://www.baidu.com", &content);
    content.content[content.length - 1] = '\0';
    printf ("%d\n", content.length);
    printf ("%s\n", content.content);

    return NULL;
}

char *run_all_test () {
    ph_suite_start ();
    ph_run_test (http_get_test);
    return NULL;
}

PH_RUN_TESTS (run_all_test);
