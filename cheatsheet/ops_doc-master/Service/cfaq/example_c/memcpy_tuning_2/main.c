#include <unistd.h>
#include <sys/time.h>
#include <stdio.h>
#include <string.h>

#define BYTE_MEMCPY(to,from,len)\
{\
	__asm__ __volatile__(\
	"rep movsb"\
	:"=D"(to),"=S"(from)\
	:"0"(to), "1"(from),"c"(len)\
	:"memory");\
}

#define BYTE4_MEMCPY(to,from,len)\
{\
	__asm__ __volatile__(\
	"rep movsl"\
	:"=D"(to),"=S"(from)\
	:"0"(to), "1"(from),"c"(len)\
	:"memory");\
}

void * memcpy_4(void * to, const void * from, size_t len)
{
	void *retval = to;
	register unsigned long int tocopy;

	if(len >= 4 && (tocopy = ((long int)to & 3)))
	{		
		tocopy = 4-tocopy;
		len   -= tocopy;
		BYTE_MEMCPY(to,from,tocopy);
	}
	if(tocopy = (len >> 2))
	{
		len  -= (tocopy<<2);
		BYTE4_MEMCPY(to,from,tocopy);
	}

	BYTE_MEMCPY(to,from,len);

	return retval;
}

void * memcpy_64(void * to, const void * from, size_t len)
{
	void *retval = to;
	register unsigned long int tocopy;

	if(len >= 64 && (tocopy = ((long int)to & 63)))
	{
		tocopy = 64-tocopy;
		len   -= tocopy;
		memcpy_4(to,from,tocopy);
		to    += tocopy;
		from  += tocopy;
	}
	
	if(tocopy = (len >> 6))
	{	
		__asm__ __volatile__	(
			    	"prefetchnta (%[from])\n"
			    	"prefetchnta 64(%[from])\n\t"
			    	"prefetchnta 128(%[from])\n\t"
			    	"prefetchnta 192(%[from])\n\t"
			    	"prefetchnta 256(%[from])\n\t"
				::[from]"r"(from)
				);
		len -= (tocopy<<6);
		while(tocopy--)
		{
			__asm__ __volatile__(	
						"prefetchnta 320(%[from])\n"
						"movaps	(%[from]),%%xmm0\n\t"
						"movaps	16(%[from]),%%xmm1\n\t"
						"movaps	32(%[from]),%%xmm2\n\t"
						"movaps	48(%[from]),%%xmm3\n\t"	
						"movaps	%%xmm0,(%[to])\n\t"
						"movaps	%%xmm1,16(%[to])\n\t"
						"movaps	%%xmm2,32(%[to])\n\t"
						"movaps	%%xmm3,48(%[to])\n\t"
						::[from]"r"(from),[to]"r"(to)
						:"memory"
					);
			from  += 64;
			to    += 64;
		}		
	}

	memcpy_4(to,from,len);
	
	return retval;
}

int main(int argc,char *argv[])
{
	int i,scale;
	struct timeval begin,end;

	if(argc==2)
	{
		scale=1024*atoi(argv[1]);
	}
	else
	{	
		scale=4096;
	}

	char src[scale],dst[scale];	
	for(i=0;i<scale;++i)
	{
		src[i]=rand()%255+1;	//'A'+i%26; //
	}
	src[scale-1]='\0';

	printf("\tINLINE-ASM memcpy:\n");

	gettimeofday(&begin,NULL);
	//for(i=0;i<100;++i)
	memcpy_64(dst,src,sizeof(src));
	gettimeofday(&end,NULL);

	//printf("\tsrc:%s\n\tdst:%s\n",src,dst);
	printf("\tTIME COST: %6ld sec %6ld us      *****\n",end.tv_sec-begin.tv_sec,end.tv_usec-begin.tv_usec);

	printf("\n");
	
	system("pause");

	return 0;
} 


