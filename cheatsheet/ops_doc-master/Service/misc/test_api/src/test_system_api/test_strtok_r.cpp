#include<stdio.h>
#include<string.h>

#define INFO_MAX_SZ 255

int main() {
    int in = 0;
//    char buffer[INFO_MAX_SZ] = "Fred male 25,John male 62,Anna female 16";
    char buffer[INFO_MAX_SZ] = "2:1";
    char *p[20];
    char *buf = buffer;

    char *outer_ptr = NULL;
    char *inner_ptr = NULL;
#if 1

    while ((p[in] = strtok_r(buf, "/,\\:", &inner_ptr)) != NULL) {
//    while ((p[in] = strtok_r(buf, " ", &inner_ptr)) != NULL) {
        printf("inner_ptr = %s.\n", inner_ptr);
        in++;
        buf = NULL;
    }
#else
    while ((p[in] = strtok_r(buf, ",", &outer_ptr)) != NULL) {
        buf = p[in];
        while ((p[in] = strtok_r(buf, " ", &inner_ptr)) != NULL) {
            in++;
            buf = NULL;
        }
        p[in++] = "***";
        buf = NULL;
    }
#endif
    printf("Here we have %d strings\n", in);
    for (int j = 0; j < in; j++)
        printf(">%s<\n", p[j]);
    return 0;
}
