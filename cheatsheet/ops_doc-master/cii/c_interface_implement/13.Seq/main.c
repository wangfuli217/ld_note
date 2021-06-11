#include <stdio.h>
#include <stdlib.h>
#include "seq.h"

void apply(void *x)
{
	printf("%s\n",x);
}

int main(void)
{	
	Seq seq = Seq_seq("c++","c#","js","java");
	char *q;
	
//	q = Seq_get(seq,0);
	Seq_addhi(seq,"sbbb");
	Seq_addlo(seq,"ssss");
	
	Seq_map(seq,apply);
//	printf("%s\n",q); 
	return 0;	
} 
