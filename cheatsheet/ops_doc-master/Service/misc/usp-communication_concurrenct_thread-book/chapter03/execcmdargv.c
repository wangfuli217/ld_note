#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include "restart.h"

int makeargv(const char *s, const char *delimiters, char ***argvp);
 
int main(int argc, char *argv[]) {
   pid_t childpid;
   char delim[] = " \t";
   char **myargv;

   if (argc != 2) {
      fprintf(stderr, "Usage: %s string\n", argv[0]);
      return 1; 
   }
   childpid = fork();
   if (childpid == -1) {
      perror("Failed to fork");
      return 1; 
   }
   if (childpid == 0) {                              /* child code */
     if (makeargv(argv[1], delim, &myargv) == -1) {
        perror("Child failed to construct argument array");
     } else {
        execvp(myargv[0], &myargv[0]);
        perror("Child failed to exec command");
     }   
     return 1;
   }
   if (childpid != r_wait(NULL)) {                  /* parent code */
      perror("Parent failed to wait");
      return 1;
   }
   return 0; 
}
