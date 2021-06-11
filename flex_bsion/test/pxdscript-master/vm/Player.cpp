#include "Player.h"
#include "Logger.h"

const int INTVAL_HP = 0;
const int INTVAL_SCORE = 1;
const int INTVAL_LOGMSG = 2;

// Declare the external variable:
Player* Player::theInstance = NULL;

Player::Player() {
  hp = 0;
  score = 0;
}


Player* Player::instance() {
	if (theInstance == NULL)
	  theInstance = new Player();
	  
	return theInstance;
}


void Player::setInt(const string& name, int nr, int value) {
  switch (nr) {
    case INTVAL_HP:
     hp = value;
     printf("hp: %i\n", hp);
     Log("hp: %i", hp);
     break;
    case INTVAL_SCORE:
     score = value;
     printf("score: %i\n", score);
     Log("score: %i", score);
     break;
    case INTVAL_LOGMSG:
     printf("%s\n", name.c_str());
     Log("%s", name.c_str());
     break;
    default:
     Log("ERROR - unknown player intval: %i", nr);
     break;
  }
}
