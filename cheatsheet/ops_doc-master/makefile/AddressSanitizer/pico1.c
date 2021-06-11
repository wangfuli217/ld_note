#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct {
	char title[16];
	char username[16];
} song_t;

int main(){
	song_t *song = malloc(sizeof(song_t));

	strcpy(song->username, "taro");
	strcpy(song->title, "pen_pineapple___apple_pen");

	printf("title: %s\n", song->title);
	printf("username: %s\n", song->username);

	free(song);
	return 0;
}
