#include "message.h"

message_map_t* messages = NULL;

int
message_init(message_map_t** mm)
{
	*mm = new message_map_t;
	
	return *mm == NULL ? -1 : 0;
}

message_t*
message_find(message_map_t* m, unsigned short cmd)
{
	message_map_itr_t itr = m->find(cmd);
	
	if (itr != m->end()) {
		return itr->second;
	}
	
	return NULL;
}