#include "exception.h"

#include <stdio.h>
#include <stdlib.h>

void 
throw_exception() throw(my_exception_t)
{
    throw my_exception_t("is my exception.");
}

int main(int argc, char **argv)
{
	try {
        throw_exception();
    } catch (std::exception& e) {
        printf("ERR: %s\n", e.what());
    }
    
    system("pause");
	return 0;
}
