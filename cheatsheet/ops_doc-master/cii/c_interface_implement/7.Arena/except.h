#ifndef EXCEPT_INCLUDED
#define EXCEPT_INCLUDED
#include <setjmp.h>

//异常信息 
typedef struct Except_T {
	char *reason;
} Except_T;

//异常栈 
typedef struct Except_Frame {
	struct Except_Frame *prev;	//前一帧 
	jmp_buf env;		//longjmp和setjmp的参数 
	const char *file;	//文件名 
	int line;			//行号 
	const Except_T *exception;	//异常名称 
}Except_Frame;

//异常处理的状态
enum 
{ 
	Except_entered = 0, //第一次进入，未发生异常 
	Except_throwed,		//异常抛出 
    Except_handled,   	//捕获异常 
	Except_finalized	//异常已处理
};

extern Except_Frame *Except_stack;//异常栈的声明

void Except_throw(const Except_T *e, const char *file,int line);

//抛出异常，由CATCH来处理 
#define THROW(e) 	 Except_throw(&(e),__FILE__,__LINE__)

//未CATCH的异常，打印异常信息 
#define	UNCATCHTHROW Except_throw(Except_frame.exception, Except_frame.file, Except_frame.line)

//无异常弹出该异常帧 
#define POP if(Except_flag == Except_entered) \
				Except_stack = Except_stack->prev;  

//开始try，创建一个异常帧来存储相关信息，并压栈 
#define TRY \
	do\
	{   \
		volatile int Except_flag;\
		Except_Frame Except_frame;\
		Except_frame.prev = Except_stack;\
		Except_stack = &Except_frame;\
		Except_flag = setjmp(Except_frame.env);/*第二次回调是Except_stack已变化*/\
		if (Except_flag == Except_entered){
			//现在可以执行相关处理 
			//do();
			
#define CATCH(e) \
			POP\
		}\
		else if (Except_frame.exception == &(e))/*第二次回调是Except_stack已变化*/\
		{\
			Except_flag = Except_handled;
			//现在对发生异常进行操作 
			
#define ELSE \
			POP\
		}\
		else\
		{\
			Except_flag = Except_handled;
			
#define FINALLY \
			POP\
		}\
		{\
			if (Except_flag == Except_entered)\
				Except_flag = Except_finalized;

#define END_TRY	\
			POP\
		}\
		if (Except_flag == Except_throwed) \
			UNCATCHTHROW; \
} while (0)

#endif

