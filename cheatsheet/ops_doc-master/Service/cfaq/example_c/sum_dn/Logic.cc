#include "Logic.h"
#include "Card.h"

#if !defined(NO_BULL)
	#define NO_BULL printf("No Bull.\n")
#endif

void
ShowCalf(size_t calf1, size_t calf2)
{
    calf1 = calf1 >= 10 ? 10 : calf1;
    calf2 = calf2 >= 10 ? 10 : calf2;

    int sum = (calf1 + calf2) % 10 ? (calf1 + calf2) % 10 : 10;
    
    printf("Calf: %d\n", sum);
}

bool
IsFiveFlowerBull(int* pCard, unsigned short nums)
{
    if ( *(pCard + nums - 1) < 5)
    {
        int sum = 0;

        for ( unsigned short i = 0; i < nums; i++)
        {
            sum += *(pCard + i);

            if (sum > 10)
                return 0;
        }

        return 1;
    }
    else
    {
        return 0;
    }
}

bool
IsFiveBull(int* pCard, unsigned short nums)
{
    if ( *(pCard) < 11)
    {
        return false;
    }
    else
    {
        return true;
    }
}

bool
IsBomb(int* pCard, unsigned short nums)
{
    if (*pCard == *(pCard + 3)) // 第一张与第四张相同
    {
        return true;
    }

    if (*(pCard + 4) == *(pCard + 1)) //最后一张与第二张相同
    {
        return true;
    }

    return false;
}

void
ShowBull(int bull1, int bull2, int bull3)
{
    printf("Bull: ");

	printf("%d ", bull1);
	printf("%d ", bull2);
	printf("%d ", bull3);
				
	printf("\n");
}


