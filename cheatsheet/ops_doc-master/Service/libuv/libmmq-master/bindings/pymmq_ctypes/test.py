import mmq
import time

host = mmq.Peer()
host.connect("tcp://127.0.0.1:8888")
host.subscribe("foo")

peer = mmq.Peer()
peer.connect("tcp://127.0.0.1:8888")
peer.subscribe("foo")

peer2 = mmq.Peer()
peer2.connect("tcp://127.0.0.1:8888")
peer2.subscribe("foo")

count = 0
i = 0
while 1:
    for msg in host.get_messages():
        #assert(msg == "hello world!\0")
        print "host", msg
        count += 1
    for msg in peer.get_messages():
        #assert(msg == "hello world!\0")
        print "peer", msg
        count += 1
    for msg in peer2.get_messages():
        #assert(msg == "hello world!\0")
        print "peer2", msg
        count += 1
    peer.publish("foo", "hello world!\0")
    host.publish("foo", "hello world!\0")
    time.sleep(1)
    i += 1
    
assert(count == 4)