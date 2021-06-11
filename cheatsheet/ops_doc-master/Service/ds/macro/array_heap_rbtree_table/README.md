DS
==

A simple set of C (C99) data structures extracted from another one of my
projects. You are free to use these sources in accordance with the Apache
licence. However, be warned, they are messy and very barely tested. Bug reports
patches, and any general comments are welcome.

In case you want to try to debug these macros, I recommend you run the
preprocessor and reformat the output and use the pre-processed sources.
This can be done using the following command when using gcc:

```
gcc -P -E -I./include test/table_test.c | ./indent-kernel > table_dbg.c
```

The `indent-kernel` script is provided in the root of this project to reformat
the generated sources in the Linux kernel coding style. This assumes you have
`indent` installed, astyle is also an alternative source formatter.
