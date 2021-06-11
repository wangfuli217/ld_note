
/*   Transmit sends a bunch of telegrams by filling them with       */
/*   different CANids and data bytes. You may send more than one    */
/*   telegram with write just by sending out an array of telegrams. */
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include "can4linux.h"

#define STDDEV "can1"
#define MAX 500
int main(int argc,char **argv)
{
   int fd;
   int i, sent = 0, count = 0;
   canmsg_t tx[MAX];
   char device[40];
   if(argc == 2) 
   {
      sprintf(device, "/dev/%s", argv[1]);
   }
   else 
   {
      sprintf(device, "/dev/%s", STDDEV);
   }
   printf("using CAN device %s\n", device);
   if(( fd = open(device, O_RDWR|O_NONBLOCK )) < 0 ) 
   {
      fprintf(stderr,"Error opening CAN device %s\n", device);
      exit(1);
   }
   for(i=0;i<MAX ;i++)
   {
      memcpy(&tx[i].data[0],&i,4);
      if(i%2)
         tx[i].flags = 0; 
      else
         tx[i].flags = MSG_EXT;  
      tx[i].length = 4 ;
      tx[i].id=500 + i;

      sent = 0;
   }
   while (sent < MAX )
   {
      count = write(fd,&tx[sent],MAX-sent);
      printf("write down %d\n",count);
      sent = sent + count;
   sleep(1);
   }
   close(fd);
   return 0;
}

