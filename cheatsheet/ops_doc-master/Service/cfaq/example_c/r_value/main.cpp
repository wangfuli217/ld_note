#include <iostream>

using namespace std;  
  
string modifiable_rvalue() {  
    return "cute";  
}  
  
const string const_rvalue() {  
    return "fluffy";  
}  
  
int main() {  
    string modifiable_lvalue("kittens");  
    const string const_lvalue("hungry hungry zombies");  
  
    string& a = modifiable_lvalue;          // Line 16  
    string& b = const_lvalue;               // Line 17 - ERROR  
    string& c = modifiable_rvalue();        // Line 18 - ERROR  
    string& d = const_rvalue();             // Line 19 - ERROR  
  
    const string& e = modifiable_lvalue;    // Line 21  
    const string& f = const_lvalue;         // Line 22  
    const string& g = modifiable_rvalue();  // Line 23  
    const string& h = const_rvalue();       // Line 24  
  
    string&& i = modifiable_lvalue;         // Line 26 - ERROR  
    string&& j = const_lvalue;              // Line 27 - ERROR  
    string&& k = modifiable_rvalue();       // Line 28  
    string&& l = const_rvalue();            // Line 29 - ERROR  
  
    const string&& m = modifiable_lvalue;   // Line 31 - ERROR  
    const string&& n = const_lvalue;        // Line 32 - ERROR  
    const string&& o = modifiable_rvalue(); // Line 33  
    const string&& p = const_rvalue();      // Line 34  
}  