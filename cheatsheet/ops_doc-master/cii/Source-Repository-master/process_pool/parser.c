#include "typedef.h"
#include <stdio.h>
#include <string.h>
#include "semi_generic_llist.h"
#include "debug.h"
#include "parser.h"

/* Convert string to a string array */
int str2strarr(char* str,char* strArr[]){
	while(1){
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
int cmd_parser(PtLList_t L,char* cmd,int sockfd){
	char buf[100]={0};
	char* strArr[10]={0};
	str2strarr(cmd,strArr);
	if(!strcmp("signup",strArr[0])){
		debug("%s %s %s\n",strArr[0],strArr[1],strArr[2]);
		info_t info;
		strcpy(info.name,strArr[1]);
		strcpy(info.passwd,strArr[2]);
		insert_head_llist(L,&info);
		strcpy(buf,"Signup Completed");
		send(sockfd,buf,sizeof(buf),0);

	}else if(!strcmp("login",strArr[0])){
		debug("%s %s %s\n",strArr[0],strArr[1],strArr[2]);
		info_t info;
		strcpy(info.name,strArr[1]);	
		strcpy(info.passwd,strArr[2]);	
		if(NULL != find_node_llist(L,&info)){
			strcpy(buf,"已登录");
			send(sockfd,buf,sizeof(buf),0);
		}else{
			strcpy(buf,"用户不存在或密码错误");
			write(sockfd,buf,sizeof(buf));
		}

	}else if(!strcmp("modify",strArr[0])){
		debug("%s %s %s\n",strArr[0],strArr[1],strArr[2]);
		debug("%d:%d:%d\n",strlen(strArr[0]),strlen(strArr[1]),strlen(strArr[2]));
		info_t info;
		strcpy(info.name,strArr[1]);	
		strcpy(info.passwd,strArr[2]);	
		if(NULL != find_node_llist(L,&info)){
			strcpy(buf,"请输入新密码");
			write(sockfd,buf,sizeof(buf));
			read(sockfd,buf,sizeof(buf));
			buf[strlen(buf)-1]='\0';	//客户端使用的是fgets,会有'\n'
			info_t info_new;
			strcpy(info_new.name,info.name);	
			strcpy(info_new.passwd,buf);	
			debug("%s:%s\n",info_new.name,info_new.passwd);
			modify_node_llist(L,&info,&info_new);

			strcpy(buf,"已修改");
			write(sockfd,buf,sizeof(buf));

		}else{
			strcpy(buf,"用户不存在或密码错误");
			write(sockfd,buf,sizeof(buf));
		}

	}else if(!strcmp("delete",strArr[0])){
		debug("%s %s %s\n",strArr[0],strArr[1],strArr[2]);
		info_t info;
		strcpy(info.name,strArr[1]);	
		strcpy(info.passwd,strArr[2]);	
		if(NULL != find_node_llist(L,&info)){
			delete_node_llist(L,&info);
			strcpy(buf,"已删除");
			write(sockfd,buf,sizeof(buf));
		}else{
			strcpy(buf,"用户不存在或密码错误");
			write(sockfd,buf,sizeof(buf));
		}
	}else if(!strcmp("search",strArr[0])){
		debug("%s %s %s\n",strArr[0],strArr[1],strArr[2]);
		info_t info;
		strcpy(info.name,strArr[1]);	
		strcpy(info.passwd,strArr[2]);	
		if(NULL == find_node_llist(L,(DataAddr_t)&info)){
			strcpy(buf,"不存在或密码错误");
			write(sockfd,buf,sizeof(buf));
		}else{
			strcpy(buf,"用户存在数据库中");
			write(sockfd,buf,sizeof(buf));
		}

	}else if(!strcmp("quit",strArr[0])){
		debug("%s\n",strArr[0]);
		save_llist_to_file(L,DATABASE);
		strcpy(buf,"已退出");
		write(sockfd,buf,sizeof(buf));

	}else{
		printf("No such cmd\n");
	}
	return 0;
}


























