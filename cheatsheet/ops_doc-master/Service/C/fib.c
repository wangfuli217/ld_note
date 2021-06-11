#include <stdio.h>
int fibonacci(int n);
int main(int argc, char **argv)
{
    int fib;
    int n;
    for (n = 0; n <= 42; n++) {
        fib = fibonacci(n);
        printf("fibonnaci(%d) = %dn", n, fib);
    }
    return 0;
}
int fibonacci(int n)
{
    int fib;
    if (n <= 0) {
        fib = 0;
    } else if (n == 1) {
        fib = 1;
    } else {
        fib = fibonacci(n -1) + fibonacci(n - 2);
    }
    return fib;
}

/* V:\rtu\otdr\crosstool\cheatsheet\ops_doc-master\Service\Callgraph.sh */
/* http://www.tinylab.org/source-code-analysis-gprof2dot-draw-a-runtime-function-calls-the-c-program/ */