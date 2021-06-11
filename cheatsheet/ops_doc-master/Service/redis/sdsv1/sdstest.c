#include "sds.h"
#include <stdio.h>


void basic(void){
    // SDS basics
    sds mystring = sdsnew("Hello World!"); 
    printf("%s\n", mystring); 
    sdsfree(mystring);
}

void create(void){
    //Creating SDS strings
    sds mystring;
    char buf[3];

    buf[0] = 'A';
    buf[1] = 'B';
    buf[2] = 'C';
    mystring = sdsnewlen(buf,3);
    printf("%s of len %d\n", mystring, (int) sdslen(mystring));
    sdsfree(mystring);

    mystring = sdsempty(); 
    printf("%d\n", (int) sdslen(mystring));

    sds s1, s2; 
    s1 = sdsnew("Hello"); 
    s2 = sdsdup(s1); 
    printf("%s %s\n", s1, s2);
    sdsfree(s1);
    sdsfree(s2);
}

void length(void){
    sds s = sdsnewlen("A\0\0B",4);
    printf("%d\n", (int) sdslen(s));
    sdsfree(s);
}

void cat(void){
    sds s = sdsempty();
    s = sdscat(s, "Hello ");
    s = sdscat(s, "World!");
    printf("%s\n", s);
    sdsfree(s);

    sds s1 = sdsnew("aaa");
    sds s2 = sdsnew("bbb");
    s1 = sdscatsds(s1,s2);
    sdsfree(s2);
    printf("%s\n", s1);
    sdsfree(s1);

    s = sdsnew("Hello");
    s = sdsgrowzero(s,6);
    s[5] = '!'; /* We are sure this is safe because of sdsgrowzero() */
    printf("%s\n", s);
    sdsfree(s);
}
void fmt(void){
    sds s;
    int a = 10, b = 20;
    s = sdsnew("The sum is: ");
    s = sdscatprintf(s,"%d+%d = %d",a,b,a+b);
    sdsfree(s);

    char *name = "Anna";
    int loc = 2500;
    s = sdscatprintf(sdsempty(), "%s wrote %d lines of LISP\n", name, loc);
    sdsfree(s);

    int some_integer = 100;
    sds num = sdscatprintf(sdsempty(),"%d\n", some_integer);
    sdsfree(num);
}

void longlong(void){
    sds s = sdsfromlonglong(10000);
    printf("%d\n", (int) sdslen(s));
    sdsfree(s);
}

void trim(void){
    sds s = sdsnew("         my string\n\n  ");
    sdstrim(s," \n");
    printf("-%s-\n",s);
    sdsfree(s);
}
void range(void){
    sds s = sdsnew("Hello World!");
    sdsrange(s,1,4);
    printf("-%s-\n", s);
    sdsfree(s);

    s = sdsnew("Hello World!");
    sdsrange(s,6,-1);
    printf("-%s-\n", s);
    sdsrange(s,0,-2);
    printf("-%s-\n", s);
    sdsfree(s);
}
void copy(void){
    sds s = sdsnew("Hello World!");
    s = sdscpylen(s,"Hello Superman!",15);
    sdsfree(s);
}
void quote(void){
// JSON and CSV
    sds s1 = sdsnew("abcd");
    sds s2 = sdsempty();
    s1[1] = 1;
    s1[2] = 2;
    s1[3] = '\n';
    s2 = sdscatrepr(s2,s1,sdslen(s1));
    printf("%s\n", s2);
    sdsfree(s1);
    sdsfree(s2);
}
void token(void){
    sds *tokens;
    int count, j;

    sds line = sdsnew("Hello World!");
    tokens = sdssplitlen(line,sdslen(line)," ",1,&count);

    for (j = 0; j < count; j++)
        printf("%s\n", tokens[j]);
    sdsfreesplitres(tokens,count);
}
void join(void){
    char *tokens[3] = {"foo","bar","zap"};
    sds s = sdsjoin(tokens,3,"|");
    printf("%s\n", s);
    sdsfree(s);
}
void notice(void){
    sds s = sdsempty();
    s = sdscat(s,"foo");
    s = sdscat(s,"bar");
    s = sdscat(s,"123");
    sdsfree(s);

    s = sdsnew("Ladies and gentlemen");
    s = sdscat(s,"... welcome to the C language.");
    printf("%d\n", (int) sdsAllocSize(s));
    s = sdsRemoveFreeSpace(s);
    printf("%d\n", (int) sdsAllocSize(s));
    sdsfree(s);
}
void update(void){
    sds s = sdsnew("foobar");
    s[2] = '\0';
    printf("%d\n", sdslen(s));
    sdsupdatelen(s);
    printf("%d\n", sdslen(s));
    sdsfree(s);
}



int main(int argc, char *argv[]){
    basic();
    create();
    length();
    cat();
    fmt();
    longlong();
    trim();
    range(); // writing buffer
    quote();
    token();
    join();
    notice();
    update();
    // Zero copy append from syscalls
    return 0;
}
