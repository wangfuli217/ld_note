#include <stdio.h>
#include "utstring.h"

int main (void) {
    UT_string *s;
    char binary[] = "\xff\xff";

    utstring_new (s);
    utstring_bincpy (s, binary, sizeof (binary));
    printf ("length is %u <-> sizeof(binary) is %lu\n", (unsigned) utstring_len (s), sizeof (binary));

    utstring_clear (s);
    utstring_printf (s, "number %d", 10);
    printf ("%s\n", utstring_body (s));

    utstring_free (s);
    return 0;
}
