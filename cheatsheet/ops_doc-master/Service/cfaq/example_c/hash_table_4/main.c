#include <stdio.h>
#include <stdlib.h>
#include "uthash.h"

typedef struct people_s people_t;
struct people_s {
	unsigned int 	id;
	char 			name[10];
	UT_hash_handle	hh;
};

#define new_people malloc(sizeof(people_t));
#define print_people(p) printf("id: %u, name: %s\n", p->id, p->name)

int main(int argc, char **argv)
{
	people_t* users = NULL;
	people_t* p = new_people;
	
	if (p) {
		p->id = 1;
		strcpy(p->name, "chenbo");
		
		HASH_ADD_INT(users, id, p);
	}
	
	people_t* itr = NULL;
	unsigned int id = 1;
	HASH_FIND_INT(users, &id, itr);
	
	print_people(itr);
	
	system("pause");
 	
	return 0;
}
