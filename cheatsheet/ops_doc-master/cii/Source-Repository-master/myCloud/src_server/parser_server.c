#include "typedef.h"
#include <sqlite3.h>
#include "parser_server.h"
#include <stdio.h>
#include <string.h>
#include "debug.h"
#include <stdlib.h>
#include "protocol.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

extern char repo[100];

/* Convert string to a string array */
int str2strarr(char* str,char* strArr[]){
	while(1){
		while(' '==*str){
			str++;
		}
		*strArr++=str;
		while(1){
			str++;
			if(' '==*str||'\n'==*str){
				*str='\0';
				str++;
				break;
			}else if('\0'==*str){
				break;
			}
		}
		if('\0'==*str)
			break;
	}
}

/* Parse cmd and execute it */
int signup_parser(sqlite3* db,char *name,char* passwd){	
	deprint("%s %s",name,passwd);
	char* errmsg;
	char** resultp;
	int nrow,ncolumn,i,j,index;
	char DBcmd[100];
	sprintf(DBcmd,SELECT_UL_NAME("%s"),name);
	if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
		deprint("");
		perror("sqlite3_get_table");
	}
	if(0==nrow||0==ncolumn){ //usrname is available
		sprintf(DBcmd,INSERT_UL("%s","%s"),name,passwd);
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}

		sprintf(DBcmd,CREAT_USR_FL_LIST("%s"),name);
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}
		return SUCCESS;
	}
	return USR_EXIST;
}


int login_parser(sqlite3* db,char* usrname,char* usrpasswd,char* sevname){
	deprint("%s %s",usrname,usrpasswd);
	char* errmsg;
	char** resultp;
	int nrow,ncolumn,i,j,index;
	char DBcmd[100];
	sprintf(DBcmd,SELECT_UL_NAME("%s"),usrname);
	deprint("%p",db);
	if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
		deprint("");
		perror("sqlite3_get_table");
	}
	if(0==nrow||0==ncolumn){ //usrname is UNavailable
		return NO_USR;
	}else{
		sprintf(DBcmd,SELECT_UL_NAME_PASS("%s","%s"),usrname,usrpasswd);
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}
		if(0==nrow||0==ncolumn){ //usrname is UNavailable
			return ERR_PASSWD;
		}
	}
	
	strcpy(sevname,usrname);
	return SUCCESS;
}

int list_parser(sqlite3* db,char*sevname,struct file* sendlistArr,int* itemNum){
	char* errmsg;
	char** resultp;
	int nrow,ncolumn,i,j,index;
	char DBcmd[100];

	sprintf(DBcmd,SELECTALL_UL("%s"),sevname);
	if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
	}
	if(0==ncolumn||0==nrow){
		return EMPTY;
	}else{
		for(i=0;i<=nrow; i++){
			for(j=0;j<ncolumn;j++){
				if(0==j){
					sprintf(sendlistArr[i].fileName,"%s",*resultp++);
					deprint("n%s ",sendlistArr[i].fileName);
				}
				if(1==j){
					sendlistArr[i].fileSize=atoi(*resultp++);
					deprint("s%d ",sendlistArr[i].fileSize);
				}
			}
			deprint("");			
		}
		*itemNum=nrow;
		return PREDOWNLOAD;
	}
}

