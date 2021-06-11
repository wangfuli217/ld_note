#include <stdio.h>
#include <string.h>
int main(void)
{
    const char sepchars[] = ",.;!?";
    char foo[] = ";ball call,.fall gall hall!?.,";
    char *s;
    int n;
    for (s = foo; *s != 0; /*empty*/) {
        /* Get the number of token separator characters. */
        n = (int)strspn(s, sepchars);
        if (n > 0)
            printf("skipping separators: << %.*s >> (length=%d)\n", n, s, n);
        /* Actually skip the separators now. */
        s += n;
        /* Get the number of token (non-separator) characters. */
        n = (int)strcspn(s, sepchars);
        if (n > 0)
            printf("token found: << %.*s >> (length=%d)\n", n, s, n);
        /* Skip the token now. */
        s += n;
    }
    printf("== token list exhausted ==\n");
    return 0;
}