#include <ctype.h>
#include "basictype.h"
#include "utility.h"
#include <string.h>


#include "sysprintf.h"

/////////////////////////////////////////////////////////////////////////
#define FLOAT_FORMAT_NUL  0
#define FLOAT_FORMAT_6_2  1
#define FLOAT_FORMAT_3_0  2
#define FLOAT_FORMAT_3_1  3
#define FLOAT_FORMAT_3_2  4
#define FLOAT_FORMAT_3_3  5
#define FLOAT_FORMAT_2_2  6
#define FLOAT_FORMAT_2_3  7
#define FLOAT_FORMAT_2_4  8
#define FLOAT_FORMAT_1_3  9
#define FLOAT_FORMAT_6_4  10
#define FLOAT_FORMAT_24T  11 //2_4Time
//add new format 
#define	FLOAT_FORMAT_4_2  12 //XXXX.XX
#define	FLOAT_FORMAT_4_0  13 //XXXX
#define	FLOAT_FORMAT_8_0  14 //MMDDhhmm
#define FLOAT_FORMAT_6_0  15 //XXXXXX
#define	FLOAT_FORMAT_2_0  16 //xx
#define FLOAT_FORMAT_10_0 17 //YYMMDDhhmm

#define FLOAT_FORMAT_PULS 20



const char *upperHEX = "0123456789ABCDEF";
static const char *lowerHEX = "0123456789abcdef";

/*!
 * \brief Create a copy of a string.
 *
 * Allocates sufficient memory from heap for a copy of the string
 * does the copy.
 *
 * \param str Pointer to the string to copy.
 *
 * \return A pointer to the new string or NULL if allocating memory failed.
 */
char *strdup(const char *str)
{
    
    char *copy = NULL;

	#if 0
  	size_t siz;
    siz = strlen(str) + 1;
    if ((copy = NutHeapAlloc(siz)) == NULL) {
        return NULL;
    }
    memcpy(copy, str, siz);
	#endif
    return copy;
}

void strupr(char*str)
{
	while(*str)
	{
		*str = toupper(*str);
		str++;
	}
}

int strncmp_nocase(const char*str1,const char*str2,int n)
{
	char c1,c2;
	
	while(n)
	{// becare: code page depended, like GBK (page 936)
		c1=toupper(*str1++);
		c2=toupper(*str2++);
		if(c1 == 0 || c2 == 0 || c1 != c2)
			break;
		n--;
	}
	
	if(n == 0)
		return 0;
	return c1-c2;
}

void SetNibble(u_char *pBuf,int nIndex,u_char bNib)
{
	int nBase = nIndex/2;
	u_char bTmp = pBuf[nBase];
	
	if(nIndex&0x01) bTmp = (bTmp&0x0f)|(bNib<<4);
	else bTmp = (bTmp&0xf0)|(bNib&0x0f);
	
	pBuf[nBase] = bTmp;
}

u_char GetNibble(const u_char *pBuf,u_short nIndex)
{
	u_char bNib;
	int nBase = nIndex/2;
	u_char bTmp = pBuf[nBase];
	
	if(nIndex&0x01) bNib = bTmp>>4;
	else bNib = bTmp&0x0f;
	
	return bNib;
}


u_long Hex2Int(const char*szHex)
{
	u_long hex = 0;
	const char*p = szHex;

	while(*p && isxdigit(*p))
	{
		hex <<= 4;
		if(isdigit(*p) ) hex |= (*p) & 0x0f;
		else hex |= ((*p) - ('A' - 0x3a)) &0x0f;
		p++;
	}
	return hex;
}



u_char Hex2Byte(const char*szHex)
{
	u_char hex = 0;
	
	if(isxdigit(szHex[0]))
	{
		if(isdigit(szHex[0]) ) hex = szHex[0] & 0x0f;
		else hex = (szHex[0] - ('A' - 0x3a)) &0x0f;
	}
	
	if(isxdigit(szHex[1]))
	{
		hex <<= 4;
		if(isdigit(szHex[1]) ) hex |= szHex[1] & 0x0f;
		else hex |= (szHex[1] - ('A' - 0x3a)) &0x0f;
	}
	
	return hex;
}

u_char Hex2Bin(const char szHex[2])
{
	return Hex2Byte(szHex);
}


void Byte2Hex(char *szoBuf,u_char biDat)
{//inet_addr(CONST char * str)
	extern const char *upperHEX;
	szoBuf[0] = upperHEX[(biDat>>4)&0x0f];
	szoBuf[1] = upperHEX[(biDat>>0)&0x0f];
	szoBuf[2] = 0;
}






