#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const unsigned short BYTESIZE = 8;

const unsigned int SortNumber[] = {3,5,2,10,6,12,8,14,9,16,22,35}; 

void SetBit(char* p, int number)
{
	unsigned int posit = number / BYTESIZE;
	
	printf("%u %d.\n", posit, *(p + posit));

	
	*(p + posit) = *(p + posit) | 0x1 << (number % BYTESIZE);
	
	//printf("%d.\n", *(p + posit));
}

void SortBitMap()
{
	unsigned int SortNumberArrayLen = (sizeof SortNumber) / 4;
	
	unsigned int SortBufferLen = SortNumberArrayLen % BYTESIZE == 0 ? 
		SortNumberArrayLen / BYTESIZE : SortNumberArrayLen / BYTESIZE + 1;
		
	printf("%d\n", SortBufferLen);
			
	char* pSortBuffer = new char[SortBufferLen];
	
	memset(pSortBuffer, 0, SortBufferLen);
	
	for(unsigned int i = 0; i < SortNumberArrayLen; i++)
	{
		//printf("%d", SortNumber[i]);
		SetBit(pSortBuffer, SortNumber[i]);
	}
	
	for(unsigned int i = 0; i < SortBufferLen; i++)
	{
		for(unsigned int offset = 0; offset < BYTESIZE; offset++)
		{
			//printf("%d\n", *(pSortBuffer + i) & (0x1 <<offset));
			
			if((*(pSortBuffer + i) & (0x1 <<offset)))
			{
				printf("%d#", i * BYTESIZE + offset);
			}
		}
	}
}



int main(int argc, char **argv)
{
	SortBitMap();
	
	int (i);
	
	system("pause");
	
	return 0;
}
