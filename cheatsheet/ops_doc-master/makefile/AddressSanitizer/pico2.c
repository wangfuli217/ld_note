#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sanitizer/asan_interface.h>

typedef struct {
	char title[16];
	char poison[16];
	char username[16];
} song_t;

int main(){
	song_t *song = malloc(sizeof(song_t));

	printf("poisoning: %p\n", song->poison);
	ASAN_POISON_MEMORY_REGION(song->poison,
				  sizeof(song->poison));

	strcpy(song->username, "taro");
	strcpy(song->title, "pen_pineapple___apple_pen");
	printf("username: %s\n", song->username);
	printf("title: %s\n", song->title);

	free(song);
	return 0;
}
