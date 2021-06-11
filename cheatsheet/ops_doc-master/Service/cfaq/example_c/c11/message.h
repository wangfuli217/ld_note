#ifndef __MESSAGE_H_
#define __MESSAGE_H_

#include <map>

using namespace std;

typedef struct message_s message_t;
struct message_s {
	unsigned short cmd;
};

typedef map<unsigned short, message_t*> message_map_t;
typedef message_map_t::iterator 		message_map_itr_t;

extern message_map_t* messages;

extern int
message_init(message_map_t** mm);

extern message_t*
message_find(message_map_t* m, unsigned short cmd);

#endif