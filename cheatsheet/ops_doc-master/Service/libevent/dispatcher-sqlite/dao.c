#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "sqlite3.h"
#include "dao.h"
#include "debug.h"

#undef  S
#undef  STR
#define S(s)   #s
#define STR(s) S(s)

static sqlite3 *db = NULL;
static char *file = "./s.db";   /* if empty, default to temp db */

void dao_init () {
    sqlite3_initialize ();

    int rc = 0;
    rc = sqlite3_open_v2 (file, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);

    if (rc != SQLITE_OK) {
        sqlite3_close (db);
        fprintf (stderr, "error open db\n");
        exit (-1);
    }
}

void dao_deinit () {
    sqlite3_close (db);
    sqlite3_shutdown ();
}

int dao_login (const char *username, const char *password, const char *ipaddr) {
    sqlite3_stmt *stmt = NULL;
    int rc = 0;
    int idx = -1;
    int id;

    char *sql = "select memberid from tbl_member where \
    username=:username and password=:password limit 1";

    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }
# undef SQLBIND
# define SQLBIND(param) \
  idx = sqlite3_bind_parameter_index(stmt, ":" STR(param)); \
  sqlite3_bind_text(stmt, idx, param, -1, SQLITE_STATIC)

    SQLBIND (username);
    SQLBIND (password);

    while (sqlite3_step (stmt) == SQLITE_ROW) {
        id = sqlite3_column_int (stmt, 0);
        break;
    }

    sqlite3_finalize (stmt);
    stmt = NULL;
    sql = "update tbl_member set ipaddr=:ipaddr where username=:username";

    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    SQLBIND (ipaddr);
    SQLBIND (username);

    rc = sqlite3_step (stmt);
    if (rc != SQLITE_DONE && rc != SQLITE_ROW) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }
    if (id < 0) {
        return 1;
    }

    sqlite3_finalize (stmt);
    stmt = NULL;

    return 0;
}

int dao_logout (const char *username, const char *ip) {
    sqlite3_stmt *stmt = NULL;
    int rc = 0, idx = -1;
    char *sql = "update tbl_member set ipaddr=:ip where username=:u";

    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    idx = sqlite3_bind_parameter_index (stmt, ":ip");
    sqlite3_bind_text (stmt, idx, ip, -1, SQLITE_STATIC);

    idx = sqlite3_bind_parameter_index (stmt, ":u");
    sqlite3_bind_text (stmt, idx, username, -1, SQLITE_STATIC);

    if ((sqlite3_step (stmt) != SQLITE_DONE)) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    sqlite3_finalize (stmt);
    stmt = NULL;

    return 0;
}

int dao_add_member (member_info * member) {
    sqlite3_stmt *stmt = NULL;
    int rc = 0, idx = -1;
    char *sql = "insert into tbl_member ("
        "username,"
        "password,"
        "address1,"
        "address2,"
        "email1,"
        "email2,"
        "city," "pin," "profession," "ipaddr," "phone1) values(" ":username," ":password," ":address1," ":address2," ":email1," ":email2," ":city," ":pin," ":profession," ":ipaddr," ":phone1" ")";

    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }
# undef SQLBIND
# define SQLBIND(param) \
  idx = sqlite3_bind_parameter_index(stmt, ":" STR(param));\
  sqlite3_bind_text(stmt, idx, member->param, -1, SQLITE_STATIC)

    SQLBIND (username);
    SQLBIND (password);
    SQLBIND (address1);
    SQLBIND (address2);
    SQLBIND (email1);
    SQLBIND (email2);
    SQLBIND (city);
    SQLBIND (pin);
    SQLBIND (profession);
    SQLBIND (ipaddr);
    SQLBIND (phone1);

    rc = sqlite3_step (stmt);
    if (rc != SQLITE_DONE && rc != SQLITE_ROW) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    sqlite3_finalize (stmt);
    stmt = NULL;

    return 0;
}

int dao_get_onemb (const char *username, member_info * member) {
    assert (member != NULL);
    memset (member, 0, sizeof (*member));

    sqlite3_stmt *stmt = NULL;
    int rc = 0, idx = -1;
    char *sql = "select memberid," "username," "password," "address1," "address2," "email1," "email2," "city," "pin," "profession," "ipaddr," "phone1 from tbl_member where username=:u limit 1";

    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    idx = sqlite3_bind_parameter_index (stmt, ":u");
    sqlite3_bind_text (stmt, idx, username, -1, SQLITE_STATIC);

    if ((rc = sqlite3_step (stmt)) != SQLITE_ROW) {
        if (rc != SQLITE_DONE) {
            ph_debug ("%s\n", sqlite3_errmsg (db));
        }
        return -1;
    }

    const char *buf = NULL;
    int buf_len = 0;

    member->memberid = sqlite3_column_int (stmt, 0);

# undef EXTRA_TEXT
# define EXTRA_TEXT(field, pos) \
  buf = (const char*)sqlite3_column_text(stmt, pos); \
  buf_len = sqlite3_column_bytes(stmt, pos); \
  memcpy(member->field, buf, buf_len)

    EXTRA_TEXT (username, 1);
    EXTRA_TEXT (password, 2);
    EXTRA_TEXT (address1, 3);
    EXTRA_TEXT (address2, 4);
    EXTRA_TEXT (email1, 5);
    EXTRA_TEXT (email2, 6);
    EXTRA_TEXT (city, 7);
    EXTRA_TEXT (pin, 8);
    EXTRA_TEXT (profession, 9);
    EXTRA_TEXT (ipaddr, 10);
    EXTRA_TEXT (phone1, 11);

    sqlite3_finalize (stmt);
    stmt = NULL;

    return 0;
}

