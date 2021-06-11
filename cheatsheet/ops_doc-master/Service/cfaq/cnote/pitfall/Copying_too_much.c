char buf[8]; /* tiny buffer, easy to overflow */
printf("What is your name?\n");
scanf("%s", buf); /* WRONG */
scanf("%7s", buf); /* RIGHT */