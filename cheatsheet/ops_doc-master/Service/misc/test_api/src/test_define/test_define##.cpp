#include <stdio.h>

struct _record_type
{
    int value;
};

#define LINK_MULTIPLE(a,b,c,d) a##_##b##_##c##_##d
typedef struct _record_type LINK_MULTIPLE(name,company,position,salary);
// 这里这个语句将展开为：
//typedef struct _record_type name_company_position_salary;

int main(void) {
    name_company_position_salary record;
    record.value = 1;

    return 0;
}
