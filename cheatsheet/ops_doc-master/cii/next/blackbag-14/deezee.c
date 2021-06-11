/*
 * Copyright (c) 2005, Matasano Software LLC 
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Matasano Security LLC,  nor the names of its 
 *       contributors may be used to endorse or promote products derived from 
 *       this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY MATASANO SECURITY LLC "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL MATASANO SECURITY LLC BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "zlib.h"

#define CHUNK 131072
#define OUTNAME "%s.%d"
const unsigned short lzcomp = 0x789c;
const unsigned short lzcomp_le = 0x9c78;
const unsigned short gzcomp = 0x1f8b;
const unsigned short gzcomp_le = 0x8b1f;

int inf(FILE *source, FILE *dest, int *expansioncount);

int
main(int argc, char **argv)
{
    int offset=0, size, rval, incr=0, fcount = 0;
    struct stat statbuf;
    FILE *infile, *outfile;
    unsigned short lzc = lzcomp, gzc=gzcomp;
    char buf[256];
    unsigned char in[2];

    if(argc < 2) {
	    fprintf(stderr, "%s filename\n", argv[0]);
	    return -1;
    }
   
    // handle little endian without compilation bs. 
    if((*(char*)&lzcomp) != 0x78) {
            lzc = lzcomp_le;
	    gzc = gzcomp_le;
    } 

 
    infile=fopen(argv[1], "r");
    fstat(fileno(infile), &statbuf);
    size = statbuf.st_size;
    
    fprintf(stderr, "Scanning file %s for compressed components\nCompressed size: %d bytes\n", argv[1], size);
    
    snprintf(buf, 255, OUTNAME, argv[1], fcount);
    outfile = fopen(buf, "w");
    fread(&in, 1, 2, infile);;
    offset = 1;
    incr = 0;
    do{
	    offset += incr;
	    if(memcmp(in, &lzc, 2) == 0 || memcmp(in, &gzc, 2) == 0) {
		    fseek(infile, offset-1, SEEK_SET);
		    incr = inf(infile, outfile, &rval);
		    if(incr != 0) {
			    fclose(outfile);
			    fcount++;
			    snprintf(buf, 255, OUTNAME, argv[1], fcount);
			    outfile = fopen(buf, "w");
                            printf("Compressed segment found at 0x%x.  Expanded to %d bytes\n", offset, rval);
			    fseek(infile, offset+incr-1, SEEK_SET);
			    incr -= 1;
		    } else {
			    fseek(infile, offset, SEEK_SET);
			    incr = 1;	    	    
		    }		    
	    } else incr = 1;
	    in[0] = in[1];
    } while(fread(&in[1], 1, 1, infile) != 0);
    fclose(outfile);
    return 0;
}  

/* culled + modified from zpipe.c */
int inf(FILE *source, FILE *dest, int *expansioncount)
{
    int ret;
    unsigned have;
    z_stream strm;
    unsigned char in[CHUNK];
    unsigned char out[CHUNK];
    *expansioncount = 0;
    /* allocate inflate state */
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.avail_in = 0;
    strm.next_in = Z_NULL;
    ret = inflateInit2(&strm,47);
    if (ret != Z_OK)
        return 0;

    /* decompress until deflate stream ends or end of file */
    do {
        strm.avail_in = fread(in, 1, CHUNK, source);
        if (ferror(source)) {
            (void)inflateEnd(&strm);
            return 0;
        }
        if (strm.avail_in == 0)
            break;
        strm.next_in = in;

        /* run inflate() on input until output buffer not full */
        do {
            strm.avail_out = CHUNK;
            strm.next_out = out;
            ret = inflate(&strm, Z_NO_FLUSH);
            assert(ret != Z_STREAM_ERROR);  /* state not clobbered */
#ifdef TEM
            switch (ret) {
            case Z_NEED_DICT:
                ret = Z_DATA_ERROR;     /* and fall through */
            case Z_DATA_ERROR:
            case Z_MEM_ERROR:
                (void)inflateEnd(&strm);
                return 0;
            }
#endif
            have = CHUNK - strm.avail_out;
            if (fwrite(out, 1, have, dest) != have || ferror(dest)) {
                (void)inflateEnd(&strm);
                return 0;
            }
        } while (strm.avail_out == 0);
        
        /* done when inflate() says it's done */
    } while (ret != Z_STREAM_END);
            
    /* clean up and return */
    (void)inflateEnd(&strm);
    *expansioncount = strm.total_out;
    return ret == Z_STREAM_END ? strm.total_in : 0;
}           

#ifdef X
inf2()
{
	ULONG dataSize = 10000;
	char *pData = new char[dataSize];
	_tcsnset(pData, END_OF_STR, dataSize);
	
	z_stream d_stream;
	d_stream.zalloc = (alloc_func)0;
	d_stream.zfree = (free_func)0;
	d_stream.opaque = (voidpf)0;
	
	
	d_stream.next_in = (unsigned char*)pstrBuffer;
	d_stream.avail_in = (uInt)compArraySize;
	
	int status;
	
	status = inflateInit2(&d_stream, 47);
	
	for (;;){
		
		d_stream.next_out = (unsigned char*)pData;
		d_stream.avail_out = (uInt)dataSize;
		
		//memset(pData, END_OF_STR, dataSize);
		status = inflate(&d_stream, Z_SYNC_FLUSH); // Z_NO_FLUSH
		
		cout << pData;
		_tcsnset(pData, END_OF_STR, dataSize);
		
		if (status == Z_STREAM_END){
			break;
		}else if(status != Z_OK){
			// Put Error handling here.
			break;
		}
		
	}
	
	inflateEnd(&d_stream);
}
#endif
