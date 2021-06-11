#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "list.h"

typedef struct wd_maps{
	int wd;
	char *dir_name;
	char *file_name;
	struct hlist_node h_node;
}wd_maps_s;

#define WD_MAPS_SIZE (sizeof(wd_maps_s))
//#define HASH_NUM 	0xFF
#define HASH_NUM 	0x0F
#define MALLOC malloc

static struct hlist_head wd_tables[HASH_NUM] = {{0}};

static unsigned int hash_fun(unsigned int wd)
{
	return wd & HASH_NUM;
}

int add_wd(int wd, const char *dir_name, const char *file_name)
{
	wd_maps_s *pos = MALLOC(WD_MAPS_SIZE);
	memset(pos, 0, WD_MAPS_SIZE);


	pos->wd = wd;

	if(dir_name != NULL){
		pos->dir_name = malloc(strlen(dir_name + 1));
		strcpy(pos->dir_name, dir_name);
	}

	if(file_name != NULL){

		pos->file_name = malloc(strlen(file_name + 1));
		strcpy(pos->file_name, file_name);
	}
	
	hlist_add_head(&pos->h_node, &wd_tables[hash_fun(wd)]);
}

int test()
{
	int n = 20;
	int i = 0;
	
	// add
	for(; i < n; i++){
		char buf[1024] = {0};
		sprintf(buf, "filename = %d_.txt", i);
		add_wd(i, buf, NULL);
	}


	printf("***********************************add**********************************************************\n");
	//list 
	for(i = 0; i < HASH_NUM; i++){
		struct hlist_node *pos = NULL;
		wd_maps_s *tpos = NULL;
		hlist_for_each_entry( tpos, pos, &wd_tables[i], h_node){
			printf("%d = %s\n", tpos->wd, tpos->dir_name);
		}
	}

	// del
	for(i = 0; i < HASH_NUM; i++){

		struct hlist_node *pos, *n = NULL;

		hlist_for_each_safe(pos, n, &wd_tables[i]){
				__hlist_del(pos);
				/*注意，这里没做释放，只是在链表中删除罢了*/
		}
	}

	printf("***********************************del**********************************************************\n");

	//list 
	for(i = 0; i < HASH_NUM; i++){
		struct hlist_node *pos = NULL;
		wd_maps_s *tpos = NULL;
		hlist_for_each_entry( tpos, pos, &wd_tables[i], h_node){
			printf("%d = %s\n", tpos->wd, tpos->dir_name);
		}
	}

	printf("***********************************end**********************************************************\n");
}

int main()
{
	test();

	return 0;

}