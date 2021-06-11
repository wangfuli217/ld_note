// #############################################################################
// *****************************************************************************
//                  Copyright (c) 2016, Advantech Automation Corp.
//      THIS IS AN UNPUBLISHED WORK CONTAINING CONFIDENTIAL AND PROPRIETARY
//               INFORMATION WHICH IS THE PROPERTY OF ADVANTECH AUTOMATION CORP.
//
//    ANY DISCLOSURE, USE, OR REPRODUCTION, WITHOUT WRITTEN AUTHORIZATION FROM
//               ADVANTECH AUTOMATION CORP., IS STRICTLY PROHIBITED.
// *****************************************************************************
// #############################################################################
//
// File:   	 proto.h
// Author:  suchao.wang
// Created: Sep 22, 2016
//
// Description:  File download process class.
// ----------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////


#ifndef PROTO_H_
#define PROTO_H_
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <sys/types.h>

/* Package format
	+------------------------+
0	|  start_char <0x1f>  |
	+------------------------+
1	|   sequence_id_lsb   |
	+------------------------+
2	|   sequence_id_msb   |
	+------------------------+
3	|      command_id     |
	+------------------------+
4	|       data_len_1    |
	+------------------------+
5	|       data_len_2    |
	+------------------------+
6	|       data_len_3    |
	+------------------------+
7	|       data_len_4    |
	+------------------------+
8	|       stop_bit      |
	+------------------------+
9	|       parity        |
	+------------------------+
10	|       flow control  |
	+------------------------+
11	|       data size     |
	+------------------------+
12	|    head_check_sum   |
	+------------------------+
13	|        data         |
	+------------------------+
	|          ...           |
	+------------------------+
N	|    data_check_sum   |
	+------------------------+
*/

struct _data_format
{
	uint16_t seq_id;
	uint8_t cmd_id;
	uint32_t	data_len;
	uint8_t	stop_bit;
	uint8_t parity;
	uint8_t flow_control;
	uint8_t data_size;
	uint8_t data[32];
};

typedef struct _data_format DATAFORMAT;


uint32_t OnDataReceived( uint8_t* dataBuffer, int dataLength ,DATAFORMAT  *format,uint32_t *find);
uint8_t *alloc_data(DATAFORMAT format,uint32_t *len);
uint32_t compart_format(DATAFORMAT *a, DATAFORMAT *b);
uint32_t rechecksum_data(uint8_t data[]);

#endif /* PROTO_H_ */