int upload_parser(sqlite3* db,char* usrname,struct file* file,int* upfd){
	deprint("%s %d",file->fileName,file->fileSize);
	char* errmsg;
	char** resultp;
	int nrow,ncolumn,i,j,index;
	char DBcmd[100];

	sprintf(DBcmd,SELECT_UFL("%s","%s","%d"),usrname,file->fileName,file->fileSize);	//尝试用户表
	if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
		deprint("");
		perror("sqlite3_get_table");
	}

	if(0!=nrow||0!=ncolumn){	//用户有这个文件
		return FILE_EXIST;
	}
	
	sprintf(DBcmd,SELECT_FL("%s","%d"),file->fileName,file->fileSize);	//查询文件总表
	if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
		deprint("");
		perror("sqlite3_get_table");
	}
	deprint("nrow:%d,ncolumn:%d",nrow,ncolumn);
	if(0==nrow||0==ncolumn){	//文件总表没有这个文件，准备上传
		deprint("nrow:%d,ncolumn:%d",nrow,ncolumn);
		char tmp[sizeof(repo)]={0};
		strcpy(tmp,repo);
		strcat(tmp,"files/");
		*upfd=open(strcat(tmp,file->fileName),O_WRONLY|O_CREAT|O_TRUNC,0666);
		if(-1==*upfd){
			deprint("");
			perror("open");
		}
		//修改数据库
		sprintf(DBcmd,INSERT_FL("%s","%d"),file->fileName,file->fileSize);
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}

		sprintf(DBcmd,INSERT_UFL("%s","%s","%d"),usrname,file->fileName,file->fileSize);
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}
		return PREUPLOAD;
	}else {
		sprintf(DBcmd,LIGHTTRANS("%s","%s","%d"),usrname,file->fileName,file->fileSize);	//文件总表有这个文件
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}
		return FILE_EXIST; //秒传
	}
}

int dnload_parser(sqlite3* db,char* usrname,struct file* recvdata,int* dnfd,int* size){
	deprint("usrname:%s,filename:%s,fileSize:%d",usrname,recvdata->fileName,recvdata->fileSize);
	char* errmsg;
	char** resultp;
	int nrow,ncolumn,i,j,index;
	char DBcmd[100];
	sprintf(DBcmd,SELECT_UFL_NAME("%s","%s"),usrname,recvdata->fileName);
	if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
		deprint("");
		perror("sqlite3_get_table");
	}
	deprint("nrow:%d,ncolumn:%d",nrow,ncolumn);
	if(0==nrow&&0==ncolumn){	//没有文件
		return NOSUCHFILE;
	}else{
		char tmp[sizeof(repo)]={0};
		strcpy(tmp,repo);
		strcat(tmp,"files/");
		*dnfd=open(strcat(tmp,recvdata->fileName),O_RDONLY);
		deprint("*dnfd:%d",*dnfd);
		if(-1==*dnfd){
			deprint("");
			perror("open");
		}

		sprintf(DBcmd,SELECT_UFL_NAME("%s","%s"),usrname,recvdata->fileName);
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}
	
		for(i=0;i<=nrow; i++){
			for(j=0;j<ncolumn;j++){
				resultp++;
			}
			deprint("");
		}
		
		*size=atoi(*(resultp-1));
		deprint("%d",*size);
		return PREDOWNLOAD;
	}
	return 0;
}


int del_parser(sqlite3* db,char* usrname,struct file* recvdata){
	deprint("usrname:%s,filename:%s,fileSize:%d",usrname,recvdata->fileName,recvdata->fileSize);
	char* errmsg;
	char** resultp;
	int nrow,ncolumn,i,j,index;
	char DBcmd[100];
	sprintf(DBcmd,SELECT_UFL_NAME("%s","%s"),usrname,recvdata->fileName);
	if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
		deprint("");
		perror("sqlite3_get_table");
	}
	deprint("nrow:%d,ncolumn:%d",nrow,ncolumn);
	if(0==nrow&&0==ncolumn){	//没有文件
		return NOSUCHFILE;
	}else{
		sprintf(DBcmd,DELETE_UFL_NAME("%s","%s"),usrname,recvdata->fileName);
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}
		return SUCCESS;
	}
}
int rename_parser(sqlite3* db,char* usrname,struct file* oldfile,struct file* newfile){
	deprint("usrname:%s,filename:%s fileName:%s",usrname,oldfile->fileName,newfile->fileName);
	char* errmsg;
	char** resultp;
	int nrow,ncolumn,i,j,index;
	char DBcmd[100];
	sprintf(DBcmd,SELECT_UFL_NAME("%s","%s"),usrname,oldfile->fileName);
	if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
		deprint("");
		perror("sqlite3_get_table");
	}
	deprint("nrow:%d,ncolumn:%d",nrow,ncolumn);
	if(0==nrow&&0==ncolumn){	//没有文件
		return NOSUCHFILE;
	}else{
		sprintf(DBcmd,RENAME_UFL("%s","%s","%s"),usrname,newfile->fileName,oldfile->fileName);
		if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}
		return SUCCESS;
	}
}

