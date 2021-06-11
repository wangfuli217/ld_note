#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <unistd.h>

#include "can4linux.h"

#define STDDEV "can0"
#define  MAX 100

int main(int argc,char **argv)
{
   int can_fd;		/* CAN file descriptor */
   int got;
   canmsg_t rx[MAX];
   char device[40];	/* string to hold the CAN device Name */
   fd_set rfds;		/* file descriptors for select() */
   int count = 0;
   FILE * logFile = fopen("logfile.txt","w");

   printf("usage: %s <dev>]\n", argv[0]);
   printf("   e.g.:\n");
   printf("   %s /dev/can0\n", argv[0]);
   printf("   wait for CAN messages using select()\n");
   if ( argc > 1)
   {
      sprintf(device, "/dev/%s", argv[1]);
   }
   else
   {
      sprintf(device, "/dev/%s", STDDEV);
   }
   printf("using CAN device %s, ", device);
    
   if(( can_fd = open(device, O_RDWR )) < 0 ) 
   {
      fprintf(stderr,"Error opening CAN device %s\n", device);
      exit(1);
   }
   printf("got can_fd  %d\n", can_fd);
   while(1) 
   {
      FD_ZERO(&rfds);
      FD_SET(can_fd, &rfds);		/* watch on fd for CAN */
      FD_SET(0, &rfds);		/* watch on fd for stdin */
      if( select(FD_SETSIZE, &rfds, NULL, NULL,     NULL  ) > 0 )
      {
         if( FD_ISSET(can_fd, &rfds) ) 
         {
            got = read(can_fd, rx, MAX);
            if( got > 0) 
            {
               int i;
	       count = count + got;
               for(i = 0; i < got ; i++) 
               {
                  fprintf(logFile,"%d\t",*(int*)rx[i].data ); 
                  if((count + i)%10==0)
                     fprintf(logFile,"\n" ); 
                  fflush(stdout);
                  fflush(logFile);
               }
            }
            if( FD_ISSET(0, &rfds) ) 
            {
               int c, i;
               /* it was the stdio terminal fd */
               i = read(0 , &c, 1);
               printf(" key = %x\n", c);
            } /* stdio fd */
        }
        printf("count: %d\n",count);
     }
   }//end of while
   close(can_fd);
   return 0;
}
