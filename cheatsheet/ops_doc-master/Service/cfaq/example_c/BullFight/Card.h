#ifndef __CARD_H_
#define __CARD_H_


enum EPukeType
{
    DIAMOND = 1,//钻石
    PLUM, //梅花
    HEARTS,//红桃
    SPADE//黑桃
};

typedef unsigned char BYTE;

//#define BYTE unsgined char

typedef struct tagPukeCard
{
	BYTE value;
	EPukeType type;  
}TPukeCard;


#endif
