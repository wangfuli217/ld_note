#ifndef __DAO_H__
#define __DAO_H__

#define USERNAME_LEN 50
#define PASSWORD_LEN 32
#define ADDRESS1_LEN 128
#define ADDRESS2_LEN 128
#define EMAIL1_LEN 80
#define EMAIL2_LEN 80
#define CITY_LEN 80
#define PIN_LEN 80
#define PROFESSION_LEN 60
#define IPADDR_LEN 15
#define PHONE1_LEN 30
#define USERNAME_A_LEN 50

typedef struct {
    int memberid;
    char username[USERNAME_LEN + 1];
    char password[PASSWORD_LEN + 1];
    char address1[ADDRESS1_LEN + 1];
    char address2[ADDRESS2_LEN + 1];
    char email1[EMAIL1_LEN + 1];
    char email2[EMAIL2_LEN + 1];
    char city[CITY_LEN + 1];
    char pin[PIN_LEN + 1];
    char profession[PROFESSION_LEN + 1];
    char ipaddr[IPADDR_LEN + 1];
    char phone1[PHONE1_LEN + 1];
} member_info;

typedef struct {
    int memberid;
    int friendid;
} friend_info;

typedef struct {
    char username_a[50];
    char ipaddr[15];
} friend_list;

void dao_init ();
void dao_deinit ();

int dao_add_member (member_info * member);
int dao_add_friend (friend_info * friend);
int dao_get_members (member_info ** member, int limit);
int dao_get_friends (const char *username, friend_list *** list, int *sz);
void dao_free_friends_result (friend_list ** list, int sz);

#endif
