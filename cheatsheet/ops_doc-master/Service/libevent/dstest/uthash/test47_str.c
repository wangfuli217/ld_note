#include <stdio.h>
#include "utstring.h"

int main (void) {
    UT_string *s, *t;
    char a[] = " text";

    puts ("utstring_concat hello and world");
    utstring_new (s);
    utstring_new (t);

    utstring_printf (s, "hello ");
    utstring_printf (s, "world ");

    puts ("utstring_concat hi and there");
    utstring_printf (t, "hi ");
    utstring_printf (t, "there ");

    utstring_concat (s, t);
    printf ("length: %u\n", (unsigned) utstring_len (s));
    printf ("%s\n", utstring_body (s));

    utstring_clear (s);
    utstring_clear (t);

    // utstring_printf and utstring_bincpy -> append
    puts ("utstring_bincpy same utstring_printf");
    utstring_printf (s, "hello %s", "wrold");
    printf ("%s\n", utstring_body (s));
    utstring_bincpy (s, a, sizeof (a) - 1);
    printf ("%s\n", utstring_body (s));

    //utstring_concat
    puts ("utstring_concat");
    utstring_printf (t, " second");
    printf ("%s\n", utstring_body (t));
    utstring_concat (s, t);
    printf ("%s\n", utstring_body (s));

    //utstring_clear utstring_bincpy
    puts ("utstring_clear");
    utstring_clear (t);
    printf ("cleared, length t now:%u\n", (unsigned) utstring_len (t));
    printf ("length s now: %u\n", (unsigned) utstring_len (s));
    utstring_printf (t, "one %d two %u thress %s", 1, 2, "(3)");
    printf ("%s\n", utstring_body (t));
    printf ("length t now:%u\n", (unsigned) utstring_len (t));

    //utstring_free
    utstring_free (s);
    utstring_free (t);

    return 0;

}
