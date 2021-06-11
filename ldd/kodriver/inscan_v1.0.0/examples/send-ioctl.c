/*   send-ioctl sends a CAN message specified at the command line       */
/*   It is using the SEND ioctl command                                */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#include "can4linux.h"


#define STDDEV "can1"

#ifndef TRUE
# define TRUE  1
# define FALSE 0
#endif


int can_fd;
int debug = FALSE;
int extd  = FALSE;
int rtr   = FALSE;

canmsg_t message;

void usage(char *s)
{
   static char *usage_text  = "\
      -r send message as rtr message.\n\
      -e send message in extended message format.\n\
      -d   - debug On\n\
      \n\
      ";
      fprintf(stderr, "usage: %s [options] [dev]\n", s);
      fprintf(stderr, "%s",usage_text);
}

int main(int argc,char **argv)
{
   int c;
   extern char *optarg;
   extern int optind, opterr, optopt;
   int cnt;
   char device[40] = STDDEV;
   Send_par_t SendTeil;
   /* our default 8 byte message */
   message.id      = 100;
   message.cob     = 0;
   message.flags   = 0;
   message.length  = 8;
   message.data[0] = 0x55;
   message.data[1] = 2;
   message.data[2] = 3;
   message.data[3] = 4;
   message.data[4] = 5;
   message.data[5] = 6;
   message.data[6] = 7;
   message.data[7] = 0xaa;
   while ((c = getopt(argc, argv, "derh")) != EOF) 
   {   
      switch (c) 
      {
      case 'r':
         rtr = TRUE;
         break;
      case 'e':
         extd = TRUE;
         break;
      case 'd':
         debug = TRUE;
         break;
      case 'h':
      default:	      
         usage(argv[0]); exit(0);
      }
   }
   
   /* look for additional arguments given on the command line */
   if ( argc - optind > 0 ) 
   {
      /* at least one additional argument, the device name is given */
      char *darg = argv[optind];
      if ( darg[0] == '/') 
      {
         sprintf(device, "%s", darg);
      } 
      else 
      {
         sprintf(device, "/dev/%s", darg);
      }
   } 
   else 
   {
      sprintf(device, "/dev/%s", STDDEV);
   }

   if(debug) printf("using CAN device %s\n", device);

   if(( can_fd = open(device, O_RDWR )) < 0 ) 
   {
      fprintf(stderr,"Error opening CAN device %s\n", device);
      exit(1);
   }

   if (rtr) 
   {
      message.flags |= MSG_RTR;
   }
   if (extd) 
   {
      message.flags |= MSG_EXT;
   }
   if ( debug == TRUE ) 
   {
      printf("send-ioctl " __DATE__ "\n");
      printf("(c) 2006 Involuser\n");
      printf(" using canmsg_t with %d bytes\n", sizeof(canmsg_t));
   }
   SendTeil.Tx = &message;
   cnt = ioctl(can_fd, CAN_IOCTL_SEND, &SendTeil);
   if(debug) 
   {
      printf("CAN Send retuned with %d/0x%x\n", cnt, cnt);
   }
   usleep(10000);
   close(can_fd);
   return 0;
}

