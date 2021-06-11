#include <stdio.h>
#include <stdlib.h>

typedef struct{
    int len;
    int data[0];
} ARR;

ARR *create_array(int len){
    ARR *arr = malloc(sizeof(int) * (len + 1));
    arr->len = len;
    return arr;
}

int main(void){
    ARR *arr = create_array(10);
    int i;
    for(i = 0; i < arr->len; i++)
        arr->data[i] = i * 2;
    printf("%d\n", arr->data[5]);
    free(arr);
    return 0;
}

#if 0
#include <stdlib.h>
#include <string.h>

struct name *makename(char *newname)
{
	struct name *ret =
		malloc(sizeof(struct name)-1 + strlen(newname)+1);
				/* -1 for initial [1]; +1 for \0 */
	if(ret != NULL) {
		ret->namelen = strlen(newname);
		strcpy(ret->namestr, newname);
	}

	return ret;
}
#endif

#if 0
#include <stdlib.h>
#include <string.h>

#define MAXSIZE 100

struct name {
	int namelen;
	char namestr[MAXSIZE];
};

struct name *makename(char *newname)
{
	struct name *ret =
		malloc(sizeof(struct name)-MAXSIZE+strlen(newname)+1);
								/* +1 for \0 */
	if(ret != NULL) {
		ret->namelen = strlen(newname);
		strcpy(ret->namestr, newname);
	}

	return ret;
}
#endif

#if 0
#include <stdlib.h>
#include <string.h>

struct name {
	int namelen;
	char *namep;
};

struct name *makename(char *newname)
{
	struct name *ret = malloc(sizeof(struct name));
	if(ret != NULL) {
		ret->namelen = strlen(newname);
		ret->namep = malloc(ret->namelen + 1);
		if(ret->namep == NULL) {
			free(ret);
			return NULL;
		}
		strcpy(ret->namep, newname);
	}

	return ret;
}

#endif

#if 0
struct name *makename(char *newname)
{
	char *buf = malloc(sizeof(struct name) +
				strlen(newname) + 1);
	struct name *ret = (struct name *)buf;
	ret->namelen = strlen(newname);
	ret->namep = buf + sizeof(struct name);
	strcpy(ret->namep, newname);

	return ret;
}
#endif