void Word2Hex(char *szoBuf,u_short wiDat)
{
	Byte2Hex(szoBuf,wiDat>>8);
	Byte2Hex(szoBuf+2,wiDat&0xff);
}

void Long2Hex(char *szoBuf,u_long dwiDat)
{
	Word2Hex(szoBuf,dwiDat>>16);
	Word2Hex(szoBuf+4,dwiDat&0xffff);
}

u_longlong Hex2Longlong(const char*szHex)
{
	u_longlong hex = 0;
	const char*p = szHex;

	while(isxdigit(*p))
	{
		hex <<= 4;
		if(isdigit(*p) ) hex |= (*p) & 0x0f;
		else hex |= ((*p) - ('A' - 0x3a)) &0x0f;
		p++;
	}
	return hex;
}

u_long Bin2Int(const char*szBin)
{
	u_long Int = 0;
	const char*p = szBin;

	while(isxdigit(*p))
	{
		Int <<= 1;
		if(*p == '1' || *p == '0' ) 
			Int |= (*p) & 0x01;
		p++;
	}
	return Int;
}

int Asc2IntN(const char*szAscNum,int nLength)
{
	int nResult=0;
	int sig_f=0;
	int nCount = 0;

	if(nLength == 0)
		nLength = strlen(szAscNum);
	
	if(szAscNum[0] == '-')
	{
		sig_f = 1;
		nCount++;
	}

	
	while(isdigit(szAscNum[nCount]) && nCount<nLength)
	{
		nResult *= 10;
		nResult += szAscNum[nCount++] & 0x0f;
	}

	if(sig_f)
		nResult = (~nResult) + 1;
		
	return nResult;
}

int Asc2Int(const char*szAscNum)
{
	return Asc2IntN(szAscNum,0);
}


u_long AscBcd2Int(const char*szBcdNum,int nLength)
{
	int i;
	u_long hex = 0;
	if(nLength == 0)
		nLength = strlen(szBcdNum);

	//if(nLength>8) 
	//	nLength = 8;

	for(i = 0; i < nLength && isxdigit(szBcdNum[i]); i++)
	{
		char ch = toupper(szBcdNum[i]);
		hex <<= 4;
		if(isdigit(ch) ) hex |= (ch) & 0x0f;
		else hex |= ((ch) - ('A' - 0x3a)) &0x0f;
	}
	return hex;
}

#if 1

u_char Asc2_OneByteBCD(const u_char*str)
{
	u_char bHex = 0;
	char c;

	c = toupper(*str++);
	if(isxdigit(c))
	{
		if(isdigit(c))
			bHex = (c&0x0f)<<4;
		else
			bHex = (((10+c-'A')&0x0f)<<4);
	}
	return (bHex>>4);
}


u_long AscBcd2BcdHex(const char *szBcdNum, u_char *pBcdHex, int nLenBcd)
{
	int i;
	int nLenData;
	u_char ubaBcdHex[32] = {0};
	u_char *pbuf = NULL;

	if (nLenBcd == 0)
	{
		nLenBcd = strlen(szBcdNum);
	}
	//PRINTF("nLenBcd is %d \r\n", nLenBcd);

	memset(ubaBcdHex,0x00,32);
	//0123456789....->ubaBcdHex[0]......[i]
	for (i = 0; i < nLenBcd &&isxdigit(szBcdNum[i]); i++)
	{
		char ch = toupper(szBcdNum[i]);

		/*
		if ( isdigit(ch) )
		{
			ubaBcdHex[i] = (ch) & 0x0f;
		}
		*/
		ubaBcdHex[i] = Asc2_OneByteBCD((const u_char*)&ch);
		//PRINTF("ubaBcdHex[i] and I is %02x  %d \r\n", ubaBcdHex[i], i);
	}
	
	if (nLenBcd%2==0)
	{
		nLenData = nLenBcd >> 1;
		pbuf = (u_char*)&ubaBcdHex[0];
	}
	else
	{
		nLenData = (nLenBcd+1) >> 1;
		pbuf = (u_char*)&ubaBcdHex[1];
	}

	//PRINTF("nLenData is %d \r\n", nLenData);
	
	for (i = 0; i < nLenData; i++)
	{
		if (nLenBcd%2 == 0)
		{
			//pBcdHex[nLenData-i-1] = ubaBcdHex[i*2+1]|((ubaBcdHex[i*2])<<4); 
			pBcdHex[nLenData-i-1] = pbuf[i*2+1]|((pbuf[i*2])<<4); 
		}
		else
		{
			if (i == nLenData-1)
			{
				pBcdHex[nLenData-1]=ubaBcdHex[0]|(0<<4);
			}
			else
			{
				//pBcdHex[nLenData-i-2] = ubaBcdHex[i*2]|((ubaBcdHex[i*2+1])<<4); 
				pBcdHex[nLenData-i-2] = pbuf[i*2+1]|((pbuf[i*2])<<4); 
			}
		}
		//PRINTF("pBcdHex[i] and I is %02x  %d\r\n", pBcdHex[i], i);
	}

	return nLenData;
}
#endif

