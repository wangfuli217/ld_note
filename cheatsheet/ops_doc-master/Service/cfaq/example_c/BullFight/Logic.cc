#include "Logic.h"
#include "Card.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if !defined(NO_BULL)
	#define NO_BULL printf("No Bull.\n")
#endif


static inline
unsigned int
Rand(const unsigned int min, const unsigned int max)
{
	unsigned int result = 0;
	
	result = min + rand() % max;
	
	return result;
}

static
void
SwapCard(TPukeCard& a, TPukeCard& b)
{
	TPukeCard temp = {0};
	
	temp = a;
	a = b;
	b = temp;
}


static
void
SwapCard(TPukeCard* a, TPukeCard* b)
{
	TPukeCard temp(*a);
	//TPukeCard temp = {0};

	temp = *a;
	*a = *b;
	*b = temp;
	
	#if 0
	temp.value = a->value;
	temp.type = a->type;
	
	a->value = b->value;
	a->type = b->type;
	
	b->value = temp.value;
	b->type = temp.type;
	#endif
}

void
SortCard(TPukeCard* pCard, const BYTE nums)
{
	for(int i = 0; i < nums; i++)
	{
		for (int j = 0 ; j < nums - 1; j++)
		{
			if ((pCard + j)->value > (pCard + j + 1)->value)
			{
				//SwapCard(*(pCard + j), *(pCard + j + 1));
				SwapCard(pCard + j, pCard + j + 1);
			}
			
			//根据花色进行排序
			if (((pCard + j)->value == (pCard + j + 1)->value) && ((pCard + j)->type > (pCard + j + 1)->type))
			{
				SwapCard(*(pCard + j), *(pCard + j + 1));
			}	
		
		}
	}
}


void
ShowBull(const TPukeCard& pBull1, const TPukeCard& pBull2, const TPukeCard& pBull3)
{
	printf("Bull: ");

	printf("%d#%d ", pBull1.value, pBull1.type);
	printf("%d#%d  ", pBull2.value, pBull2.type);
	printf("%d#%d  ", pBull3.value, pBull3.type);
				
	printf("\n");
}

void
ShowCalf(const TPukeCard& pcalf1, const TPukeCard& pcalf2)
{
	BYTE calf1, calf2;
	
	calf1 = pcalf1.value >= 10 ? 10 : pcalf1.value;
	calf2 = pcalf2.value >= 10 ? 10 : pcalf2.value;
	
	size_t sum = (calf1 + calf2) % 10 ?  (calf1 + calf2) % 10 : 10;
	
	printf("Calf: ");
	
	printf("%d#%d ", pcalf1.value, pcalf1.type);
	printf("%d#%d ", pcalf2.value, pcalf2.type);
	
	printf("%d ", sum);
	
	printf("\n");
}

