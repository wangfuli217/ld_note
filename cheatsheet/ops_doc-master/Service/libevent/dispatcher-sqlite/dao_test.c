#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include "dao.h"
#include "unit.h"

void rand_str (char *buf, int len) {
    assert (buf);
    int i, flag;
    srand ((unsigned) time (NULL));

    for (i = 0; i < len - 1; i++) {
        flag = rand () % 3;
        switch (flag) {
        case 0:
            buf[i] = 'A' + rand () % 26;
            break;
        case 1:
            buf[i] = 'a' + rand () % 26;
            break;
        case 2:
            buf[i] = '0' + rand () % 10;
            break;
        default:
            buf[i] = 'x';
            break;
        }
    }
    buf[len - 1] = '\0';
}

char *dao_add_member_tests () {
    dao_init ();
    char buf[16];
    member_info mb = {
        -1,
        "hello,world!",
        "81dc9bdb52d04dc20036dbd8313ed055",
        "U.S.A",
        "EA",
        "71423823382@qq.com",
        "12483438@qq.com",
        "Laurence ST D.A",
        "2974",
        "Doctor",
        "255.255.255.255",
        "183293283828"
    };
    rand_str (buf, 16);
    strcpy (mb.username, buf);
    dao_add_member (&mb);
    dao_deinit ();
    return NULL;
}

char *dao_login_tests () {
    dao_init ();
    char username[] = "27VnB140tu7U4b0";
    char password[] = "81dc9bdb52d04dc20036dbd8313ed055";
    char ipaddr[] = "182.168.1.219";

    if (dao_login (username, password, ipaddr) < 0) {
        return "login test fail!";
    }
    dao_deinit ();
    return NULL;
}

char *dao_logout_tests () {
    dao_init ();
    char username[] = "27VnB140tu7U4b0";
    char ipaddr[] = "";

    dao_logout (username, ipaddr);
    dao_deinit ();
    return NULL;
}

char *dao_get_friends_test () {
    dao_init ();
    char username[] = "27VnB140tu7U4b0";
    friend_list **list = NULL;
    int i, sz = 0;

    dao_get_friends (username, &list, &sz);
    if (sz > 0) {
        printf ("total friend num: %d\n", sz);

        for (i = 0; i < sz; i++) {
            printf ("\tThe 1th: name=%s, ip=%s\n", list[i]->username_a, list[i]->ipaddr);
        }
    }
    dao_free_friends_result (list, sz);
    list = NULL;

    dao_deinit ();
    return NULL;
}

char *dao_get_onemb_tests () {
    dao_init ();
    member_info member;
    dao_get_onemb ("27VnB140tu7U4b0", &member);

    ph_debug ("%d", member.memberid);
    ph_debug ("%s", member.username);
    ph_debug ("%s", member.password);
    ph_debug ("%s", member.address1);
    ph_debug ("%s", member.address2);
    ph_debug ("%s", member.email1);
    ph_debug ("%s", member.email2);
    ph_debug ("%s", member.city);
    ph_debug ("%s", member.pin);
    ph_debug ("%s", member.profession);
    ph_debug ("%s", member.ipaddr);
    ph_debug ("%s", member.phone1);

    dao_deinit ();
    return NULL;
}

char *dao_delete_member_tests () {
    dao_init ();
    if (dao_delete_member ("27VnB140tu7U4b0") < 0) {
        return "delete member test fail!";
    }

    dao_deinit ();
    return NULL;
}

char *all_tests () {
    ph_suite_start ();
    ph_run_test (dao_add_member_tests);
    ph_run_test (dao_login_tests);
    ph_run_test (dao_logout_tests);
    ph_run_test (dao_get_friends_test);
    ph_run_test (dao_get_onemb_tests);
    ph_run_test (dao_delete_member_tests);

    return NULL;
}

PH_RUN_TESTS (all_tests);
