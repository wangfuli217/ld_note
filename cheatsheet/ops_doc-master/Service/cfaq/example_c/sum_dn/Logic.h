#ifndef __LOGIC_H_
#define __LOGIC_H_

#include <stdio.h>

#if !defined(NO_NULL)
    #define NO_NULL printf("No Bull.\n")
#endif

extern
void
ShowCalf(size_t calf1, size_t calf2);

extern
bool
IsFiveBull(int* pCard, unsigned short nums);

extern
bool
IsFiveFlowerBull(int* pCard, unsigned short nums);

extern
bool
IsBomb(int* pCard, unsigned short nums);

extern
void
ShowBull(int bull1, int bull2, int bull3);

extern
bool
IsBull(int* pCard, unsigned short nums);





#endif
