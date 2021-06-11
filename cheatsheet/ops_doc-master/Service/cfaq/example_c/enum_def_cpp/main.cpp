#include <stdio.h>

enum Color {
	RED,
	BLUE
};

enum class Sex {
	MALE,
	FEMALE
};

//enum class Age : char;

//enum Age : unsigned char { SHAONIAN, ZHONGNIAN, LAONIAN};

int main(int argc, char **argv)
{
	if (RED == 0) {
		printf("is red.\n");
	}

//	if (Sex::MALE == 0) {
//		printf("is male.\n");
//	}
	
	Sex me = Sex::MALE;
	
	if (Sex::MALE == me) {
		printf("is male.\n");
	}
	
	return 0;
}
