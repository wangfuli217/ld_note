/*
* =====================================================================================
*
*       Filename:  main.c
*
*    Description:  
*
*        Version:  1.0
*        Created:  09/01/2013 09:08:55 AM
*       Revision:  none
*       Compiler:  gcc
*
*         Author:  sunke (), sunke@sunniwell.net
*        Company:  Sunniwell
*
* =====================================================================================
*/
#include <stdio.h>
#include "sha.h"

int main(int argc, char *argv[])
{
    SHA_CTX *ctx;
    char *filename;
    FILE *infile;
    int len;
    char buffer[1024];
    unsigned char md[SHA_DIGEST_LENGTH+1];

    if( argc != 2 )
    {
        printf("Usage:%s filename\n",argv[0]);
        return 0;
    }

    filename = argv[1]; 

    infile = fopen(filename,"r");
    if(infile == NULL)
    {
        printf("open %s fail\n",filename);
        return -1;
    }

    ctx = malloc(sizeof(SHA_CTX));
    if( ctx == NULL )
    {
        printf("malloc sha contex fail\n");
        fclose( infile );
        return -1;
    }

    SHA1_Init(ctx);
    while( ( len = fread(buffer,1,1024,infile) ) > 0 )
    {
        SHA1_Update(ctx, buffer, len);
    }
    SHA1_Final(md, ctx);
    int i;
    for( i = 0 ; i < SHA_DIGEST_LENGTH; i++ )
    {
        printf("%02x",md[i]);
    }
    printf("\n");
    
    return 0;
}
