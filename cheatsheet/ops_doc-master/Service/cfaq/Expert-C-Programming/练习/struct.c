#include <stdio.h>

#if 0
/* 处理ID信息 */
struct pid_tag {
  unsigned int inactive : 1;
  unsigned int              : 1;  //1个位的填充
  unsigned int recount : 6;
  unsigned int              : 0; //填充到下一个字边界
  short pid_id;
  struct pid_tag *link;
}
// 位段的类型必须是int, unsigned int 或 signed int (或加上限定符)。至于int位段的值可不可以取负值则取决于编译器。
#endif

struct s_tag {int a[10];};
struct s_tag orange,lime,lemon;
struct s_tag twofold(struct s_tag s){
    int j;
    for(j=0;j<10;j++){
        s.a[j] *= 2;
    }
    return s;
}
int main(void){
    int i;
    for(i=0;i<10;i++){
        lime.a[i] = 1;
    }
    lemon = twofold(lime);
    orange = lemon;
    for(i=0;i<10;i++){
        printf("%d ",lime.a[i]);
    }   
    printf("\n");
    for(i=0;i<10;i++){
        printf("%d ",lemon.a[i]);
    }
    printf("\n");
    for(i=0;i<10;i++){
        printf("%d ",orange.a[i]);
    }
    printf("\n");
    return 0;
}