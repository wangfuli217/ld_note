#define _GNU_SOURCE
#include <pwd.h>
#include <stdio.h>
#define BUFLEN 4096

int
main(void)
{
    struct passwd pw, *pwp;
    char buf[BUFLEN];
    int i;

    setpwent();
    while (1) {
        i = getpwent_r(&pw, buf, BUFLEN, &pwp);
        if (i)
            break;
        printf("%s (%d)\tHOME %s\tSHELL %s\n", pwp->pw_name,
               pwp->pw_uid, pwp->pw_dir, pwp->pw_shell);
    }
    endpwent();
    exit(EXIT_SUCCESS);
}