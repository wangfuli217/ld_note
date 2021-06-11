#ifndef __LOGIC_H_
#define __LOGIC_H_

#include "Card.h"


/***********************************************
 * 功能：对用户的牌进行排序
 * 参数：
 * 		【pCard】	用户牌数组
 * 		【nums】	常量 牌数量
 ***********************************************/
extern
void
SortCard(TPukeCard* pCard, const BYTE nums);

extern
void
ShowCalf(const TPukeCard& pcalf1, const TPukeCard& pcalf2);

extern
bool
IsFiveCalfBull(const TPukeCard* pCard, const BYTE nums);

extern
bool
IsFiveFlowerBull(const TPukeCard* pCard, const BYTE nums);

extern
bool
IsBomb(const TPukeCard* pCard, const BYTE nums);

extern
void
ShowBull(const TPukeCard& pBull1, const TPukeCard& pBull2, const TPukeCard& pBull3);

/***********************************************
 * 功能：给用户发牌
 * 参数：
 * 		【pCard】	用户牌数组
 * 		【nums】	常量 牌数量
 ***********************************************/
extern
void
DealCard(TPukeCard* pCard, const BYTE nums, const BYTE seatid, const TPukeCard* pTableCards);

extern
void
shuffle(const TPukeCard* pCardLists, const BYTE nums, TPukeCard* pTableCards);


/***********************************************
 * 功能：判断用户手中牌是否有牛
 * 参数：
 * 		【pCard】	用户牌数组
 * 		【nums】	常量 牌数量
 * 		【pBull】	判断斗牛结果牌数组
 * 返回：
 * 		true:	有牛
 * 		false:	无牛
 ***********************************************/
extern
bool
IsBull(TPukeCard* pCard, const BYTE nums, TPukeCard* pBull);


#endif
