#ifndef MMQ_H
#define MMQ_H


/*
    mmq_msg - MMQ Message Handle
    A mmq_msg is a pointer to an allocated message block which the
    memory size allocated varies based on the size of the message.

*/
typedef void* mmq_msg;


/*
    mmq_peer - MMQ Connection Peer Handle
    A mmq_peer is a container for handling a connection state.
    A mmq_peer can act as either a host or a client.
    A host listens for incomming peer connections and maintains
    the network between them as well as routes messages to
    other peers on the network.
    A client peer connects to a host peer to become a member
    of the network.

    Both client and host peers can send and recieve messages from
    the network.

*/
typedef void* mmq_peer;




#define MMQ_MSG_HEADER_SIGNATURE 0x3047534d
#define MMQ_MSG_TYPE_MESSAGE 0
#define MMQ_MSG_TYPE_COMMAND 1
#define MMQ_MSG_TOPIC_MAX_SIZE 48
#define MMQ_MSG_CLIENT_ID_MAX_SIZE 16

#define MMQ_PEER_BUFFER_INIT_SIZE 4096
#define MMQ_PEER_TYPE_TCP 1
#define MMQ_PEER_STATUS_CLOSED 0
#define MMQ_PEER_STATUS_DISCONNECTED 1
#define MMQ_PEER_STATUS_CONNECTED 2
#define MMQ_PEER_STATUS_LISTENING 3
#define MMQ_PEER_ID_MAX_SIZE 16
#define MMQ_PEER_FLAG_CLIENT   1<<1
#define MMQ_PEER_FLAG_HOST   1<<0




