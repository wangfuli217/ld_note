#include <string.h>

static const char* status_code_strings[] = {
    "Address not found",      //0
    "Connection dropped",     //1
    "Connection timed out",   //2
};

const char* get_status_code_string(const unsigned int status_code) 
{
    return status_code_strings[status_code];
}

unsigned int string_to_status_code(const char* const status_code_string) 
{
    unsigned int i;
    for (i = 0; i < sizeof(status_code_strings) /
                    sizeof(status_code_strings[0]); i++) 
	{
        if (strcmp(status_code_strings[i], status_code_string) == 0)
		{
            return i;
        }
    }
    return ~0U; //unsigned int型,0按位取反是-1;
}
