/***
 * 利用setjmp和longjmp做错误处理
 * 关于执行流跳转见: http://www.misakar.me/coroutine_in_c/
 */
#include <setjmp.h>

#define TOK_ADD 5
#define MAXLINE 1024

void do_line(char *);
void cmd_add(void);
int get_token(void);

// global
jmp_buf jmp;

int main(void) {
    char line[MAXLINE];
    if ((rv = setjmp(jmp)) != 0) {
        // handle error
        if (rv == 1) {
            printf("cmd_add error");
        }
    }
    // first call
    while (fgets(line, MAXLINE, stdin) != NULL) {
        do_line(line);
    }
    return 0;
}

char* tok_ptr;

void do_line(char* ptr) {
    int cmd;
    tok_ptr = ptr;
    while ((cmd = get_token()) > 0) {
        switch (cmd) {  
            case TOK_ADD:
                cmd_add();
                break;
            /* one case for each command */
        }
    }
}

void cmd_add(void) {
    int token;
    token = get_token();
    // 每次cmd_add调用get_token后, get_token的执行点(栈环境)需要被保存,
    // 从而防止重复获取token.
    if (token < 0) {
        longjmp(jmp, 1);
    }
}

int get_token(void) {

}