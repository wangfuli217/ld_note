#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/time.h>
#include "can4linux.h"
#include <time.h>
#define STDDEV "can1"
#define MAX 5
struct timespec begin,end;
int main(int argc,char **argv)
{
   int can_fd;		/* CAN file descriptor */
   int got, data,i;
   canmsg_t rx;		/* buffer for received message */
   canmsg_t tx[MAX];		/* buffer for transmit messsage */
   char device[40];	/* string to hold the CAN device Name */
   fd_set rfds;		/* file descriptors for select() */
   fd_set wfds;		/* file descriptors for select() */
   long long count;
   data = 0;
   got = 0;
   i = 0;
   if(argc == 2) 
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

   count = 0;
   /* prepare the fixed part of transmit message */
   for(i=0;i<MAX;i++)
   {
      tx[i].flags = 0;  
      tx[i].length = 8 ;
      tx[i].id=500 + i;
   }
   count = 0;

   while(1) 
   {
      clock_gettime(CLOCK_REALTIME,&begin);
      FD_ZERO(&rfds);
      FD_ZERO(&wfds);
      FD_SET(can_fd, &rfds);		/* watch on fd for CAN */
      FD_SET(can_fd, &wfds);		/* watch on fd for CAN */
      FD_SET(0, &rfds);		      /* watch on fd for stdin */
      if( select(FD_SETSIZE, &rfds, &wfds, NULL,     NULL  ) > 0 )
      {
          if( FD_ISSET(can_fd, &wfds) ) 
          {  
	    for(i=0;i<MAX;i++)
	    {
		data = count + i;
          	memcpy(&tx[i].data[0], &data, 8);
	    } 
            got = write(can_fd, tx, MAX);
            //usleep(1);
            count = count + got;
	    printf("write down %lld\n", count);
         }
         if( FD_ISSET(can_fd, &rfds) ) 
         {
            got = read(can_fd, &rx, 1);
            if (got)
            {
               printf("got one message");
            }
            if (rx.id == 0xFFFFFFFF) 
            {
               printf(" Error %d\n", rx.flags);
               if (rx.flags & MSG_BUSOFF) 
               {
                  printf(" - BUSOFF\n");
	    	      }
	    	      if (rx.flags & MSG_PASSIVE) 
               {
                  printf(" - ERROR PASSIVE\n");
               }
            }
         }
         if( FD_ISSET(0, &rfds) ) 
         {
            int c, i;
            /* it was the stdio terminal fd */
            i = read(0 , &c, 1);
            //printf(" key = %x\n", c);
            clock_gettime(CLOCK_REALTIME,&end);
	    printf("total write %lld messages",count);
		getchar();
         } /* stdio fd */
      }
   }
   close(can_fd);
   return 0;
}
