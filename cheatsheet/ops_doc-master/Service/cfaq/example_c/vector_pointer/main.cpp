#include <iostream>
#include <vector>
#include <stdio.h>

using namespace std;

void cast_char_poniter() {
    vector<char> temp(10, 'A');

    char* p = &(*temp.begin());

    *p = 'B';

    printf("S: %s\n", p);

}


int main() {

    cast_char_poniter();

    return 0;
}
