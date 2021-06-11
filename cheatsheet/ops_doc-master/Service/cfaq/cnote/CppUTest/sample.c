/* file: sample.c */

#include "sample.h"

#ifndef CPPUTEST
int main(int argc, char *argv[])
{
    char* pa;
    char* pb;
    pa = (char*)malloc(sizeof(char) * 80);
    pb = (char*)malloc(sizeof(char) * 20);

    strcpy(pa, "abcdefg\0");
    strcpy(pb, "hijklmn\0");
        
    printf ("Sample Start......\n");
    
    ret_void();
    printf ("ret_int: %d\n", ret_int(100, 10));
    printf ("ret_double: %.2f\n", ret_double(100.0, 10.0));
    printf ("ret_pchar: %s\n", ret_pchar(pa, pb));

    struct Student* s = (struct Student*) malloc(sizeof(struct Student));
    s->name = (char*) malloc(sizeof(char) * 80);
    
    init_student(s, "test cpputest", 100);
    printf ("init_Student: name=%s, score=%d\n", s->name, s->score);
    printf ("Sample End  ......\n");
    free(pa);
    free(pb);
    free(s->name);
    free(s);
    
    return 0;
}
#endif

void ret_void(){
    printf ("Hello CPPUTest!\n");
}

/* ia + ib */
int ret_int(int ia, int ib){
    return ia + ib;
}

/* da / db */
double ret_double(double da, double db){
    return da / db;
}

/* pa = pa + pb */
char* ret_pchar(char* pa, char* pb){
    return strcat(pa, pb);
}

#if 0
/* s->name = name, s->score = score */
void init_student(struct Student* s, char* name, int score){
    strcpy(s->name, name);
    s->score = score;
}

#endif

#if 1
/* s->name = name, s->score = score */
void init_student(struct Student* s, char* name, int score)
{
    char* name2 = NULL;
    name2 = (char*) malloc(sizeof(char) * 80); /* 这里申请的内存, 最后没有释放 */
    strcpy(s->name, name2);

    strcpy(s->name, name);
    s->score = score;
}
#endif