int serverCMDParser(sqlite3* db,char* cmd){
	char* errmsg;
	char** resultp;
	int nrow,ncolumn,i,j,index;
	char DBcmd[100];

	if(!strcmp("init",cmd)){
		if(SQLITE_OK!=sqlite3_get_table(db,"select name from sqlite_master where type='table' order by name",&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}	
		char DBcmd[100];
		deprint("nrow:%d ncolumn:%d",nrow,ncolumn);
		for(i=0;i<=nrow; i++){
			for(j=0;j<ncolumn;j++){
				if(strcmp(*resultp,"usrlist")&&strcmp(*resultp,"filelist")&&strcmp(*resultp,"name")){
					sprintf(DBcmd,"drop table %s",*resultp);
					printf("%s\n",DBcmd);
					char** res;
					int row;
					int column;
					char* err;
					if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&res, &row, &column, &err)){
						deprint("");
						perror("sqlite3_get_table");
					}
				}else if(strcmp(*resultp,"name")) {
					sprintf(DBcmd,"delete from %s",*resultp);
					printf("%s\n",DBcmd);
					char** res;
					int row;
					int column;
					char* err;
					if(SQLITE_OK!=sqlite3_get_table(db,DBcmd,&res, &row, &column, &err)){
						deprint("");
						perror("sqlite3_get_table");
					}
				}
				deprint("%s ",*(resultp));
				resultp++;
			}
			deprint("\n");			
		}

#if 0

					if(SQLITE_OK!=sqlite3_get_table(db,"create table usrlist('usrname','usrpasswd)",&res, &row, &column, &err)){
						deprint("");
						perror("sqlite3_get_table");
					}
					if(SQLITE_OK!=sqlite3_get_table(db,"create table usrlist('filename','filesize)",&res, &row, &column, &err)){
						deprint("");
						perror("sqlite3_get_table");
					}
#endif
		char rm[10+sizeof(repo)]="rm -f ";
		char tmp[sizeof(repo)]={0};
		strcpy(tmp,repo);
		strcat(tmp,"files/");
		strcat(rm,strcat(tmp,"*"));
		system(rm);
		return 0;
	}
	if(!strcmp("list allusr",cmd)){
		if(SQLITE_OK!=sqlite3_get_table(db,"select name from sqlite_master where type='table' order by name",&resultp, &nrow, &ncolumn, &errmsg)){
			deprint("");
			perror("sqlite3_get_table");
		}	
		char DBcmd[100];
		deprint("nrow:%d ncolumn:%d",nrow,ncolumn);
		for(i=0;i<=nrow; i++){
			for(j=0;j<ncolumn;j++){
				if(strcmp(*resultp,"usrlist")&&strcmp(*resultp,"filelist")&&strcmp(*resultp,"name")){
					printf("%s\n",*resultp);
				}
				resultp++;
			}
//			printf("\n");
		}
		return 0;
	}


	if(SQLITE_OK!=sqlite3_get_table(db,cmd,&resultp, &nrow, &ncolumn, &errmsg)){
		deprint("");
		perror("sqlite3_get_table");
	}

	if(0!=nrow&&0!=ncolumn){
		for(i=0;i<=nrow; i++){
			for(j=0;j<ncolumn;j++){
				printf("%s ",*(resultp++));
			}
			printf("\n");
		}

	}
	return 0;
}









