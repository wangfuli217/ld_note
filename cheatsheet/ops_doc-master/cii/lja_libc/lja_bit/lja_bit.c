#include  "lja_type.h"
#include  "lja_bit.h"

lja_Bit *lja_bit_new(u_int32 size){
	assert(size>=0);
	lja_Bit *ptr = (lja_Bit *)malloc(sizeof(lja_Bit) + (size+7)>>3);
	if (NULL != ptr){
		memset(ptr->ptr,'\0',(size+7)>>3);
		ptr->size = size;
	}
	return ptr;
}

void lja_bit_set(lja_Bit *bit, u_int32 pos){
	assert(NULL != bit);
	assert(pos >0 && pos <= bit->size);

	u_int32 n = pos>>3;
	u_int32 m = pos&7;
	if (m){
		*(bit->ptr+n) = *(bit->ptr+n) | (1<<(8-m));
	}else{
		*(bit->ptr+n) = *(bit->ptr+n) | 1;
	}
}

u_int8 lja_bit_get(lja_Bit *bit, u_int32 pos){
	assert(NULL != bit);
	assert(pos > 0 && pos <= bit->size);

	u_int32 n = pos>>3;
	u_int32 m = pos&7;

	u_char va = *(bit->ptr+n);
	if(m){
		return (va & (1<<(8-m)))>>(8-m);
	}else{
		return (va & 1);
	}
}

void lja_bit_reset(lja_Bit *bit, u_int32 pos){
	assert(NULL != bit);
	assert(pos >=0 && pos <= bit->size);

	u_int32 n = pos>>3;
	u_int32 m = pos&7;
	if(m){
		*(bit->ptr+n) = *(bit->ptr+n) & (~(1<<(8-m)));
	}else{
		*(bit->ptr+n) = *(bit->ptr+n) & 0xfe;
	}
}

void lja_bit_clean(lja_Bit *bit){
	assert(NULL != bit);
	memset(bit->ptr,'\0',(bit->size + 7)>>3);
}

void lja_bit_free(lja_Bit *bit){
	assert(NULL != bit);
	free(bit);
}