u_char Asc2BCD(const u_char*str)
{
	u_char bHex = 0;
	char c;

	c = toupper(*str++);
	if(isxdigit(c))
	{
		if(isdigit(c))
			bHex = (c&0x0f)<<4;
		else
			bHex = (((10+c-'A')&0x0f)<<4);
	}
	c = toupper(*str++);
	if(isxdigit(c))
	{
		if(isdigit(c))
			bHex |= (c&0x0f);
		else
			bHex |= 10+((c-'A')&0x0f);
	}
	return bHex;
}


#if 1
//cPad: '0','9','A'
void SetNodeID(u_char*pBuf,char cPad,const char *szMeterID,int nIDLen)
{
	char ID[13];
	
	if(nIDLen > 12) 
	{
		szMeterID += nIDLen-12;
		nIDLen = 12;
	}
	
	memset(ID,cPad,12);
	ID[12] = 0;
	
	memcpy(&ID[12-nIDLen],(char*)szMeterID,nIDLen);
	//putstrxy(1,1,ID);
	//putstr("\r\n");
	pBuf[0] = Asc2BCD((const u_char*)&ID[10]);
	pBuf[1] = Asc2BCD((const u_char*)&ID[8]);
	pBuf[2] = Asc2BCD((const u_char*)&ID[6]);
	pBuf[3] = Asc2BCD((const u_char*)&ID[4]);
	pBuf[4] = Asc2BCD((const u_char*)&ID[2]);
	pBuf[5] = Asc2BCD((const u_char*)&ID[0]);
}
#else
//cPad: '0','9','A'
void SetNodeID(u_char*pBuf,char cPad,const char *szMeterID,int nIDLen)
{
	char ID[17] = {0};

	//XPRINTF((0,"%s\r\n", szMeterID));
	
	if(nIDLen > 16) 
	{
		szMeterID += nIDLen-16;
		nIDLen = 16;
	}
	if (nIDLen == 0)
	{
		nIDLen = strlen(szMeterID);
	}
	XPRINTF((0,"nIDLen is %d\r\n", nIDLen));
	
	memset(ID,cPad,16);
	ID[16] = 0;
	
	memcpy(&ID[16-nIDLen],(char*)szMeterID,nIDLen);
//	memcpy(&ID[0],(char*)szMeterID,nIDLen);
	//putstrxy(1,1,ID);
	//putstr("\r\n");
	pBuf[0] = Asc2BCD(&ID[14]);
	pBuf[1] = Asc2BCD(&ID[12]);
	pBuf[2] = Asc2BCD(&ID[10]);
	pBuf[3] = Asc2BCD(&ID[8]);
	pBuf[4] = Asc2BCD(&ID[6]);
	pBuf[5] = Asc2BCD(&ID[4]);
	pBuf[6] = Asc2BCD(&ID[2]);
	pBuf[7] = Asc2BCD(&ID[0]);
}

#endif


u_long Bcd2Int(const u_char*pBcdNum,int nLength)
{
	int i;
	u_long hex = 0;
	for(i = 0; i < nLength && (pBcdNum[i]&0x0f)<=0x09 && (pBcdNum[i]&0xf0)<=0x90; i++)
	{
		hex <<= 8;
		hex |= (pBcdNum[i]&0x0f)+(pBcdNum[i]>>4)*10;
	}
	return hex;
}


