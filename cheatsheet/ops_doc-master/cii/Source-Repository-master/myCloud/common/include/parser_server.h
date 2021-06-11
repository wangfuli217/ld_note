#ifndef __PARSER_SERVER_H__
#define __PARSER_SERVER_H__

#include <sqlite3.h>
#include <protocol.h>
#define SELECT_UL_NAME(arg) "select usrname from usrlist where usrname='"arg"'"
#define SELECT_UL_NAME_PASS(arg1,arg2) "select usrname,usrpasswd from usrlist where usrname='"arg1"' and usrpasswd='"arg2"'"
#define SELECT_UFL(arg1,arg2,arg3) "select filename,filesize from "arg1" where filename='"arg2"' and filesize='"arg3"'"
#define SELECT_UFL_NAME(arg1,arg2) "select filename,filesize from "arg1" where filename='"arg2"'"
#define DELETE_UFL_NAME(arg1,arg2) "delete from "arg1" where filename='"arg2"'"
#define RENAME_UFL(arg1,arg2,arg3) "update "arg1" set filename='"arg3"' where filename='"arg2"'"
#define SELECT_FL(arg1,arg2) "select filename and filesize from filelist where filename='"arg1"'and filesize='"arg2"'"
#define SELECTALL_UL(arg) "select * from "arg""
#define INSERT_UL(arg1,arg2) "insert into usrlist values('"arg1"','"arg2"')"
#define INSERT_FL(arg1,arg2) "insert into filelist values('"arg1"','"arg2"')"
#define INSERT_UFL(arg1,arg2,arg3) "insert into "arg1" values('"arg2"','"arg3"')"
#define CREAT_USR_FL_LIST(arg) "create table "arg"('filename','filesize')"
#define LIGHTTRANS(arg1,arg2,arg3) "insert into "arg1" select filename , filesize from filelist where filename='"arg2"' and filesize='"arg3"'"

extern char repo[100];

/* Convert string to a string array */
extern int str2strarr(char* str,char* strArr[]);

/* Parse cmd and execute it */
extern int signup_parser(sqlite3* db,char *name,char* passwd);

extern int login_parser(sqlite3* db,char* usrname,char* usrpasswd,char* sevname);

extern int list_parser(sqlite3* db,char*sevname,struct file* sendlistArr,int* itemNum);

extern int upload_parser(sqlite3* db,char* usrname,struct file* file,int* upfd);

extern int dnload_parser(sqlite3* db,char* usrname,struct file* recvdata,int* dnfd,int* size);

#endif //__PARSER_SERVER_H__





