#ifndef EXCEPT_INCLUDED
#define EXCEPT_INCLUDED
#include <setjmp.h>

//�쳣��Ϣ 
typedef struct Except_T {
	char *reason;
} Except_T;

//�쳣ջ 
typedef struct Except_Frame {
	struct Except_Frame *prev;	//ǰһ֡ 
	jmp_buf env;		//longjmp��setjmp�Ĳ��� 
	const char *file;	//�ļ��� 
	int line;			//�к� 
	const Except_T *exception;	//�쳣���� 
}Except_Frame;

//�쳣�����״̬
enum 
{ 
	Except_entered = 0, //��һ�ν��룬δ�����쳣 
	Except_throwed,		//�쳣�׳� 
    Except_handled,   	//�����쳣 
	Except_finalized	//�쳣�Ѵ���
};

extern Except_Frame *Except_stack;//�쳣ջ������

void Except_throw(const Except_T *e, const char *file,int line);

//�׳��쳣����CATCH������ 
#define THROW(e) 	 Except_throw(&(e),__FILE__,__LINE__)

//δCATCH���쳣����ӡ�쳣��Ϣ 
#define	UNCATCHTHROW Except_throw(Except_frame.exception, Except_frame.file, Except_frame.line)

//���쳣�������쳣֡ 
#define POP if(Except_flag == Except_entered) \
				Except_stack = Except_stack->prev;  

//��ʼtry������һ���쳣֡���洢�����Ϣ����ѹջ 
#define TRY \
	do\
	{   \
		volatile int Except_flag;\
		Except_Frame Except_frame;\
		Except_frame.prev = Except_stack;\
		Except_stack = &Except_frame;\
		Except_flag = setjmp(Except_frame.env);/*�ڶ��λص���Except_stack�ѱ仯*/\
		if (Except_flag == Except_entered){
			//���ڿ���ִ����ش��� 
			//do();
			
#define CATCH(e) \
			POP\
		}\
		else if (Except_frame.exception == &(e))/*�ڶ��λص���Except_stack�ѱ仯*/\
		{\
			Except_flag = Except_handled;
			//���ڶԷ����쳣���в��� 
			
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

