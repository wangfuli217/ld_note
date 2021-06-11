#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Logic.h"
#include "Card.h"

const unsigned short USER_CARD_NUMS = 5;

const TPukeCard CardList[52] = {
	{1, DIAMOND}, {2, DIAMOND}, {3, DIAMOND}, {4, DIAMOND}, {5, DIAMOND}, {6, DIAMOND}, {7, DIAMOND}, {8, DIAMOND}, 
	{9, DIAMOND}, {10, DIAMOND},  {11, DIAMOND},  {12, DIAMOND},  {13, DIAMOND}, 
	{1, PLUM}, {2, PLUM}, {3, PLUM}, {4, PLUM}, {5, PLUM},  {6, PLUM}, {7, PLUM}, {8, PLUM}, {9, PLUM},  
	{10, PLUM},  {11, PLUM},  {12, PLUM},  {13, PLUM}, 
	{1, HEARTS}, {2, HEARTS}, {3, HEARTS}, {4, HEARTS}, {5, HEARTS}, {6, HEARTS}, {7, HEARTS}, {8, HEARTS}, {9, HEARTS},
	{10, HEARTS}, {11, HEARTS},  {12, HEARTS},  {13, HEARTS}, 
	{1, SPADE}, {2, SPADE}, {3, SPADE}, {4, SPADE}, {5, SPADE}, {6, SPADE}, {7, SPADE}, {8, SPADE}, {9, SPADE},  
	{10, SPADE},  {11, SPADE},  {12, SPADE},  {13, SPADE}
	};

static TPukeCard TableCards[52] = {0};

static
void
ClearnTableCards(TPukeCard* pTableCards, const BYTE nums)
{
	for (BYTE i = 0; i < nums; i++)
	{
		memset(pTableCards + i, 0, sizeof(TPukeCard));
	}
}


static inline 
void
ShowCards(TPukeCard* pCard, const BYTE nums)
{
	printf("Cards: ");
	
	for(unsigned short i = 0; i < nums; i++)
	{
		printf("%d#%d ", (pCard + i)->value, (pCard + i)->type);
	}
	
	printf("\n");
}


int 
main(int argc, char **argv)
{
	TPukeCard cards[USER_CARD_NUMS] = {{10, DIAMOND}, {8, SPADE}, {8, PLUM}, {5, HEARTS}, {1, DIAMOND}};
	
	//TPukeCard cards[USER_CARD_NUMS] = {{10, (EPukeType)1}, {10, (EPukeType)4}, {10, (EPukeType)2}, {10, (EPukeType)3}, {1, (EPukeType)4}};
	
	//SortCard(cards, USER_CARD_NUMS);
	
	//ShowCards(cards, USER_CARD_NUMS);
	
	shuffle(CardList, 52, TableCards);
	
	ShowCards(TableCards, 52);
	
	for(BYTE i = 0; i < 6; i++)
	{
		DealCard(cards, USER_CARD_NUMS, i + 1, TableCards);
		
		SortCard(cards, USER_CARD_NUMS);
		
		ShowCards(cards, USER_CARD_NUMS);
		
		if (IsFiveFlowerBull(cards, USER_CARD_NUMS))
		{
			printf("IsFiveFlowerBull.\n");
			continue;
		}
		
		if (IsBull(cards, USER_CARD_NUMS, NULL))
		{
		}
	}
	
	ClearnTableCards(TableCards, 52);
	
	shuffle(CardList, 52, TableCards);
	
	ShowCards(TableCards, 52);
	
	for(BYTE i = 0; i < 6; i++)
	{
		DealCard(cards, USER_CARD_NUMS, i + 1, TableCards);
		
		SortCard(cards, USER_CARD_NUMS);
		
		ShowCards(cards, USER_CARD_NUMS);
		
		if (IsFiveFlowerBull(cards, USER_CARD_NUMS))
		{
			printf("IsFiveFlowerBull.\n");
			continue;
		}
		
		if (IsBull(cards, USER_CARD_NUMS, NULL))
		{
		}
	}
	
	/*
	if (IsBull(cards, USER_CARD_NUMS, NULL))
	{
		system("pause");
		
		return 0;
	}
	*/
	system("pause");
	
	return 0;
}

