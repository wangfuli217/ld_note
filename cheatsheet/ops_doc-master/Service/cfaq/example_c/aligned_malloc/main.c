#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void* 
align_malloc(unsigned int size, unsigned int alignment)
{
    unsigned char * mem_ptr;
    unsigned char * tmp;
    if(!alignment) alignment = 4; //至少按4对齐
    /* Allocate the required size memory + alignment so we
    * can realign the data if necessary */
    if ((tmp = (unsigned char *) malloc(size + alignment)) != NULL){
        /* Align the tmp pointer */
        mem_ptr = (unsigned char *) ((unsigned int) (tmp + alignment - 1) & (~(unsigned int) (alignment - 1))); 
        /////////mem_ptr= (unsigned char*)tmp + (alignment - (unsigned long)(tmp) % alignment);也可以按这种方法来调整指针

        /* Special case where malloc have already satisfied the alignment
        * We must add alignment to mem_ptr because we must store
        * (mem_ptr - tmp) in *(mem_ptr-1)
        * If we do not add alignment to mem_ptr then *(mem_ptr-1) points
        * to a forbidden memory space */
        if (mem_ptr == tmp)
            mem_ptr += alignment;
        /* (mem_ptr - tmp) is stored in *(mem_ptr-1) so we are able to retrieve
        * the real malloc block allocated and free it in xvid_free 
		mem_ptr-1这个内存地址用来存储调整后的mem_ptr与真正的内存分配块之间的偏移量*/
        *(mem_ptr - 1) = (unsigned char) (mem_ptr - tmp);
        //PRT("Alloc mem addr: 0x%08x, size:% 8d, file:%s <line:%d>, ", tmp, size, file, line);
        /**//* Return the aligned pointer */
		printf("memptr address is %p\n",mem_ptr);
		printf("tmp address is %p\n",tmp);
		printf("offset is %d\n",*(mem_ptr -1));
        return ((void *)mem_ptr);
    }
	
    return(NULL);
}
/**//*****************************************************************************
* align_free
*
* Free a previously 'xvid_malloc' allocated block. Does not free NULL
* references.
*
* Returned value : None.
*
****************************************************************************/
void align_free(void *mem_ptr)
{
    unsigned char *ptr;
    if (mem_ptr == NULL)
        return;
    /**//* Aligned pointer */
    ptr = (unsigned char *)mem_ptr;
    /* *(ptr - 1) holds the offset to the real allocated block
    * we sub that offset os we free the real pointer 
	减去这个偏移值，找到真正的内存分配块地址*/
    ptr -= *(ptr - 1);
    /**//* Free the memory */
    free(ptr);
}

#define ALIGN_SIZE 8

#ifdef __WIN32 
	#define PAUSE system("pause")
#else
	#define PAUSE 
#endif

int main()
{
	int *ptr;
	ptr = (int *)align_malloc(100, ALIGN_SIZE);
	printf("address is %p\n",ptr);
	printf("value is %d \n",(unsigned int)ptr % ALIGN_SIZE);
	align_free(ptr);
	
	PAUSE;
	
	return 0;
}