#ifdef __cplusplus
extern "C" {
#endif

#define MMQ_EXTERN 
#ifdef _WIN32
#define MMQ_EXTERN __declspec(dllexport)
#endif

/*

    Allocates an initializes a new message handle pre-allocated with a specified size.
    If data is not NULL, the contents of data will be copied into the newly allocated
    message up to the size
    If size is 0, the message will be initialized as an empty message and data will be
    ignored

    Returns NULL if unable to allocate memory for the message.
*/
MMQ_EXTERN mmq_msg mmq_msg_create(const char* data, unsigned int size);

/*
    Allocates a new copy of the specified message.
    Returns NULL if unable to allocate memory for the message.
*/

MMQ_EXTERN mmq_msg mmq_msg_copy(mmq_msg msg);

/*
    Resize an existing message. The old message body will be copied
    over to the reallocated message.

    Returns 0 on success
    Returns -1 if unable to resize the message to the desired size.
*/
MMQ_EXTERN int mmq_msg_set_size(mmq_msg* msg, unsigned int size);

/*
    Returns the size of the specified message
*/
MMQ_EXTERN unsigned int mmq_msg_get_size(mmq_msg msg);

/*
    Returns the message data contents
*/
MMQ_EXTERN char* mmq_msg_get_data(mmq_msg msg);

/*
    Copies the contents of data into the message.
    The message size will be resized to accomodate the 
    size specified.

    Returns 0 on success
    Returns -1 if unable to allocate memory for the message
*/
MMQ_EXTERN int mmq_msg_set_data(mmq_msg* msg, const char* data, unsigned int size);

/*
    Returns the topic header for a message as a null-terminated c-string.
*/
MMQ_EXTERN const char* mmq_msg_get_topic(mmq_msg msg);

/*
    Set the topic header for a message.
    topic should be a null-terminated string of a size < MMQ_MSG_TOPIC_MAX_SIZE
    Returns -1 if the topic size 
*/
MMQ_EXTERN int mmq_msg_set_topic(mmq_msg msg, const char* topic, unsigned int size);

/*
    Deallocates the given message and sets the handle to NULL

*/
MMQ_EXTERN void mmq_msg_close(mmq_msg* msg);

/*
    Create an instance of a new peer. Initially the peer will
    have no behavior until mmq_peer_connect is called.

    On success, returns a mmq_peer handle.
    On error, returns NULL if unable to allocate the new peer

*/
MMQ_EXTERN mmq_peer mmq_peer_create();

/* 
    Establishes a network connection for a peer given a connection string.

    connection_str should be in the form: <protocol>://<ip_address>:<port>
        The currently supported protocols are: tcp
        Domain names resolution is not supported for ip_address
    
    flags should be set to 0 if the peer is acting as a client
    otherwise set flags to MMQ_PEER_FLAG_HOST to act as server

    Both client and server peers can publish and recieve messages

*/
MMQ_EXTERN int mmq_peer_connect(mmq_peer peer, const char* connection_str, int flags);

/*
    Get the ID for a peer. Peer IDs are randomly when first generated and should be unique on
    the network.

*/
MMQ_EXTERN const char* mmq_peer_get_id(mmq_peer peer);

/* 
    This will set the peer ID. This should be done prior to connecting.

*/
MMQ_EXTERN void mmq_peer_set_id(mmq_peer peer, const char* id);

/*
    Publish a message to the network.

    The topic should be a null terminated ascii c string
    be no longer than MMQ_MSG_TOPIC_MAX_SIZE - 1

    All other peers subscribed to the topic will recieve
    the message. 
    
    Peers will not recieve messages they sent themselves.
    
*/
MMQ_EXTERN int mmq_peer_publish(mmq_peer peer, const char* topic, mmq_msg msg);

/*
    Subscribe a peer to a topic.

    The topic should be a null terminated ascii c string
    be no longer than MMQ_MSG_TOPIC_MAX_SIZE - 1

    A peer will only recieve messages published to topics
    they are subscribed to.

    After publishing a message, ownership of the message is
    transferred over the to the peer. It will automatically
    be freed after successfully sending it over the network.

    The message will remain in queue to be sent until the
    network is available and be requeued on error.


*/
MMQ_EXTERN int mmq_peer_subscribe(mmq_peer peer, const char* topic);

/* 
    Unsubscribe a peer from a topic

    The topic should be a null terminated ascii c string
    be no longer than MMQ_MSG_TOPIC_MAX_SIZE - 1

    After unsubscribing, the peer should no longer recieve
    messages posted to the topic

    If the topic was not previously subscribed, it will be ignored.

*/
MMQ_EXTERN int mmq_peer_unsubscribe(mmq_peer peer, const char* topic);

/*
    Get a messages from a the peer.

    Returns NULL if no messages otherwise returns a mmq_msg handle.

    After subscribing, messages will begin to queue up and it is the
    responsibility of the user to get these messages. There is no
    limit to the amount of messages that can queue up but
    the system may run out of memory.

    After getting the message, the message is removed from the peer
    and the ownership is transered over to the caller.
    The user is responsbile calling mmq_msg_close to free
    the memory from the message when finished.
*/
    
MMQ_EXTERN mmq_msg* mmq_peer_get_msg(mmq_peer peer);

/* 
    Returns the current status of a peer.
    
    MMQ_PEER_STATUS_CLOSED - Peer has been closed or has not been initialized
    MMQ_PEER_STATUS_DISCONNECTED - Peer has been initialized but is not currently connected
    MMQ_PEER_STATUS_CONNECTED - Peer has been connected to a host peer
    MMQ_PEER_STATUS_LISTENING - A host peer has been bound to a socket and is currently listening
    
*/

int mmq_peer_get_status(mmq_peer peer);


/* 
    Run an iteration of the asyncronous event loop
    to handle processing any pending network requests.
    Messages will not be recieved or published until
    this is executed at least once.

*/

MMQ_EXTERN int mmq_peer_run(mmq_peer peer);

/*
    Release the peer's memory resources and close any network
    connections currently open on the peer.
    Any messages queued will be also released.
*/
MMQ_EXTERN void mmq_peer_close(mmq_peer* peer);


#ifdef __cplusplus
}
#endif

#endif
