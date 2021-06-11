/* simple driver test: just opens and closes the device
* 
* open is called with starting the application
* close is called after pressing ^C - SIGKILL 
*
* first argument can be the device name -- else it uses can0
*
* if a second arg is given, the programm loops with e read()
* call (so the `application' is a bit more advanced)
* The application sleeps <second argument> ms  between two read() calls.
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#include "can4linux.h"

#define STDDEV "can0"

unsigned long usleeptime = 1000;	/* 1000 ms */

void showCANStat(int fd);

void showCANStat(int fd)
{
   CanStatusPar_t status;
   char *m;  
   ioctl(fd, CAN_IOCTL_STATUS, &status);
   switch(status.type) 
   {
      case  CAN_TYPE_SJA1000:
         m = "sja1000";
         break;
      default:
         m = "unknown";
         break;
   }

   printf(":: %s %4d %2d %2d %2d %2d %2d tx:%3d/%3d: rx:%3d/%3d:\n",
      m,
      status.baud,
      status.status,
      status.error_warning_limit,
      status.rx_errors,
      status.tx_errors,
      status.error_code,
      status.tx_buffer_size,
      status.tx_buffer_used,
      status.rx_buffer_size,
      status.rx_buffer_used);
}


int main(int argc,char **argv)
{
   int fd, i, n;
   canmsg_t rx;
   char device[40];
   int count = 100000;
   if((argc > 1) && !strcmp(argv[1], "-h")) 
   {
      printf("%s: [dev] [sleep]]\ndev is \"can0\" .... \"canX\"\n"
    		"sleep in ms between read() calls\n",
    	argv[0]);
      exit(1);
   }

   if(argc > 1) 
   {
      if ( argv[1][0] == '.'
         || argv[1][0] == '/') 
      {
         sprintf(device, "%s", argv[1]);
      } 
      else 
      {
         sprintf(device, "/dev/%s", argv[1]);
      }
   } 
   else 
   {
      sprintf(device, "/dev/%s", STDDEV);
   }
   printf("using CAN device %s\n", device);
    
   if(( fd = open(device, O_RDWR )) < 0 ) 
   {
      fprintf(stderr,"Error opening CAN device %s\n", device);
      exit(1);
   }
   showCANStat(fd);
   if(argc == 3) 
   {
      usleeptime = atoi(argv[2]);
   }
      /* loop for a long time */
   while(count--) 
   {
      showCANStat(fd);
      do 
      {
         n = read(fd, &rx, 1);
         if(n < 0) 
         {
            perror("CAN read error");
         }
	 else if(n == 0) 
         {
            fprintf(stderr, "read returned 0\n");
	 } 
         else 
         {
            fprintf(stderr, "read: %c%c 0x%08lx : %d bytes:",
               rx.flags & MSG_EXT ? 'x' : 's',
               rx.flags & MSG_RTR ? 'R' : 'D',
               rx.id,   rx.length);
            if(rx.length > 0) 
            {
               fprintf(stderr, "\t");
               for ( i = 0; i < rx.length; i++ ) 
               {
                  fprintf(stderr, "%02x ", rx.data[i]);
               }
            }
            fprintf(stderr, "\n");
	  }
      } while( n == 1);
      usleep(usleeptime * 1000);
   } 
   close(fd);
   return 0;
}

