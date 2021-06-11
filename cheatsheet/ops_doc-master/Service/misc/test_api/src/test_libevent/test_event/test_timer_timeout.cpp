#include <iostream>
#include <event.h>
#include <ctime>

using namespace std;

void cb(evutil_socket_t fd, short what, void *arg) {
    cout << "event ocurrence every 2 seconds." << endl;
}

int main() {
    timeval two_sec = { 2, 0 };
    event_base *base = event_base_new();
    event *timeout = event_new(base, -1, EV_TIMEOUT, cb, NULL);
    event_add(timeout, &two_sec);
    event_base_dispatch(base);
    return 0;
}
