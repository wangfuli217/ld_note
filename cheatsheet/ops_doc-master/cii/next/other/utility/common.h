/**************************************************************************************************
  Filename:       common.h
  Revised:        $Date: 2013-07-18 13:54:23  $
  Revision:       $Revision: 00001 $

  Description:    16 Î»CRC Ð£ÑéÂë
**************************************************************************************************/

#ifndef COMMON_H
#define COMMON_H

/*********************************************************************
 * INCLUDES
 */
 #include "basictype.h"
/*********************************************************************
 * CONSTANTS
 */


/*********************************************************************
 * MACROS
 */



/*********************************************************************
 * FUNCTIONS
 */
extern uint16 cyg_crc16(const unsigned char *puchMsg, uint16 usDataLen);
extern int hex2ascii( const uint8  *pidata, uint8 *poBuf, int len);
extern unsigned char assic2hex(uint8 ch);
extern int bcd2hex(uint8* indata,uint8*outdata,int len);
extern uint16 bcd2hex16bits(uint8* indata);
extern uint16 linkage_calc_crc16( uint8 * pucFrame, uint8 usLen );


/*********************************************************************
*********************************************************************/

#endif /* CRC_16_H */