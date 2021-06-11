#include <stdio.h>
#include <stdlib.h>

enum {
	OUT_CARD_TIMER = 0x201,
	START_PLAY_CARD_TIMER = 0x203,
	WAIT_AI_TIMER,
	KICK_USER_TIMER,
	WRITE_DB_MENOY,
	START_NEXT_GAME_TIMER,
	WAIT_MATCH_OVER_TIMER,
	PRIVATE_ROOM_TIMER,
	ROOM_HOST_LEAVE_TIMER,
	TABLE_EXCHANG_CARD_TIMER,
	ROBOT_TIMER,
	ROBOT_OUT_CARD_TIMER,
};

int main(int argc, char **argv)
{
	printf("%x\n", TABLE_EXCHANG_CARD_TIMER);
	
	system("pause");
	
	return 0;
}