float Bcd2Float(char *szBuf,u_char*pBCD,int nFmt)
{
	// 12345678
	float fResult = 0.0;
	char fmt[16];
	char szaBuf[16];
	//char *szaBuf = szBuf ? szBuf : szaBuf;
	if(pBCD[0] != 0xEE && pBCD[0] != 0xFF)
	{
		switch(nFmt)
		{
		case FLOAT_FORMAT_6_2:
			szaBuf[0] = (pBCD[3]>>4)  |0x30;
			szaBuf[1] = (pBCD[3]&0x0f)|0x30;
			szaBuf[2] = (pBCD[2]>>4)  |0x30;
			szaBuf[3] = (pBCD[2]&0x0f)|0x30;
			szaBuf[4] = (pBCD[1]>>4)  |0x30;
			szaBuf[5] = (pBCD[1]&0x0f)|0x30;
			szaBuf[6] = '.';
			szaBuf[7] = (pBCD[0]>>4)  |0x30;
			szaBuf[8] = (pBCD[0]&0x0f)|0x30;
			szaBuf[9] = 0;
			break;
		case FLOAT_FORMAT_6_4:
#if 0
			17:35:52 |Terminal:[4510-00021]
			17:35:52 |<--- 51  : 68 AE 00 AE 00 68 88 10 45 15 00 00 0C 6C 20 01 ;h....h..E....l .
				|         : 01 10 35 17 25 01 14 04 00 79 92 00 00 00 00 00 ;..5.%....y......
				|         : 00 00 00 97 32 00 00 00 88 45 00 00 00 94 13 00 ;....2....E......
				|         : 00 6E 16                                        ;.n.
				17:35:52 |总: 0.93
				17:35:52 |尖: 0.00
				17:35:52 |峰: 0.33
				17:35:52 |平: 0.46
				17:35:52 |谷: 6.00
#endif
			szaBuf[0]  = (pBCD[4]>>4)  |0x30;
			szaBuf[1]  = (pBCD[4]&0x0f)|0x30;
			szaBuf[2]  = (pBCD[3]>>4)  |0x30;
			szaBuf[3]  = (pBCD[3]&0x0f)|0x30;
			szaBuf[4]  = (pBCD[2]>>4)  |0x30;
			szaBuf[5]  = (pBCD[2]&0x0f)|0x30;
			szaBuf[6]  = '.';
			szaBuf[7]  = (pBCD[1]>>4)  |0x30;
			szaBuf[8]  = (pBCD[1]&0x0f)|0x30;
			szaBuf[9]  = (pBCD[0]>>4)  |0x30;
			szaBuf[10] = (pBCD[0]&0x0f)|0x30;
			szaBuf[11] = 0;
			break;
		case FLOAT_FORMAT_3_0:
			//20 02
			szaBuf[0] = (pBCD[1]&0x0f)|0x30;
			szaBuf[1] = (pBCD[0]>>4)  |0x30;
			szaBuf[2] = (pBCD[0]&0x0f)|0x30;
			szaBuf[3] = 0;
			break;
		case FLOAT_FORMAT_3_1:
			szaBuf[0] = (pBCD[1]>>4)  |0x30;
			szaBuf[1] = (pBCD[1]&0x0f)|0x30;
			szaBuf[2] = (pBCD[0]>>4)  |0x30;
			szaBuf[3] = '.';
			szaBuf[4] = (pBCD[0]&0x0f)|0x30;
			szaBuf[5] = 0;
			break;
		case FLOAT_FORMAT_3_2:
			szaBuf[0] = (pBCD[2]&0x0f)|0x30;
			szaBuf[1] = (pBCD[1]>>4)  |0x30;
			szaBuf[2] = (pBCD[1]&0x0f)|0x30;
			szaBuf[3] = '.';
			szaBuf[4] = (pBCD[0]>>4)  |0x30;
			szaBuf[5] = (pBCD[0]&0x0f)|0x30;
			szaBuf[6] = 0;
			break;
		case FLOAT_FORMAT_3_3:
			szaBuf[0] = (pBCD[2]>>4)  |0x30;
			szaBuf[1] = (pBCD[2]&0x0f)|0x30;
			szaBuf[2] = (pBCD[1]>>4)  |0x30;
			szaBuf[3] = '.';
			szaBuf[4] = (pBCD[1]&0x0f)|0x30;
			szaBuf[5] = (pBCD[0]>>4)  |0x30;
			szaBuf[6] = (pBCD[0]&0x0f)|0x30;
			szaBuf[7] = 0;
			break;
		case FLOAT_FORMAT_2_2:
			szaBuf[0] = (pBCD[1]>>4)  |0x30;
			szaBuf[1] = (pBCD[1]&0x0f)|0x30;
			szaBuf[2] = '.';
			szaBuf[3] = (pBCD[0]>>4)  |0x30;
			szaBuf[4] = (pBCD[0]&0x0f)|0x30;
			szaBuf[5] = 0;
			break;
		case FLOAT_FORMAT_2_3:
			szaBuf[0] = (pBCD[2]&0x0f)|0x30;
			szaBuf[1] = (pBCD[1]>>4)  |0x30;
			szaBuf[2] = '.';
			szaBuf[3] = (pBCD[1]&0x0f)|0x30;
			szaBuf[4] = (pBCD[0]>>4)  |0x30;
			szaBuf[5] = (pBCD[0]&0x0f)|0x30;
			szaBuf[6] = 0;
			break;
		case FLOAT_FORMAT_2_4:
			szaBuf[0] = (pBCD[2]>>4)  |0x30;
			szaBuf[1] = (pBCD[2]&0x0f)|0x30;
			szaBuf[2] = '.';
			szaBuf[3] = (pBCD[1]>>4)  |0x30;
			szaBuf[4] = (pBCD[1]&0x0f)|0x30;
			szaBuf[5] = (pBCD[0]>>4)  |0x30;
			szaBuf[6] = (pBCD[0]&0x0f)|0x30;
			szaBuf[7] = 0;
			break;
		case FLOAT_FORMAT_1_3:
			szaBuf[0] = (pBCD[1]>>4)  |0x30;
			szaBuf[1] = '.';
			szaBuf[2] = (pBCD[1]&0x0f)|0x30;
			szaBuf[3] = (pBCD[0]>>4)  |0x30;
			szaBuf[4] = (pBCD[0]&0x0f)|0x30;
			szaBuf[5] = 0;
			break;
		case FLOAT_FORMAT_PULS:{
			//unsigned __int64 qResult = 0;
			//memcpy(&qResult,pBCD,5);
			//sprintf_s(szaBuf,10,"%I64u",qResult);
			memcpy(szBuf,pBCD,5);
			return 0.0;
			//break;
			}
		default:
			return fResult;
		}
#ifdef WIN32
		fResult = (float)atof(szaBuf);

		if(szBuf)
		{
			fmt[0] = '%';
			fmt[1] = '.';
			fmt[2] = chp;
			fmt[3] = 'f';
			fmt[4] = '\0';
			sprintf_s(szBuf,10,fmt,fResult);
		}
#else
	fResult = 0.0;
#endif
	}
	return fResult;
}



