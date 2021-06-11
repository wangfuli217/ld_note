#include <stdio.h>
#include <string.h>
int main(void) {
    int num = 0;
    char str[128], *lf;
    scanf("%d", &num);
    fgets(str, sizeof(str), stdin);
    if ((lf = strchr(str, '\n')) != NULL) *lf = '\0';
    printf("%d \"%s\"\n", num, str);
    return 0;
}
/*
input:
42
life
output:
42

*/

#include <stdio.h>
#include <string.h>
int main(void) {
    int num = 0;
    char line_buffer[128] = "", str[128], *lf;
    fgets(line_buffer, sizeof(line_buffer), stdin);
    sscanf(line_buffer, "%d", &num);
    fgets(str, sizeof(str), stdin);
    if ((lf = strchr(str, '\n')) != NULL) *lf = '\0';
    printf("%d \"%s\"\n", num, str);
    return 0;
}

#include <stdio.h>
#include <string.h>
int main(void) {
    int num = 0;
    char str[128], *lf;
    int c;
    scanf("%d", &num);
    while ((c = getchar()) != '\n' && c != EOF);
    fgets(str, sizeof(str), stdin);
    if ((lf = strchr(str, '\n')) != NULL) *lf = '\0';
    printf("%d \"%s\"\n", num, str);
    return 0;
}