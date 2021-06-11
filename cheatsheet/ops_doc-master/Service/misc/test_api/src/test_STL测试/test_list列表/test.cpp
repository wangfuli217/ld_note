#include <iostream>
#include <vector>
#include <list>

using namespace std;

int main() {
    list<int> a1;
    for (int i = 0; i < 6; i++)
    {
        a1.push_back(i);
    }

    for (list<int>::iterator it = a1.begin(); it != a1.end(); it++) {
        cout << *it << "\t";
    }
    cout << endl;

    for (list<int>::reverse_iterator it = a1.rbegin(); it != a1.rend(); it++) {
        cout << *it << "\t";
    }
    cout << endl;

//    for (list<int>::reverse_iterator it = a1.rbegin(); it != a1.rend(); it++) {
//        //倒数第二个进入该操作
//        if ( it != a1.rbegin())
//        {
//            it --;
//            list<int>::iterator it2(it.base());
//            a1.insert(it2, 9);
//            break;
//        }
//    }

    int times = 0;
    for (list<int>::reverse_iterator it = a1.rbegin(); it != a1.rend(); it++,times++) {
        cout << *it << "\t";
        //倒数第二个进入该操作
        if ( 4 == times)
        {
            cout << endl;
            cout <<"it = " <<  *it << endl;
            it --;
            cout <<"it -- = " <<  *it << endl;
            list<int>::iterator it2(it.base());
            cout <<"it2(it.base()) = " <<  *it2 << endl;
            a1.insert(it2, 9);
            break;
        }
    }
    cout << endl;

//    int times = 0;
//    for (list<int>::iterator it = a1.begin(); it != a1.end(); it++,times++) {
//        cout << *it << "\t";
//        //倒数第二个进入该操作
//        if ( 2 == times)
//        {
//            a1.insert(it, 9);
//            break;
//        }
//    }
//    cout << endl;

    for (list<int>::iterator it = a1.begin(); it != a1.end(); it++) {
        cout << *it << "\t";
    }
    cout << endl;

}
