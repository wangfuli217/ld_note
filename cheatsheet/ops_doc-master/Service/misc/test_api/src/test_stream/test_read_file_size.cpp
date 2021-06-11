// obtaining file size
#include <iostream>
#include <fstream>
#include <stdlib.h>
using namespace std;

const char * filename = "test.txt";

int main() {
    long l, m;
    ifstream in(filename, ios::in | ios::binary);
    l = in.tellg();
    in.seekg(0, ios::end);
    m = in.tellg();
    in.close();
    cout << "size of " << filename;
    cout << " is " << (m - l) << " bytes.\n";
    return 0;
}

//½á¹û:
//size of example.txt is 40 bytes.
