#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>

using namespace std;

mutex m1, m2;

void func_2() {
    m2.lock();
    cout << "about to dead_lock" << endl;
    m1.lock();

}

void func_1() {
    m1.lock();

    chrono::milliseconds dura(1000); // delay to trigger dead_lock
    this_thread::sleep_for(dura);

    m2.lock();

}

int main() {

    thread t1(func_1);

    thread t2(func_2);

    t1.join();
    t2.join();
    return 0;

}
