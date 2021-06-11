#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int age;
	int sex;
} people_s;

typedef struct {
	people_s m;
	char tag[2];
} people_tag_s;


#define free_peole(p) \
	if (p) {
		strcpy(p->tag, "YY");
		
		free(p);
	}


static void
__malloc_tag()
{
	people_tag_s* tag = malloc(10 * sizeof(*tag));
	
	if (tag) {
		for ( int i = 0; i < 10; i++) {
			people_s* p = (people_s*)(tag + i);
			
			p->age = i;
			p->sex = 1;
			
			strcpy((tag + i)->tag, "BY");
			
			printf("age: %d sex: %d tag: %s size: %d\n", p->age, p->sex, (tag + i)->tag, strlen((tag + i)->tag));
		}
		
		
	}
	
}

int 
main(int argc, char **argv)
{
	__malloc_tag();
	
	system("pause");
	return 0;
	
}
