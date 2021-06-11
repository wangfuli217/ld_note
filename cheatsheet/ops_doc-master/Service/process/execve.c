#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>

int
main(int argc, char *argv[])
{
    char *newargv[] = { NULL, "hello", "world", NULL };
    char *newenviron[] = { NULL };

    assert(argc == 2);  /* argv[1] identifies
                           program to exec */
    newargv[0] = argv[1];

    execve(argv[1], newargv, newenviron);
    perror("execve");   /* execve() only returns on error */
    exit(EXIT_FAILURE);
}

/*
$ cc myecho.c -o myecho
$ cc execve.c -o execve
$ ./execve ./myecho
argv[0]: ./myecho
argv[1]: hello
argv[2]: world

*/

/*
$ cat > script.sh
#! ./myecho script-arg
^D
$ chmod +x script.sh
           
$ ./execve ./script.sh
argv[0]: ./myecho
argv[1]: script-arg
argv[2]: ./script.sh
argv[3]: hello
argv[4]: world         
*/