bool
IsBull(TPukeCard* pCard, const BYTE nums, TPukeCard* pBull)
{
#if 1

	TPukeCard ge10[5] = {0};//大于9的
	TPukeCard gt10[5] = {0};//小于10的
	
	int ge10_index = 0;
	int gt10_index = 0;
    
    // 判断当前用户的牌的情况，区分大于9的牌	
	for(unsigned short i = 0; i < nums; i++)
	{
		if ((pCard + i)->value > 9)
		{
			ge10[ge10_index++] = *(pCard + i);
		}
		else
		{
			gt10[gt10_index++] = *(pCard + i);
		}
	}
	
	//对两个数组进行排序
	if (ge10_index)
		SortCard(ge10, ge10_index);
	
	if (gt10_index)
		SortCard(gt10, gt10_index);
	//排序结束
	
	//如果都是大于9的牌，直接匹配斗牛
	if (gt10_index == 0)
    {
        ShowBull(ge10[0], ge10[1], ge10[2]);

        ShowCalf(ge10[3], ge10[4]);
		
		return true; 
    }


    if(gt10_index == 1)
    {
        ShowBull(ge10[0], ge10[1], ge10[2]);

        ShowCalf(gt10[0], ge10[3]);

        return true;
    }


    if(gt10_index == 2) //有三张 大于9 的牌
	{
	    ShowBull(ge10[0], ge10[1], ge10[2]);

        ShowCalf(gt10[0], gt10[1]);

        return true;
	}
	
	if(gt10_index == 3)
	{
		int sum = gt10[0].value + gt10[1].value + gt10[2].value;
		
		if ((sum % 10) == 0 )
		{
			ShowBull(gt10[0], gt10[1], gt10[2]);
			
            ShowCalf(ge10[0], ge10[1]);

			return true;
		}
		else
		{
			if((gt10[0].value + gt10[1].value) == 10)
			{
                ShowBull(gt10[0], gt10[1], ge10[0]);
                
                ShowCalf(gt10[2], ge10[1]);

				return true;
			}
			
			if((gt10[0].value + gt10[2].value) == 10)
			{
                ShowBull(gt10[0], gt10[2], ge10[0]);

                ShowCalf(gt10[1], ge10[1]);
				
                return true;
			}
			
			if((gt10[1].value + gt10[2].value) == 10)
			{
                ShowBull(gt10[1], gt10[2], ge10[0]);

                ShowCalf(gt10[0], ge10[1]);

				return true;
			}
			
		}
	}
	
	
	if(gt10_index == 4) // 有四张小于10的情况
	{
		int sum = gt10[0].value + gt10[1].value + gt10[2].value + gt10[3].value;
		
		if ( sum == 10 ) // no bull
		{
			NO_BULL;

            return true;
		}
		else
		{
            if ( (sum - gt10[0].value) % 10 == 0)
            {
                ShowBull(gt10[1], gt10[2], gt10[3]);

                ShowCalf(gt10[0], ge10[0]);

				return true;
		    }
            
            if ( (sum - gt10[1].value) % 10 == 0)
            {
                ShowBull(gt10[0], gt10[2], gt10[3]);

                ShowCalf(gt10[1], ge10[0]);

                return true;
            }

            if ( (sum - gt10[2].value) % 10 == 0)
            {
                ShowBull(gt10[0], gt10[1], gt10[3]);
				ShowCalf(gt10[2], ge10[0]);

				return true;
            }

            if ( (sum - gt10[3].value) % 10 == 0)
            {
                ShowBull(gt10[0], gt10[1], gt10[2]);

                ShowCalf(gt10[3], ge10[0]);

                return true;
            } 

            //判断两张牌组合的情况
            if ( (gt10[0].value + gt10[1].value) == 10)
            {
			    ShowBull(gt10[0], gt10[1], ge10[0]);

                ShowCalf(gt10[2], gt10[3]);

				return true;
            }

            if ((gt10[0].value + gt10[2].value) == 10)
            {
                ShowBull(gt10[0], gt10[2], ge10[0]); 

                ShowCalf(gt10[1], gt10[3]);

                return true;
            }

            if ((gt10[0].value + gt10[3].value) == 10)
            {
                ShowBull(gt10[0], gt10[3], ge10[0]);

                return true;
            }

            if ((gt10[1].value + gt10[2].value) == 10)
            {
                ShowBull(gt10[1], gt10[2], ge10[0]);

                ShowCalf(gt10[0], gt10[3]);

                return true;
            }

            if ((gt10[1].value + gt10[3].value) == 10)
            {
                ShowBull(gt10[1], gt10[3], ge10[0]);
                
                ShowCalf(gt10[0], gt10[2]);

                return true;
            }

            if((gt10[2].value + gt10[3].value) == 10)
            {
                ShowBull(gt10[2], gt10[3], ge10[0]);
                
                ShowCalf(gt10[0], gt10[1]); 

                return true;
            }
			
			NO_BULL;
			
			return false;

		}
	}

    if ( gt10_index == 5)
    {
       if ( (gt10[0].value + gt10[1].value + gt10[2].value) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[1], gt10[2]);

           ShowCalf(gt10[3], gt10[4]);

           return true;
       }

       if ( (gt10[0].value + gt10[1].value + gt10[3].value) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[1], gt10[3]);

           ShowCalf(gt10[2], gt10[4]);

           return true;
       }

       if ( (gt10[0].value + gt10[1].value + gt10[4].value) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[1], gt10[4]);

           ShowCalf(gt10[2], gt10[3]);

           return true;
       }
       
       if ( (gt10[0].value+ gt10[2].value + gt10[3].value) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[2], gt10[3]);

           ShowCalf(gt10[1], gt10[4]);

           return true;
       }

       if ( (gt10[0].value + gt10[2].value + gt10[4].value) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[2], gt10[4]);

           ShowCalf(gt10[1], gt10[3]);

           return true;
       }
       if ( (gt10[0].value + gt10[3].value + gt10[4].value) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[3], gt10[4]);

           ShowCalf(gt10[1], gt10[2]);

           return true;
       }
       if ( (gt10[1].value + gt10[2].value + gt10[3].value) % 10 == 0)
       {
           ShowBull(gt10[1], gt10[2], gt10[3]);

           ShowCalf(gt10[0], gt10[4]);

           return true;
       }
       if ( (gt10[1].value + gt10[2].value + gt10[4].value) % 10 == 0)
       {
           ShowBull(gt10[1], gt10[2], gt10[4]);

           ShowCalf(gt10[0], gt10[3]);

           return true;
       }
       if ( (gt10[1].value + gt10[3].value + gt10[4].value) % 10 == 0)
       {
           ShowBull(gt10[1], gt10[3], gt10[4]);

           ShowCalf(gt10[0], gt10[2]);

           return true;
       }
	   
	   if ( (gt10[2].value + gt10[3].value + gt10[4].value) % 10 == 0)
       {
           ShowBull(gt10[2], gt10[3], gt10[4]);

           ShowCalf(gt10[0], gt10[1]);

           return true;
       }
    }
	
	#if 0
	printf("ge10_index: %d\n", ge10_index);
	printf("gt10_index: %d\n", gt10_index);
	#endif 
	
	NO_BULL;
	
	return false;
