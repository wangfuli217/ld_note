#include <stdio.h>
#include <stdlib.h>
#include "dao.h"
#include "debug.h"

int main (void) {
    dao_init ();

    member_info mb = {
        -1,
        "你好!",
        "81dc9bdb52d04dc20036dbd8313ed055",
        "U.S.A",
        "EA",
        "714480119@qq.com",
        "1278382975@qq.com",
        "Laurence ST D.A",
        "2917",
        "Doctor",
        "255.255.255.25",
        "12838283948"
    };

    dao_add_member (&mb);

    dao_deinit ();
    return 0;
}
