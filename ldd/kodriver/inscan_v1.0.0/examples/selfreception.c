/************************************************************************************
  self reception example
  when you run this example,you should run another example(such as receive example to receive)
  to receive the message transmit by selfreception
  at the same time,selfreception will also receive the message transmit by itself.
**************************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>

#include "can4linux.h"

#define STDDEV "can0"

int set_selfreception(
   int fd,			/* device descriptor */
   int flag
	)
{
   Config_par_t  cfg;
   volatile Command_par_t cmd;

   cmd.cmd = CMD_STOP;
   ioctl(fd, CAN_IOCTL_COMMAND, &cmd);

   cfg.target = CONF_SELF_RECEPTION; 
   cfg.val1   = flag;
   ioctl(fd, CAN_IOCTL_CONFIG, &cfg);

   cmd.cmd = CMD_START;
   ioctl(fd, CAN_IOCTL_COMMAND, &cmd);
   return 0;
}


int main(int argc,char **argv)
{
   int fd;
   int i, sent,count;
   canmsg_t tx[20];
   canmsg_t rx[20];
   char device[40];
   int got;
   int status;
   if(argc == 2) 
   {
      sprintf(device, "/dev/%s", argv[1]);
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
   //set self reception
   set_selfreception(fd,1);
   if( fork()==0 )
   {  
      while(1) 
      {
         got=read(fd, &rx, 1);
         if( got > 0) 
         {
            int i;
            int j;
            for(i = 0; i < got; i++) 
            {
               printf("Received with ret=%d id=%ld\n",
               got, 
               rx[i].id);
               //printf("len=%d msg=%s  ", rx[i].length,rx[i].data);
               printf("len=%d msg=%d  ", rx[i].length,*(int*)rx[i].data);
               printf(" flags=0x%02x\n", rx[i].flags );
               fflush(stdout);
            }
         } 
         else 
         {
            printf("Received with ret=%d\n", got);
            fflush(stdout);
         }

      }
      close(fd);
   }
   else
   {
      count = 0;
      while (1)
      {  
         for(i = 0; i < 4; i++) 
         {
           // sprintf( (char*)tx[i].data,"msg%d",i+count*4);
            //printf("sending '%s'\n", tx[i].data );
	    memcpy(&tx[i].data[0],&count,8); 
            count++;
            if(i%2)
               tx[i].flags = 0;  
            else
               tx[i].flags = MSG_EXT;  
               
            tx[i].length = 8; //strlen((char*)tx[i].data);  
            tx[i].id= count;
         }
         sent = write(fd, tx, 4); 
         sleep(1); 
         if(sent <= 0) 
         {
            perror("sent");
         }
         printf("count: %d\n",count);
      }
      close(fd);
   }
   wait(&status);
   return 0;
}

