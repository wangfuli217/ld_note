
#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

#include "mmq.h"
#include "stdio.h"



void sleep(int ms) {
#ifdef WIN32
    Sleep(ms);
#else
    usleep(ms*1000);
#endif
}


int main(int argc, char* argv[]) {
    //In this example we create 4 peers
    // 1 host peer, 1 sending peer and 2 receiving peers
    mmq_peer host, sender, receiver1, receiver2;

    
    host = mmq_peer_create();
    sender = mmq_peer_create();
    receiver1 = mmq_peer_create();
    receiver2 = mmq_peer_create();

    mmq_peer_connect(host, "tcp://127.0.0.1:8888", MMQ_PEER_FLAG_HOST);
    mmq_peer_connect(receiver1, "tcp://127.0.0.1:8888", 0);
    mmq_peer_connect(receiver2, "tcp://127.0.0.1:8888", 0);
    mmq_peer_connect(sender, "tcp://127.0.0.1:8888", 0);

    //subscribe receivers to topic "foo"
    mmq_peer_subscribe(receiver1, "foo");
    mmq_peer_subscribe(receiver2, "foo");

    

    //wait for the host and receiver peer connection to establish
    while (mmq_peer_get_status(receiver1) != MMQ_PEER_STATUS_CONNECTED
        || mmq_peer_get_status(receiver2) != MMQ_PEER_STATUS_CONNECTED) {
        mmq_peer_run(host);
        mmq_peer_run(receiver1);
        mmq_peer_run(receiver2);
        printf("connecting...\n");
        sleep(100);
        
    }

    printf("connected\n");

    //connect the sender and publish a message to the "foo" topic
    
    mmq_msg msg1 = mmq_msg_create("hello world!", 26);
    mmq_peer_publish(sender, "foo", msg1);

    int message_count = 0;
    while (message_count <= 1) {

        //message loop
        mmq_msg msg = mmq_peer_get_msg(receiver1);
        while (msg) {
            message_count++;
            printf("receiver1 got message: %s\n", mmq_msg_get_data(msg));
            mmq_msg_close(&msg);
            msg = mmq_peer_get_msg(receiver1);
        }
        msg = mmq_peer_get_msg(receiver2);
        while (msg) {
            message_count++;
            printf("receiver2 got message: %s\n", mmq_msg_get_data(msg));
            mmq_msg_close(&msg);
            msg = mmq_peer_get_msg(receiver2);
        }

        mmq_peer_run(host); 
        mmq_peer_run(sender); 
        mmq_peer_run(receiver1);
        mmq_peer_run(receiver2);
        sleep(100);
        printf("loop...\n");
    }

    //cleanup and close peer connections
    mmq_peer_close(&host);
    mmq_peer_close(&sender);
    mmq_peer_close(&receiver1);
    mmq_peer_close(&receiver2);
    return 0;
}