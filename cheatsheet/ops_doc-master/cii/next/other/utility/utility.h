#ifndef __UTILITY_H__
#define __UTILITY_H__
//#include <arch.h>

//__BEGIN_DECLS

char *strdup(const char *str);
void strupr(char*str);
int strncmp_nocase(const char*str1,const char*str2,int n);

void Byte2Hex(char *szoBuf,u_char biDat);
void Word2Hex(char *szoBuf,u_short wiDat);
void Long2Hex(char *szoBuf,u_long dwiDat);

int Asc2IntN(const char*szAscNum,int nLength);

int Asc2Int(const char*szAscNum);
u_long Hex2Int(const char*szHex);
u_long Bin2Int(const char*szBin);
u_longlong Hex2Longlong(const char*szHex);
u_long AscBcd2Int(const char * szBcdNum, int nLength);
u_long Bcd2Int(const u_char*pBcdNum,int nLength);
u_short CRC16(const u_char *pciDat,u_long dwiLen);

u_char Hex2Bin(const char szHex[2]);
u_char Hex2Byte(const char * szHex);

float Bcd2Float(char *szBuf,u_char*pBCD,int nFmt);



void SetNibble(u_char *pBuf,int nIndex,u_char bNib);
u_char GetNibble(const u_char *pBuf,u_short nIndex);

void SetNodeID(u_char*pBuf,char cPad,const char *szMeterID,int nIDLen);
u_long AscBcd2BcdHex(const char *szBcdNum, u_char *pBcdHex, int nLenBcd);

//__END_DECLS
	
#endif//__UTILITY_H__

