#include <stdio.h>
#include <stdlib.h> 
#include <assert.h>
#include "except.h" 

Except_Frame *Except_stack = NULL;

//�׳��쳣 
void Except_throw(const Except_T *e, const char *file,int line)
{
	Except_Frame *p = Except_stack;

	assert(e);
	if (p == NULL) {	//pΪNULL�������׳��쳣��û��CATCH���쳣����û��TRYֱ��THROW�쳣 
		fprintf(stderr, "Uncaught exception");
		if (e->reason)
			fprintf(stderr, " %s", e->reason);
		else
			fprintf(stderr, " at 0x%p", e);
		if (file && line > 0)
			fprintf(stderr, " raised at %s:%d\n", file, line);
		fprintf(stderr, "aborting...\n");
		fflush(stderr);
		abort();
	}
	p->exception = e;	//�޸��˴�����Ϣ 
	p->file = file;
	p->line = line;
	Except_stack = Except_stack->prev;		//�����쳣֡ 
	longjmp(p->env, Except_throwed); 
}
