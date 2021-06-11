#include<stdio.h>
#include"fmt.h"
#include"except.h"


int
main(int argc, char *argv[])
{

    TRY  
        fmt_fprint(stdout,
                "The array interface has %x functions\n"
                "%x\n", 64, 64);
    CATCH(OverflowException)
        printf("Get a fmt overflow\n");
        printf("%s, in %s:%d, reason:%s\n",
                except_ctx.stack->func,
                except_ctx.stack->file,
                except_ctx.stack->line,
                except_ctx.stack->reason);
    CATCH(SignalException)
        printf("Get a signal:%d\n", 
                EXCEPT_SIGNAL);
    FINALLY
        printf("test_e do clean work\n");
    END_TRY;
}
