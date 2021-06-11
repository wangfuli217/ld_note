#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<signal.h>
#include"except.h"
#include"assert.h"

#define T except_t

static void _default_except_handler(const T *e,
                                    const char *file,
                                    const char *func,
                                    const char *reason,
                                    int line);

static void _signal_except_handler(int sig);

volatile struct except_context except_ctx = {.default_handler = _default_except_handler, 
                                        .except_flag = Except_entered,
                                        .sig = 0,
                                        .stack = NULL};

const T RuntimeException            = {"RuntimeException"};
const T IndexOutOfBoundsException   = {"IndexOutOfBoundsException"};
const T IOException                 = {"IOException"};
const T IllegalArgumentException    = {"IllegalArgumentException"};
const T ArithmeticException         = {"ArithmeticException"};
const T NullPointerException        = {"NullPointerException"};
const T SignalException             = {"SignalException"};

void
except_set_default_handler(void (*handler)(const T *e,
                                            const char *file,
                                            const char *func,
                                            const char *reason,
                                            int line))
{
    except_ctx.default_handler = handler;
}


void 
except_raise(const T *e, 
                const char *file,
                const char *func,
                const char *reason,
                int line)
{
    struct except_frame *frame = except_ctx.stack;
    assert(e);

    if(NULL == frame){
        (*(except_ctx.default_handler))(e, file, func, reason, line);
    }else{
        frame->exception = e;
        frame->file = file;
        frame->func = func;
        frame->reason = reason;
        frame->line = line;
        except_ctx.stack = except_ctx.stack->prev;
        longjmp(frame->env, Except_raised);
    }
}

void 
set_signal_except(int sig)
{
   signal(sig, _signal_except_handler); 
}

int
get_except_signal()
{
    return except_ctx.sig;
}


static
void 
_default_except_handler(const T *e,
                        const char *file,
                        const char *func,
                        const char *reason,
                        int line)
{
    fprintf(stderr, "Abort for a uncaught exception type:%s\n"
                    "raised in %s at %s:%d\n"
                    "reason:%s\n",
                    e->type, 
                    func, file, line,
                    reason);
    fflush(stderr);
    abort();
}

static
void 
_signal_except_handler(int sig)
{
    except_ctx.sig = sig;
    except_raise(&SignalException,
                __FILE__,
                __func__,
                "",
                __LINE__);
}
