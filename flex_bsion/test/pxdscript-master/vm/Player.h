#ifndef PLAYER_H
#define PLAYER_H
#include <string>

using namespace std;


// A dummy implementation of a player class. The important thing in this 
// context is that it has a 'setInt' function that I'll use to demonstrate
// pxdscript.

// Under the assumption that there is only one player I've made this class
// follow the singleton pattern. For those unfamiliar with this pattern it
// simply means that the class has a private constructor and to get access
// to the (single) instance one must call the static 'instance' function. This
// is a way to ensure that there will only be one instance of this class in the
// program.
class Player {
 private:
  Player();
      
  // the instance for the singleton pattern 
  static Player *theInstance;

  // Lets add a few integers that we can manipulate from the script 
  int hp;   
  int score; 
 public: 
  static Player* instance();
  
  void setInt(const string& name, int nr, int value);
};

#endif
