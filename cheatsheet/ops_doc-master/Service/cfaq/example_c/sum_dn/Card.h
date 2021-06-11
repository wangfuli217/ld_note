#ifndef __CARD_H_
#define __CARD_H_

#include "DataType.h"

enum EPukeType
{
    DIAMOND = 1,
    PLUM,
    HEARTS,
    SPADE
};

typedef struct tagTPukeCard
{
    BYTE value;
    EPukeType type;
}TPukeCard;


#endif
