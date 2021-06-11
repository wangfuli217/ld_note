#ifndef __CMD_H__
#define __CMD_H__

/* Convert string to a string array */
int str2strarr(char* str,char* strArr[]);

/* Parse cmd and execute it */
int cmd_parser(PtLList_t L,char* cmd,int sockfd);

#endif 

























