#ifndef __PARSER_CLIENT_H__
#define __PARSER_CLIENT_H__

#define  BUFSIZE   1480
int parse_cmdline(char cmdline[100],datainfo_t* pdata, pack_t * head);
//function:  pack  user_cmd into  the sendbufer
//void pack(const char cmdline[100], char *sendbuf,  int *sendlen );

int  pack(const datainfo_t * pdata, const  pack_t * head,  char *  buf , int * buflen);

//function: unpack  bufer and decide what to do

int unpack( char * buf,  int sockfd );

void  print_helpinfo(void );

//void hex_output(char * start,  int len);
#endif //__PARSER_CLIENT_H__
