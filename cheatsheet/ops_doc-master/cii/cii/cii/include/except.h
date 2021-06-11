#ifndef EXCEPT_INCLUDE
#define EXCEPT_INCLUDE

#include <setjmp.h>

#define T except_t

typedef struct T{
    char *type;
}T; 

const extern T RuntimeException;
const extern T IndexOutOfBoundsException;
const extern T IOException;
const extern T IllegalArgumentException;
const extern T ArithmeticException;
const extern T NullPointerException;
const extern T SignalException;


struct except_frame{
	struct except_frame *prev;
	jmp_buf env;
	const char *file;
    const char *func;
    const char *reason;
	int line;
	const T *exception;
};

struct except_context{
	int except_flag; 
    int sig;
    struct except_frame *stack;
    void (*default_handler)(const T *e,
                            const char *file,
                            const char *func,
                            const char *reason,
                            int line);
};

enum { Except_entered=0, Except_raised,
       Except_handled,   Except_finalized };

extern volatile struct except_context except_ctx;


void except_set_default_handler(void (*handler)(const T *e,
                                                const char *file,
                                                const char *func,
                                                const char *reason,
                                                int line));
void except_raise(const T *e, 
                const char *file,
                const char *func,
                const char *reason,
                int line);

void set_signal_except(int sig);

int get_except_signal();



#define EXCEPT_SIGNAL get_except_signal()

#define RAISE(e, r) except_raise(&(e), __FILE__, __func__, (r), __LINE__)


#define RERAISE except_raise(frame.exception, \
	frame.file, frame.func, frame.reason, frame.line)


#define TRY do { \
	struct except_frame frame; \
	frame.prev = except_ctx.stack; \
	except_ctx.stack = &frame;  \
	except_ctx.except_flag = setjmp(frame.env); \
	if (except_ctx.except_flag == Except_entered) {


#define CATCH(e) \
		if (except_ctx.except_flag == Except_entered) except_ctx.stack = except_ctx.stack->prev; \
	} else if (frame.exception == &(e)) { \
		except_ctx.except_flag = Except_handled;


#define ELSE \
		if (except_ctx.except_flag == Except_entered) except_ctx.stack = except_ctx.stack->prev; \
	} else { \
		except_ctx.except_flag = Except_handled;


#define FINALLY \
		if (except_ctx.except_flag == Except_entered) except_ctx.stack = except_ctx.stack->prev; \
	} { \
		if (except_ctx.except_flag == Except_entered) \
			except_ctx.except_flag = Except_finalized;


#define END_TRY \
		if (except_ctx.except_flag == Except_entered) except_ctx.stack = except_ctx.stack->prev; \
		} if (except_ctx.except_flag == Except_raised) RERAISE; \
} while (0)

#undef T
#endif /*EXCEPT_INCLUDE*/
