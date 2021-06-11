/* 
* simple driver test: set the acceptance code and mask with ioctl()
* 
*/
/*****************************************************************
   Example for extended message format

          Bits
    mask  31 30 .....           4  3  2  1  0
    code
    -------------------------------------------
    ID    28 27 .....           1  0  R  +--+-> unused
                                      T
                                      R

    acccode =  (id << 3) + (rtr << 2) 
*******************************************************************

   Example for base message format

          Bits
    mask  31 30 .....           23 22 21 20 ... 0
    code
    -------------------------------------------
    ID    10  9.....                1  0  R  +--+-> unused
                                          T
                                          R
********************************************************************/
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
/***********************************************************************
*
* set_accmask - sets the CAN acceptance and mask register
*
*
* Changing these registers only possible in Reset mode.
*
* RETURN:
*
***************************************************************************/

int set_singlefilter(
	int fd,			/* device descriptor */
	int newcode,
	int newmask
	)
{
   Config_par_t  cfg;
   volatile Command_par_t cmd;


   cmd.cmd = CMD_STOP;
   ioctl(fd, CAN_IOCTL_COMMAND, &cmd);

   cfg.target = CONF_ACC; 
   cfg.val1   = newmask;
   cfg.val2   = newcode;
   ioctl(fd, CAN_IOCTL_CONFIG, &cfg);

   cmd.cmd = CMD_START;
   ioctl(fd, CAN_IOCTL_COMMAND, &cmd);
   return 0;
}

int main(int argc,char **argv)
{
   int fd0;
   int fd1;
   int newcode  = 0;
   int i,sent;
   canmsg_t tx[256];
   canmsg_t rx[256];
   int got;
   int status;

   printf("set accept code and  mask code to /dev/can0\n");
   printf("acccode =  (id << 3) + (rtr << 2) for extend message\n"); 
   printf("acccode =  (id << 21) + (rtr << 20)  for base  message\n"); 
   printf("using /dev/can0 device to accept message\n"); 
   printf("using /dev/can1 to transmit message\n");

   printf("set accept code to only accept the message which id = 10 and rtr = 0\n");
    
   if(( fd0 = open("/dev/can0", O_RDWR )) < 0 ) 
   {
      fprintf(stderr,"Error opening CAN device can0\n");
      exit(1);
   }

   if(( fd1 = open("/dev/can1", O_RDWR )) < 0 ) 
   {
      fprintf(stderr,"Error opening CAN device can1\n");
      exit(1);
   }
   //only accept the base message which id = 0x10 and rtr = 0
   //to learn about how to set the accept code,please read the manual for detail
   newcode = (16 << 21) + (0 << 20);
   printf("change acc_code to 0x%x\n", newcode);
   set_singlefilter(fd0, newcode, 0xfffff);
   //set_singlefilter(fd0,0x0, 0x1efffff);
   sleep(1);  
   if( fork()==0 )
   {  
      while(1) 
      {
         got=read(fd0, &rx, 1);
         if( got > 0) 
         {
            int i;
            int j;
            for(i = 0; i < got; i++) 
            {
               printf("Received with ret=%d: %12lu.%06lu id=0x%lx\n",
               got, 
               rx[i].timestamp.tv_sec,
               rx[i].timestamp.tv_usec,
               rx[i].id);
               printf("\tlen=%d msg=", rx[i].length);
               for(j = 0; j < rx[i].length; j++) 
               {
                  printf(" %02x", rx[i].data[j]);
               }
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
      close(fd0);
   }
   else
   {
      for(i = 0; i < 20; i++) 
      {
         sprintf( (char*)tx[i].data,"msg%d",i);
         printf("sending '%s'\n", tx[i].data );
         tx[i].flags =0;// MSG_EXT;  
         tx[i].length = strlen((char*)tx[i].data);  
         tx[i].id=i;
      }
      sent = write(fd1, tx, 20); 
      //sleep(1);
      if(sent <= 0) 
      {
         perror("sent");
      }
      close(fd1);
   }
   wait(&status);
   return 0;
}
