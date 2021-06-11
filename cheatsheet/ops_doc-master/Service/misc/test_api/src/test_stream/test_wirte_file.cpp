// writing on a text file
#include <fiostream>
using namespace std;
int main() {
    ofstream out("out.txt");
    if (out.is_open()) {
        out << "This is a line.\n";
        out << "This is another line.\n";
        out.close();
    }
    return 0;
}
//结果: 在out.txt中写入：
//This is a line.
//This is another line
