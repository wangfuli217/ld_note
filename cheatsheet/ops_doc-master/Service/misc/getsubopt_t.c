 #include <stdlib.h>
 ...
 char *tokens[] = {"HOME", "PATH", "LOGNAME", (char *) NULL };
 char *value;
 int opt, index;

 while ((opt = getopt(argc, argv, "e:")) != -1) {
     switch(opt)  {
     case ’e’ :
         while ((index = getsubopt(&optarg, tokens, &value)) != -1) {
             switch(index) {
 ...
         }
         break;
 ...
     }
 }
 ...