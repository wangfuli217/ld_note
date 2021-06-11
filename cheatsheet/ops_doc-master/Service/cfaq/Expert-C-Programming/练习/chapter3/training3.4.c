//这个程序通常取名为“cdecl”
//该程序用于分析C语言的声明并把它们翻译成通俗语言。

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#define MAXTOKENS 100
#define MAXTOKENLEN 64

enum type_tag { IDENTIFIER, QUALIFIER, TYPE };

struct token{
    char type;
    char string[MAXTOKENLEN];
};

int top = -1;
struct token stack[MAXTOKENS];
struct token this;

#define pop stack[top--]
#define push(s) stack[++top] = s

enum type_tag classify_string(void)
/* 推断标识符的类型 */
{
    char *s = this.string;
    if(!strcmp(s, "const"))
    {
        strcpy(s, "read-only");
        return QUALIFIER;
    }
    if(!strcmp(s, "volatile")) return QUALIFIER;
    if(!strcmp(s, "void")) return TYPE;
    if(!strcmp(s, "char")) return TYPE;
    if(!strcmp(s, "signed")) return TYPE;
    if(!strcmp(s, "unsigned")) return TYPE;
    if(!strcmp(s, "short")) return TYPE;
    if(!strcmp(s, "int")) return TYPE;
    if(!strcmp(s, "long")) return TYPE;
    if(!strcmp(s, "float")) return TYPE;
    if(!strcmp(s, "double")) return TYPE;
    if(!strcmp(s, "struct")) return TYPE;
    if(!strcmp(s, "union")) return TYPE;
    if(!strcmp(s, "enum")) return TYPE;
    return IDENTIFIER;
}

void gettoken(void) /* 读取下一个标记到“this”*/
{
    char *p = this.string;

    /* 略过空白字符 */
    while((*p = getchar()) == ' ');

    if(isalnum(*p))
    {
        /* 读入的标识符以A-Z,0-9开头。 */
        while (isalnum(*++p = getchar()));
        ungetc(*p, stdin);
        *p = '\0';
        this.type = classify_string();
        return;
    }

    if(*p == '*')
    {
        strcpy(this.string, "pointer to");
        this.type = '*';
        return;
    }
    this.string[1] = '\0';
    this.type = *p;
    return;
}

/* 理解所有分析过程的代码段 */
void read_to_first_identifier()
{
    gettoken();
    while (this.type != IDENTIFIER)
    {
        push(this);
        gettoken();
    }
    printf("%s is ",this.string);
    gettoken();
}

void deal_with_arrays()
{
    while(this.type == '[')
    {
        printf("array ");
        gettoken();     /* 数字或'[' */
        if(isdigit(this.string[0]))
        {
            printf("0..%d ",atoi(this.string) - 1);
            gettoken();     /* 读取‘[’ */
        }
        gettoken();         //读取'['之后的再一个标记
        printf("of ");
    }
}

void deal_with_function_args()
{
    while (this.type != ')')
    {
        gettoken();
    }
    gettoken();
    printf("function returning ");
}

void deal_with_pointers()
{
    while(stack[top].type == '*')
    {
        printf("%s ",pop.string);
    }
}

void deal_with_declarator()
{
    /* 处理标识符之后可能存在的数组/函数 */
    switch(this.type)
    {
        case '[': deal_with_arrays(); break;
        case '(': deal_with_function_args(); break;
    }

    deal_with_pointers();

    /* 处理在读入到标识符之前压入到堆栈中的符号 */
    while(top >= 0)
    {
        if(stack[top].type == '(')
        {
            pop;
            gettoken(); //读取‘(’之后的符号
            deal_with_declarator();
        }
        else
        {
            printf("%s ",pop.string);
        }
    }
}

int main()
{
    /* 将标记压入堆栈中，直到遇到标识符 */
    read_to_first_identifier();
    deal_with_declarator();
    printf("\n");
    return 0;
}
