#include <stdio.h>
#include "common.h"
#include "func_a.h"
#include "func_b.h"

int main(void)
{
    printf("%s\n", __FILE__);

    func_a();

    func_b();

    return 0;
}
