#ifndef BANK_H
#define BANK_H
#define M_OPEN  1
#define M_DESTORY 2
#define M_SAVE	3
#define M_TAKE	4
#define M_FIND	5
#define M_TRAN	6
#define M_LOGIN 7
#define M_EXIT	0
#define M_OPEN_SUCC 100
#define M_OPEN_FAIL	101
#define M_DESTORY_SUCC 102
#define M_DESTORY_FAIL	103
#define M_LOGIN_SUCC 104
#define M_LOGIN_FAIL 105
#define M_NULL	106
#define M_SAVE_SUCC  107
#define M_SAVE_FAIL 108
#define M_TAKE_SUCC	109
#define M_TAKE_FAIL 110
#define M_FIND_SUCC 111
#define M_TRAN_SUCC 112
#define M_TRAN_FAIL 113
#define MAX_NAME 15
#define MAX_PASSWD 8
#define STAT_LOGOUT	200
#define STAT_LOGIN	201
typedef struct
{
	char name[MAX_NAME];			//账户姓名
	int id;							//账户ID
	char passwd[MAX_PASSWD];		//账户密码
	float balance;					//账户余额
	int stat;						//账户状态
	int id1;						//是否有正在转账的账号
}Account;
typedef struct
{
	long msgtype;		//消息类型
	Account acc;		//消息内容 
}Msg;
#endif
