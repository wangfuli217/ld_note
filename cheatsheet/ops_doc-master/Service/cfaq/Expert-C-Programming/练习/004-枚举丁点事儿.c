#include <stdio.h>
#include <stdlib.h>


//枚举定义的方式： enum [枚举名标签tag] {...};
enum  person { id, gender};
typedef enum { id, name} STUDENT;


struct PARTINFO{ //PARTINFO是结构体标签tag
    int cost;
    int supplier;
    enum {PART=1, SUBASSY=1} type;
};

typedef struct PARTINFO abc;

int main()
{
    abc abc = {10, 0, PART};
    if(abc.type == PART){
        printf("PART....PART\n");
    }
    if(abc.type == SUBASSY){
        printf("SUBASSY...SUBASSY\n");
    }
    
    /*
    Output/输出：
      PART....PART
      SUBASSY...SUBASSY
    
    
    Explenation/解释：
      (1) 不同枚举中的名字必须互不相同，同一枚举中不同的名字可以具有相同的值。
      (2) 枚举可以看做一组有关联的宏定义。所以名字必须不同，但是值可以相同。
          但是，如果值相同会失去枚举的意义(做判断)！
      (3) typedef定义的类型不是关键字，可以和变量名字相同，
          但是一旦定义相同名字的变量，这个名字就变成了变量 而不是类型！！ 所以 任何时候不要这么做！
    
    */
    

    return 0;
}