#include <stdio.h>
#include <string.h>

int LEN = 4;
char *songs[] = {
        "as long as you love me",
        "my love",
        "no project",
        "in the world"
    };

int search_love(char *song){
    return strstr(song, "love") ? 1 : 0;
}

int search_world(char *song){
    return strstr(song, "world") ? 1 : 0;
}

/* ����ָ�룬������Ϊ�������ݸ�find */
void find(int (*match)(char*)) {
    int i;
    puts("Search results:");
    puts("----------------------------");
    for (i = 0; i < LEN; i++) {
        if (match(songs[i])) {
            printf("%s \n", songs[i]);
        }
    }
    puts("----------------------------");
}

int main(int argc, char **argv){
    find(search_world); /* ��������ָ�룬search_world��ָ�� */
}