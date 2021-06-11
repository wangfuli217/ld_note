#include <stdio.h>
#include <stdlib.h>
#include "atom.h"
#include "getword.h"
#include "table.h"
#include "mem.h"

// wordÆðÊ¼
int start(int c)
{
	return isalpha(c);
}

//wordÄÚÈÝ
int rest(int c)
{
	return isalpha(c);
}

void keyFree(const void *key, void **value)
{
	FREE(*value);
}

int compare(const void *x, const void *y)
{
	return strcmp(*(char **)x, *(char **)y);
}


int main(void)
{
	FILE *fp = fopen("main.c","r");
	char buf[512] = {0};
	void **array;
	int i;
	
	Table table = Table_new(1111,NULL,NULL);

	if (table == NULL)
	{

		printf("heheh\n");
		return;
	}
	while(getword(fp,buf,sizeof buf,start,rest))
	{
		char *word;
		int *count;
		

		word = (char *)Atom_string(buf);
		count = Table_get(table,word);
		if(count)
			(*count)++;
		else
		{
			NEW(count);
			*count = 1;
			Table_put(table,word,count);
		}
	}
	array = Table_toArray(table,NULL);
	//qsort(array,Table_length(table),2 * sizeof(*array),compare);

	for(i = 0; array[i]; i += 2)
	{
		printf("%d\t%s\n",*(int *)(array[i+1]),(char *)array[i]);
	}
	FREE(array);

	Table_map(table,keyFree);
	Table_free(&table);




	fclose(fp);
	return 0;
}


