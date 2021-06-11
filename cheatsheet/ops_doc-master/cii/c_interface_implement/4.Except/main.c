#include <stdlib.h>
#include <stdio.h>
#include <setjmp.h>

#include "except.h"

Except_T failed = {"edit failed."};
Except_T failed1 = {"add failed."};

void edit(void);
void add(void);

int main(int argc,char *argv[])
{	

//	TRY
//		TRY
//			add();
//		CATCH(failed1)
//			fprintf(stderr,"couldn't add.\n");
//			break;
//		FINALLY
//			;
//		END_TRY;
//		
//		edit();
//		
//	CATCH(failed)
//		fprintf(stderr,"couldn't edit.\n");
//		break;
//	CATCH(failed1)
//		fprintf(stderr,"couldn't add.\n");
//		break;
//	FINALLY
//		;
//	END_TRY;
	add();
	
	return 0;
}

void edit(void)
{
	THROW(failed);
}
void add(void)
{
	THROW(failed1);
}

