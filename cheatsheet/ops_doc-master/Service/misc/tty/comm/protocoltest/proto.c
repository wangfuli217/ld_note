/*************************************************************************
	> File Name: proto.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Thu 22 Sep 2016 02:19:05 PM CST
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/types.h>
#include <string.h>
#include "proto.h"

#define HEADER_MASK	(0x1f)

#define HEADER_LEN (13)

enum rx_state
{
	RX_STATE_START_CHAR					= 0,
	RX_STATE_SEQUENCE_ID				= 1,
	RX_STATE_COMMAND_ID					= 2,
	RX_STATE_DATA_LEN					= 3,
	RX_STATE_STOP_BIT					= 4,
	RX_STATE_PARITY						= 5,
	RX_STATE_FLOW_CONTROL				= 6,
	RX_STATE_DATA_SIZE					= 7,
	RX_STATE_HEAD_CHECKSUM				= 8,
	RX_STATE_DATA						= 9,
};
typedef enum rx_state					RX_STATE;



static RX_STATE m_RxState;
static uint8_t m_RxCheckSum;
static uint8_t m_RxIndex;
static uint16_t m_RxSeqId;
static uint8_t m_RxCmdId;
static uint32_t	m_RxDataLen;
static uint8_t	m_RxStopBit;
static uint8_t m_RxParity;
static uint8_t m_RxFlowControl;
static uint8_t m_RxDataSize;
static uint8_t m_RxData[32];
#define START_CHAR (0x1f)

#define RESERVE_BUFFER_SIZE 32
#define max(x,y)  ( x>y?x:y )
#define min(x,y)  ( x<y?x:y )

static void initvalue()
{
	m_RxCheckSum = 0;
	m_RxIndex= 0;
	m_RxSeqId= 0;
	m_RxCmdId= 0;
	m_RxDataLen= 0;
	m_RxStopBit= 0;
	m_RxParity= 0;
	m_RxFlowControl= 0;
	m_RxDataSize= 0;
	memset(m_RxData,0,sizeof(m_RxData));

}

static uint8_t checksum(uint8_t data[],uint8_t len)
{
	uint8_t checksum = 0;
	uint8_t index = 0;
	for(index = 0; index < len; index++)
	{
		checksum += data[index];
	}
	return checksum;
}

uint8_t *alloc_data(DATAFORMAT format,uint32_t *len)
{
	uint8_t *data = (uint8_t *)malloc(HEADER_LEN+format.data_size);
	data[0] = START_CHAR;
	data[1] = (format.seq_id >> 5) & HEADER_MASK;
	data[2] = format.seq_id & HEADER_MASK;
	data[3] = format.cmd_id;	//command
	data[4] = (format.data_len >> 15) & HEADER_MASK;	//data len 1
	data[5] =(format.data_len >> 10) & HEADER_MASK;	//data len 2
	data[6] =(format.data_len >> 5) & HEADER_MASK;	//data len 3
	data[7] = format.data_len & HEADER_MASK;	//data len 4
	data[8] = format.stop_bit;	//stop bit
	data[9] = format.parity;	//parity
	data[10] = format.flow_control;	//parity
	data[11] = format.data_size;	//data size
	data[12] = checksum(data,HEADER_LEN-1); //checksum
	memcpy(data+HEADER_LEN,format.data,format.data_size);
	*len = HEADER_LEN+format.data_size;
	return data;
}
uint32_t rechecksum_data(uint8_t data[])
{
	data[12] = checksum(data,HEADER_LEN-1);
	return 0;
}

void showData()
{
	int i = 0;
	printf("m_RxSeqId,%d,0x%x\n",m_RxSeqId,m_RxSeqId);
	printf("m_RxCmdId,%d,0x%x\n",m_RxCmdId,m_RxCmdId);
	printf("m_RxDataLen,%d,0x%x\n",m_RxDataLen,m_RxDataLen);
	printf("m_RxStopBit,%d,0x%x\n",m_RxStopBit,m_RxStopBit);
	printf("m_RxParity,%d,0x%x\n",m_RxParity,m_RxParity);
	printf("m_RxFlowControl,%d,0x%x\n",m_RxFlowControl,m_RxFlowControl);
	printf("m_RxDataSize,%d,0x%x\n",m_RxDataSize,m_RxDataSize);
	printf("m_RxCheckSum,%d,0x%x\n",m_RxCheckSum,m_RxCheckSum);
	printf("m_RxData,");
	for(i = 0; i< m_RxDataSize;i++)
		printf("%02x ",m_RxData[ i ]);
	printf("\n");
}
uint32_t compart_format(DATAFORMAT *a, DATAFORMAT *b)
{
	if(a->seq_id != b->seq_id)
		return -1;
	if(a->data_len != b->data_len)
		return -1;
	if(a->stop_bit != b->stop_bit)
		return -1;
	if(a->parity != b->parity)
		return -1;
	if(a->flow_control != b->flow_control)
		return -1;
	if(a->data_size != b->data_size)
		return -1;
	if(memcmp(a->data,b->data,a->data_size))
		return -1;
	if(a->cmd_id == b->cmd_id )
		return 0;
	if((a->cmd_id & ~(0x1)) == (b->cmd_id & ~(0x1)))
		return 1;
	return -1;

}



#define TOSTATE(x) \
{\
	m_RxState = x;\
	m_RxIndex = 0;\
}


uint32_t OnDataReceived( uint8_t* dataBuffer, int dataLength ,DATAFORMAT  *format,uint32_t *find)
{
	int eat = 1;
	bool complete = false;

	printf( ( "%s: dataLength = %d, m_RxState = %d\n" ), __func__, dataLength, m_RxState );

	switch ( m_RxState )
	{
	case RX_STATE_START_CHAR:
		if ( START_CHAR == dataBuffer[ 0 ] )
		{
			initvalue();
			m_RxCheckSum = (uint8_t) dataBuffer[ 0 ];
			TOSTATE(RX_STATE_SEQUENCE_ID);
		}
		break;
	case RX_STATE_SEQUENCE_ID:
			m_RxCheckSum += (uint8_t) dataBuffer[ 0 ];

			m_RxSeqId = m_RxSeqId << 5;
			m_RxSeqId += (uint8_t) dataBuffer[ 0 ] & 0x1f;
			m_RxIndex++;
			if(m_RxIndex >= sizeof(m_RxSeqId))
			TOSTATE(RX_STATE_COMMAND_ID);

		break;

	case RX_STATE_COMMAND_ID:
		m_RxCheckSum += (uint8_t) dataBuffer[ 0 ];

		m_RxCmdId = (uint8_t) dataBuffer[ 0 ];
		TOSTATE(RX_STATE_DATA_LEN);
		break;

	case RX_STATE_DATA_LEN:
		m_RxCheckSum += (uint8_t) dataBuffer[ 0 ];

		m_RxDataLen = m_RxDataLen << 5;
		m_RxDataLen += (uint8_t) dataBuffer[ 0 ] & 0x1f;
		m_RxIndex++;

		if(m_RxIndex >= sizeof(m_RxDataLen))
			TOSTATE(RX_STATE_STOP_BIT);
		break;
	case RX_STATE_STOP_BIT:
		m_RxCheckSum += (uint8_t) dataBuffer[ 0 ];

		m_RxStopBit = (uint8_t) dataBuffer[ 0 ];
		TOSTATE(RX_STATE_PARITY);
		break;
	case RX_STATE_PARITY:
		m_RxCheckSum += (uint8_t) dataBuffer[ 0 ];

		m_RxParity = (uint8_t) dataBuffer[ 0 ];
		TOSTATE( RX_STATE_FLOW_CONTROL );
		break;
	case RX_STATE_FLOW_CONTROL:
		m_RxCheckSum += (uint8_t) dataBuffer[ 0 ];

		m_RxFlowControl = (uint8_t) dataBuffer[ 0 ];
		TOSTATE( RX_STATE_DATA_SIZE );
		break;

	case RX_STATE_DATA_SIZE:
		m_RxCheckSum += (uint8_t) dataBuffer[ 0 ];

		m_RxDataSize = (uint8_t) dataBuffer[ 0 ];
		TOSTATE( RX_STATE_HEAD_CHECKSUM );
		break;

	case RX_STATE_HEAD_CHECKSUM:
		if ( m_RxCheckSum != dataBuffer[ 0 ] )
		{
			TOSTATE( RX_STATE_START_CHAR );
		}
		else
		{
			TOSTATE(  RX_STATE_DATA );
		}
		break;

	case RX_STATE_DATA:
		eat = min( m_RxDataSize - m_RxIndex, dataLength );
		memcpy( &m_RxData[ m_RxIndex ], dataBuffer, eat );
		m_RxIndex += eat;

		if ( m_RxIndex >= m_RxDataSize )
		{
			complete = true;
			TOSTATE( RX_STATE_START_CHAR );
		}
		break;

	default:
		TOSTATE( RX_STATE_START_CHAR );
		break;
	}

	if ( complete )
	{
		*find = 1;
		format->seq_id = m_RxSeqId;
		format->cmd_id = m_RxCmdId;
		format->data_len = m_RxDataLen;
		format->stop_bit = m_RxStopBit;
		format->parity = m_RxParity;
		format->flow_control = m_RxFlowControl;
		format->data_size = m_RxDataSize;
		memcpy(format->data,m_RxData,m_RxDataSize);
		showData();
	}

	return eat;
}

