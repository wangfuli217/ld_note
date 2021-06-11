// Simple hello world demo
//
// Only prints build and revision number to cout.
//

#include "app-lib/appVersion.h"

#include <iostream>
using namespace std;

int main()
{
    cout << "Hello world!" << endl;

    cout << "Build tag: " << AppVersion::build() << endl;
    cout << "Git Repository Id: " << AppVersion::revision() << endl;

    return 0;
}