bool
IsBull(int* pCard, unsigned short nums)
{
	int ge10[5] = {0};
	int gt10[5] = {0};
	
	int ge10_index = 0;
	int gt10_index = 0;
    
    // 判断当前用户的牌的情况，区分大于9的牌	
	for(unsigned short i = 0; i < nums; i++)
	{
		if (*(pCard + i) > 9)
		{
			ge10[ge10_index++] = *(pCard + i);
		}
		else
		{
			gt10[gt10_index++] = *(pCard + i);
		}
	}
	
	if (gt10_index == 0)
    {
        ShowBull(ge10[0], ge10[1], ge10[2]);

        ShowCalf(ge10[3], gt10[4]);
    }


    if(gt10_index == 1)
    {
        ShowBull(ge10[0], ge10[1], ge10[2]);

        ShowCalf(gt10[0], gt10[3]);

        return 0;
    }


    if(gt10_index == 2) //有三张 大于9 的牌
	{
	    ShowBull(ge10[0], ge10[1], ge10[2]);

        ShowCalf(gt10[0], gt10[1]);

        return 0;
	}
	
	if(gt10_index == 3)
	{
		int sum = gt10[0] + gt10[1] + gt10[2];
		
		if ((sum % 10) == 0 )
		{
			ShowBull(gt10[0], gt10[1], gt10[2]);
			
            ShowCalf(ge10[0], ge10[1]);

			return 0;
		}
		else
		{
			if((gt10[0] + gt10[1]) == 10)
			{
                ShowBull(gt10[0], gt10[1], ge10[0]);
                
                ShowCalf(gt10[2], ge10[1]);

				return 0;
			}
			
			if((gt10[0] + gt10[2]) == 10)
			{
                ShowBull(gt10[0], gt10[2], ge10[0]);

                ShowCalf(gt10[1], ge10[1]);
				
                return 0;
			}
			
			if((gt10[1] + gt10[2]) == 10)
			{
                ShowBull(gt10[1], gt10[2], ge10[0]);

                ShowCalf(gt10[0], ge10[1]);

				return 0;
			}
			
		}
	}
	
	
	if(gt10_index == 4) // 有四张小于10的情况
	{
		int sum = gt10[0] + gt10[1] + gt10[2] + gt10[3];
		
		if ( sum == 10 ) // no bull
		{
			NO_BULL;

            return 0;
		}
		else
		{
            if ( (sum - gt10[0]) % 10 == 0)
            {
                ShowBull(gt10[1], gt10[2], gt10[3]);

                ShowCalf(gt10[0], ge10[0]);

				return 0;
		    }
            
            if ( (sum - gt10[1]) % 10 == 0)
            {
                ShowBull(gt10[0], gt10[2], gt10[3]);

                ShowCalf(gt10[1], ge10[0]);

                return 0;
            }

            if ( (sum - gt10[2]) % 10 == 0)
            {
                ShowBull(gt10[0], gt10[1], gt10[3]);

				return 0;
            }

            if ( (sum - gt10[3]) % 10 == 0)
            {
                ShowBull(gt10[0], gt10[1], gt10[2]);

                ShowCalf(gt10[3], ge10[0]);

                return 0;
            } 

            //判断两张牌组合的情况
            if ( (gt10[0] + gt10[1]) == 10)
            {
			    ShowBull(gt10[0], gt10[1], ge10[0]);

                ShowCalf(gt10[2], gt10[3]);

				return 0;
            }

            if ((gt10[0] + gt10[2]) == 10)
            {
                ShowBull(gt10[0], gt10[2], ge10[0]); 

                ShowCalf(gt10[1], gt10[3]);

                return 0;
            }

            if ((gt10[0] + gt10[3]) == 10)
            {
                ShowBull(gt10[0], gt10[3], ge10[0]);

                return 0;
            }

            if ((gt10[1] + gt10[2]) == 10)
            {
                ShowBull(gt10[1], gt10[2], ge10[0]);

                ShowCalf(gt10[0], gt10[3]);

                return 0;
            }

            if ((gt10[1] + gt10[3]) == 10)
            {
                ShowBull(gt10[1], gt10[3], ge10[0]);
                
                ShowCalf(gt10[0], gt10[2]);

                return 0;
            }

            if((gt10[2] + gt10[3]) == 10)
            {
                ShowBull(gt10[2], gt10[3], ge10[0]);
                
                ShowCalf(gt10[0], gt10[1]); 

                return 0;
            }

		}
	}

    if ( gt10_index == 5)
    {
       if ( (gt10[0] + gt10[1] + gt10[2]) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[1], gt10[2]);

           ShowCalf(gt10[3], gt10[4]);

           return 0;
       }

       if ( (gt10[0] + gt10[1] + gt10[3]) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[1], gt10[3]);

           ShowCalf(gt10[2], gt10[4]);

           return 0;
       }

       if ( (gt10[0] + gt10[1] + gt10[4]) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[1], gt10[4]);

           ShowCalf(gt10[2], gt10[3]);

           return 0;
       }
       
       if ( (gt10[0] + gt10[2] + gt10[3]) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[2], gt10[3]);

           ShowCalf(gt10[1], gt10[4]);

           return 0;
       }

       if ( (gt10[0] + gt10[2] + gt10[4]) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[2], gt10[4]);

           ShowCalf(gt10[1], gt10[3]);

           return 0;
       }
       if ( (gt10[0] + gt10[3] + gt10[4]) % 10 == 0)
       {
           ShowBull(gt10[0], gt10[3], gt10[4]);

           ShowCalf(gt10[1], gt10[2]);

           return 0;
       }
       if ( (gt10[1] + gt10[2] + gt10[3]) % 10 == 0)
       {
           ShowBull(gt10[1], gt10[2], gt10[3]);

           ShowCalf(gt10[0], gt10[4]);

           return 0;
       }
       if ( (gt10[1] + gt10[2] + gt10[4]) % 10 == 0)
       {
           ShowBull(gt10[1], gt10[2], gt10[4]);

           ShowCalf(gt10[0], gt10[3]);

           return 0;
       }
       if ( (gt10[1] + gt10[3] + gt10[4]) % 10 == 0)
       {
           ShowBull(gt10[1], gt10[3], gt10[4]);

           ShowCalf(gt10[0], gt10[2]);

           return 0;
       }
	   
	   if ( (gt10[2] + gt10[3] + gt10[4]) % 10 == 0)
       {
           ShowBull(gt10[2], gt10[3], gt10[4]);

           ShowCalf(gt10[0], gt10[1]);

           return 0;
       }
    }
	
	printf("ge10_index: %d\n", ge10_index);
	printf("gt10_index: %d\n", gt10_index);
}
