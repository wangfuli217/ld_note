/* This example puts all received datas in the file 'logfile.txt',
 * you can compare them with the transmited datas to test whether they are 
 * right
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include "can4linux.h"

#define STDDEV "can0"

#define MAX 100
/***********************************************************************
*
* main 
*
*/

int main(int argc,char **argv)
{
   int fd;
   int got;
   int c,count = 0;
   char *pname;
   extern char *optarg;
   extern int optind;

   canmsg_t rx[MAX];
   char device[50];
   FILE * logFile;
   printf("usage: %s [dev] \n", argv[0]);
   if(argc > 1) 
   {
      sprintf(device, "/dev/%s", argv[1]);
   }
   else 
   {
      sprintf(device, "/dev/%s", STDDEV);
   }
   
   fd = open(device, O_RDONLY|O_NONBLOCK);
   if( fd < 0 ) 
   {
      fprintf(stderr,"Error opening CAN device %s\n", device);
      perror("open");
      exit(1);
   }
   printf("using CAN device %s\n", device);
   logFile = fopen("logfile.txt","w");
   printf("The received message will be save in logfile.txt\n");
   while( 1)
   { 
      got=read(fd, rx, MAX);
      if( got > 0) 
      {  
         int i;
         int j;
	 
         for(i = 1; i <= got ; i++) 
         {
            fprintf(logFile,"%d\t",*(int*)rx[i-1].data ); 
            if((count + i)%10==0)
               fprintf(logFile,"\n" ); 
            fflush(stdout);
            fflush(logFile);
          }
   	  count+=got;
      } 
      else 
      {
         printf("Received with ret=%d\n", got);
         fflush(stdout);
      }
   }
   printf("count: %d\n",count);
   fclose(logFile);
   close(fd);
   return 0;
}