void Int2BCD(u_long dwValue,u_char *poBCD)
{
	u_char bVal;

	bVal = dwValue%100;
	dwValue /=100;
	
	poBCD[0]  = bVal%10; 
	poBCD[0] |= (bVal/10)<<4; 
	
	bVal = dwValue%100;
	dwValue /=100;
	poBCD[1]  = bVal%10; 
	poBCD[1] |= (bVal/10)<<4; 
	
	bVal = dwValue%100;
	dwValue /=100;
	poBCD[2]  = bVal%10; 
	poBCD[2] |= (bVal/10)<<4; 
	
	bVal = dwValue%100;
	dwValue /=100;
	poBCD[3]  = bVal%10; 
	poBCD[3] |= (bVal/10)<<4; 
}

const u_short wTable[256]=
{     /* CRC余式表 */
	0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
	0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
	0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6,
	0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
	0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485,
	0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d,
	0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4,
	0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc,
	0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823,
	0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b,
	0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12,
	0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a,
	0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
	0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49,
	0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70,
	0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78,
	0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f,
	0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067,
	0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e,
	0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256,
	0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d,
	0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
	0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c,
	0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634,
	0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab,
	0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3,
	0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a,
	0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92,
	0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9,
	0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1,
	0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
	0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0
};

u_short CRC16(const u_char *pciDat,u_long dwiLen)
{

	u_long i;
	u_short wResult = 0;
	u_char da;
	
	for(i = 0; i< dwiLen; i++)
	{
		da = (u_char)(wResult>>8);
		wResult <<= 8;
		wResult ^= wTable[da^pciDat[i]];
	}
	return wResult;
}

u_char CRC8(const u_char *pciDat,u_long dwiLen)
{
	u_char i;
	u_char bDat;
	u_char bResult = 0;
	u_long dwCount;

	for(dwCount = 0; dwCount < dwiLen; dwCount++)
	{
		bDat = pciDat[dwCount];
		
		for(i=0; i<8; i++,bDat >>= 1)
		{
			if(((bDat^bResult)&0x01) == 0)
			{
				bResult >>= 1;
			}
			else
			{
				bResult ^= 0x18;
				bResult >>= 1;
				bResult |= 0x80;
			}
		}
	}
	return bResult;
}


#if defined(NUTDEBUG_USE_ASSERT)
void NUTPANIC(CONST char *fmt, ...)
{
	
}

void NUTFATAL(CONST char *fun, CONST char *file, int, CONST char *statement)
{
	//printf("FATAL ERROR: %s in %s,%s\r\n",statement,fun,file);
}
#endif