int dao_delete_member (const char *username) {
    sqlite3_stmt *stmt = NULL;
    int rc = 0, idx = -1;
    char *sql = "delete from tbl_member where username=:u";

    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    idx = sqlite3_bind_parameter_index (stmt, ":u");
    sqlite3_bind_text (stmt, idx, username, -1, SQLITE_STATIC);

    rc = sqlite3_step (stmt);
    if (rc != SQLITE_ROW && rc != SQLITE_DONE) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }
    return 0;
}

int dao_add_friend (friend_info * friend) {
    sqlite3_stmt *stmt = NULL;
    int rc = 0, idx = -1;
    char *sql = "insert into tbl_friend(memberid, friendid) values(:mid, :fid)";

    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    idx = sqlite3_bind_parameter_index (stmt, ":mid");
    sqlite3_bind_int (stmt, idx, friend->memberid);

    idx = sqlite3_bind_parameter_index (stmt, ":fid");
    sqlite3_bind_int (stmt, idx, friend->friendid);

    rc = sqlite3_step (stmt);
    if (rc != SQLITE_DONE && rc != SQLITE_ROW) {
        return -1;
    }

    sqlite3_finalize (stmt);
    stmt = NULL;

    return 0;
}

int dao_delete_contact (const char *username, const char *friendname) {
    sqlite3_stmt *stmt = NULL;
    int rc = 0, idx = -1;
    member_info member;
    member_info friend;

    dao_get_onemb (username, &member);
    dao_get_onemb (friendname, &friend);

    char *sql = "delete tbl_friend where memberid where memberid=:mid and friendid=:fid";
    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    idx = sqlite3_bind_parameter_index (stmt, ":mid");
    sqlite3_bind_int (stmt, idx, member.memberid);

    idx = sqlite3_bind_parameter_index (stmt, ":fid");
    sqlite3_bind_int (stmt, idx, friend.memberid);

    if ((rc != sqlite3_step (stmt)) != SQLITE_ROW) {
        if (rc != SQLITE_DONE) {
            ph_debug ("%s\n", sqlite3_errmsg (db));
        }
        return -1;
    }

    sqlite3_finalize (stmt);
    stmt = NULL;

    return 0;
}

int dao_get_friends (const char *username, friend_list *** list, int *sz) {
    sqlite3_stmt *stmt = NULL;
    int rc = 0, idx = -1, n = 20, i = 0, buf_len = 0;
    const char *buf = NULL;

    char *sql = "select username_a, ipaddr from tbl_friend_list \
    where username=:u";

    friend_list **mylist = malloc (n * sizeof (*mylist));
    if (mylist == NULL) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    rc = sqlite3_prepare_v2 (db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        ph_debug ("%s\n", sqlite3_errmsg (db));
        return -1;
    }

    idx = sqlite3_bind_parameter_index (stmt, ":u");
    sqlite3_bind_text (stmt, idx, username, -1, SQLITE_STATIC);

    friend_list *item = NULL, *pi = NULL;
    while (sqlite3_step (stmt) == SQLITE_ROW) {
        item = malloc (sizeof (*item));
        if (item == NULL) {
            free (pi);
            return -1;
        }

        memset (item, 0, sizeof (*item));

        buf = (const char *) sqlite3_column_text (stmt, 0);
        buf_len = sqlite3_column_bytes (stmt, 0);
        memcpy (item->username_a, buf, buf_len);

        buf = (const char *) sqlite3_column_text (stmt, 1);
        buf_len = sqlite3_column_bytes (stmt, 1);
        memcpy (item->ipaddr, buf, buf_len);

        mylist[i++] = item;
        pi = item;

        if (i > n) {
            n = (n << 1);
            friend_list **nmylist = realloc (mylist, n);
            if (nmylist == NULL) {
                return -1;
            }
            mylist = nmylist;
        }
    }

    if (i > 0) {
        *sz = i;
        *list = mylist;
    } else {
        free (mylist);
        *list = NULL;
    }

    sqlite3_finalize (stmt);
    stmt = NULL;

    return 0;
}

void dao_free_friends_result (friend_list ** list, int sz) {
    if (list) {
        int i;
        for (i = 0; i < sz; i++) {
            if (list[i]) {
                free (list[i]);
            }
        }
        free (list);
    }
}