#endif
}

bool
IsFiveFlowerBull(const TPukeCard* pCard, const BYTE nums)
{
	return pCard->value > 10 ? true : false;
}

bool
IsFiveCalfBull(const TPukeCard* pCard, const BYTE nums)
{
	if ((pCard + nums - 1)->value > 5)
	{
		return false;
	}
	else 
	{
		BYTE sum = 0;
		
		for(BYTE i = 0; i < nums; i++)
		{
			sum += (pCard + i)->value;
			
			if (sum > 10) 
				return false;
		}
		
		return true;
	}
}

bool
IsBomb(const TPukeCard* pCard, const BYTE nums)
{
	if ((pCard)->value == (pCard + 3)->value)
	{
		return true;
	}
	
	if ((pCard + nums - 1)->value == (pCard + 1)->value)
	{
		return true;
	}
	
	return false;
}

void
shuffle(const TPukeCard* pCardLists, const BYTE nums, TPukeCard* pTableCards)
{
	unsigned short iRand = 0;
	BYTE iCount = 0;
	
	bool IsFound = false;
	
	TPukeCard tempCards[nums];
	
	memcpy(tempCards, pCardLists, sizeof(tempCards));
	
	#if 1
	for(unsigned short i = 0; i < 52; i++)
	{
		//iRand = Rand(0, 51);
		
		iRand = rand() % (nums - 1);
		
		if (pTableCards[iRand].value == 0)
		{
			pTableCards[iRand] = pCardLists[i];
			
			IsFound = true;
		}
		else
		{
			#if 0
			while()
			{
				//iRand = Rand(0, 51);
				iRand = rand() % (nums - 1);
			}
			
			pTableCards[iRand] = pCardLists[i];
			#endif
			
			for(unsigned short j = 0; j < 3; j++)
			{
				iRand = rand() % (nums - 1);
				
				if (!pTableCards[iRand].value)
				{
					pTableCards[iRand] = pCardLists[i];
					IsFound = true;
					break;
				}
				
				IsFound = false;
			}
			
			if(IsFound)
			{
				continue;
			}
			
			if (i % 2 == 0)
			{
				for(unsigned short j = nums - 1 ; j >= 0; j--)
				{
					if(pTableCards[j].value == 0)
					{
						pTableCards[j] = pCardLists[i];
						IsFound = true;
						break;
					}
				}
			}
			else
			{
				for(unsigned short j = 0; j < nums; j++)
				{
					if(pTableCards[j].value == 0)
					{
						pTableCards[j] = pCardLists[i];
						IsFound = true;
						break;
					}
				}
			}
			
			
		}
	}
	#endif
	
	#if 0
	
	do
	{
		iRand = rand() % (nums - iCount);
		pTableCards[iCount++] = tempCards[iRand];
		tempCards[iRand] = tempCards[nums - iCount];
	}while(iCount < nums);
	
	#endif
}

void
DealCard(TPukeCard* pCard, const BYTE nums, const BYTE seatid, const TPukeCard* pTableCards)
{
	BYTE pos = (seatid - 1) * 5;
	
	for (BYTE i = 0; i < nums; i++)
	{
		*(pCard + i) = pTableCards[pos++];
	}
}
