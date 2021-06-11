#include "boa.h"



struct event_entry* event_used = NULL;
struct event_entry* event_unused = NULL;  



static struct event_entry* get_event_entry();
static void dequeue_event(struct event_entry ** head, struct event_entry * req)
{
    if (*head == req)
        *head = req->next;

    if (req->prev)
        req->prev->next = req->next;
    if (req->next)
        req->next->prev = req->prev;

    req->next = NULL;
    req->prev = NULL;
}

static void enqueue_event(struct event_entry ** head, struct event_entry * req)
{
    if (*head)
        (*head)->prev = req;

    req->next = *head;      
    req->prev = NULL;       

    *head = req;            
}





void event_alloc(int fd, fd_set* where){
    int flags = 0;
	struct event_entry* entry;

    if(where == &block_read_fdset)
		flags |= EV_READ;
	else
		flags |= EV_WRITE;
	
	entry = get_event_entry();
	
	event_assign(entry->event, boa_event_base, fd, flags, event_happened, entry);
	event_add(entry->event, NULL);
}


void event_happened(evutil_socket_t fd, short what, void *arg)
{
	struct event_entry* entry = (struct event_entry*) arg;

	if (fd > max_fd) max_fd = fd; 
	if (what & EV_READ)
		FD_SET(fd, &block_read_fdset);
	else
		FD_SET(fd, &block_write_fdset);

	dequeue_event(&event_used, entry);
	enqueue_event(&event_unused, entry);

	event_del(entry->event); 
}


static struct event_entry* get_event_entry()
{
	struct event_entry* t;
	if(event_unused){
		t = event_unused;
		dequeue_event(&event_unused, t);
		enqueue_event(&event_used, t);
	}else{
		t = (struct event_entry*)malloc(sizeof(struct event_entry));
		t->prev = NULL;
		t->next = NULL;
		t->event = (struct event*)malloc(sizeof(struct event));
		enqueue_event(&event_used, t);
	}
	return t;
}


