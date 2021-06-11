/*************************************************************************
	> File Name: autotest.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Thu 22 Sep 2016 02:18:47 PM CST
 ************************************************************************/

#include<stdio.h>
#include <stdlib.h>

#include "proto.h"

void client_pushback(uint8_t *inbuff,uint32_t inlen,uint8_t *outbuff,uint32_t *outlen)
{
	DATAFORMAT format_new;
	uint32_t find = 0;
	uint32_t length = inlen;

	if ( length > 0 )
	{
		int index = 0;
		while ( index < length )
		{
			index += OnDataReceived( &inbuff[ index ], length - index ,&format_new ,&find);
			if(find)
			{
				//send back
				if( ~(format_new.cmd_id & 0x1))
				{
					format_new.cmd_id |=  0x1;
				}
				uint32_t ret;
				uint8_t *adata =alloc_data(format_new,&ret);
				memcpy(outbuff,adata,ret);
				*outlen = ret;
				free(adata);
			}
		}
	}



}

int main(int argc,char *argv[])
{
	uint32_t length ;
	DATAFORMAT format;
	format.cmd_id = 2;
	format.seq_id = 3;
	format.data_len = 256000;
	format.stop_bit = 1;
	format.parity = 0x7;
	format.data_size = 5;
	format.flow_control = 0;
	memset(format.data,'A',5);

	uint32_t ret;
	uint8_t *adata =alloc_data(format,&ret);
	DATAFORMAT format_new;
	uint32_t find = 0;

	uint8_t bdata[128];
	uint32_t outlen = 0;

	client_pushback(adata,ret,bdata,&outlen);
	length = outlen;
	if ( length > 0 )
	{
		int index = 0;
		while ( index < length )
		{
			index += OnDataReceived( &bdata[ index ], length - index ,&format_new ,&find);
			if(find)
			{
//				format_new.cmd_id |=  0x1;
				int ret = compart_format(&format_new,&format);
				switch(ret)
				{
				case 0:
					printf("get raw back:%d\n",ret);
					break;
				case 1:
					printf("get client back:%d\n",ret);
					break;
				case -1:
					printf("different\n");
					break;
				}

			}
		}
	}

	free(adata);

	return 0;
}
