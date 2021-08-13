# MMQ

MMQ is a simple asyncronous message queue implementation written
on top of [libuv](https://github.com/joyent/libuv).

The main design goal is to have a very simple C interface need to
pass messages between peers on the network. We use the pub-sub 
pattern for broadcasting messages to the network. However any 
peer on the network can be both a publisher and subscriber.

Also topic filtering is done by the host peers that brokers 
messages to other peers. Host peers listen on a socket where
normal peers may connect to. Both host and normal peers can send
and recieve messages.

Example Peer Network
-----------------

    #include "mmq.h"
    #include "stdio.h"


    int main() {
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

        //subscribe receivers to topic "foo"
        mmq_peer_subscribe(receiver1, "foo");
        mmq_peer_subscribe(receiver2, "foo");

        //wait for the host and receiver peer connection to establish
        while (mmq_peer_get_status(receiver1) != MMQ_PEER_STATUS_CONNECTED
            || mmq_peer_get_status(receiver2) != MMQ_PEER_STATUS_CONNECTED) {
            mmq_peer_run(host);
            mmq_peer_run(receiver1);
            mmq_peer_run(receiver2);
            Sleep(16);
        }

        //connect the sender and publish a message to the "foo" topic
        mmq_peer_connect(sender, "tcp://127.0.0.1:8888", 0);
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
            Sleep(16);
        }

        //cleanup and close peer connections
        mmq_peer_close(&host);
        mmq_peer_close(&sender);
        mmq_peer_close(&receiver1);
        mmq_peer_close(&receiver2);
        return 0;
    }
        
Compile Instructions
--------------------

This project is configured to use cmake to build shared libraries.


    git submodule update --init
    mkdir build
    cd build
    cmake .
    cmake --build .

