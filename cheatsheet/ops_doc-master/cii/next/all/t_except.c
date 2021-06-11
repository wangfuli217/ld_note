#include<stdio.h>
#include<stdlib.h>
#include<signal.h>
#include"except.h"
#include"assert.h"

static void test_e(int num);

int
main(int argc, char *argv[])
{
    
    int num;

    set_signal_except(SIGINT);
    
    if(2 == argc){
        num = atoi(argv[1]);
    }else{
        num = 3;
    }

    TRY
        test_e(num);
    CATCH(IOException)
        printf("Catch a %s", 
                IOException.type);
    CATCH(IndexOutOfBoundsException)
        printf("Catch a %s",
                IndexOutOfBoundsException.type);
    END_TRY;


}

static
void
test_e(int num)
{
    long cnt = 0;
    TRY  
        switch(num){
            case 0:
                RAISE(RuntimeException, "gggg");
            break;

            case 1:
                RAISE(IndexOutOfBoundsException, "you are out of bouds");
            break;

            case 2:
                RAISE(IOException, "some thing wrong with I/O");
            break;

            case 3:
                RAISE(IllegalArgumentException, "arg miss");
            break; 

            case 4:
                RAISE(ArithmeticException, "div by zero");
            break;

            case 5:
                RAISE(NullPointerException, "can't see");
            break; 

            case 9:
                while(1){
                    printf("loop:%ld\n", cnt++);
                }
            break;
            
            default:
                assert(num > 20);
            break;
        }
    CATCH(IOException)
        printf("test_e catch a %s\n",
                IOException.type);
    CATCH(SignalException)
        printf("Get a signal:%d\n", 
                EXCEPT_SIGNAL);
    FINALLY
        printf("test_e do clean work\n");
    END_TRY;
}
