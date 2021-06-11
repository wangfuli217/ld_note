#include <stdio.h>
#include <stdlib.h> 
#include <assert.h>
#include "except.h" 

Except_Frame *Except_stack = NULL;

//抛出异常 
void Except_throw(const Except_T *e, const char *file,int line)
{
	Except_Frame *p = Except_stack;

	assert(e);
	if (p == NULL) {	//p为NULL出现于抛出异常但没有CATCH该异常或者没有TRY直接THROW异常 
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
	p->exception = e;	//修改了错误信息 
	p->file = file;
	p->line = line;
	Except_stack = Except_stack->prev;		//弹出异常帧 
	longjmp(p->env, Except_throwed); 
}
