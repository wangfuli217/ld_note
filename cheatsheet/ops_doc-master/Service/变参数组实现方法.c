struct name {
	int namelen;
	char namestr[1];
};
struct name *ret = malloc(sizeof(struct name)-1 + strlen(newname)+1);
//或者
#define MAXSIZE 100
struct name {
	int namelen;
	char namestr[MAXSIZE];
};
struct name *ret = malloc(sizeof(struct name)-MAXSIZE+strlen(newname)+1);
//或者
struct name {
	int namelen;
	char *namep;
};
struct name *ret = malloc(sizeof(struct name));
ret->namelen = strlen(newname);
ret->namep = malloc(ret->namelen + 1);
//或者
char *buf = malloc(sizeof(struct name) + strlen(newname) + 1);
struct name *ret = (struct name *)buf;
ret->namelen = strlen(newname);
ret->namep = buf + sizeof(struct name);
strcpy(ret->namep, newname);