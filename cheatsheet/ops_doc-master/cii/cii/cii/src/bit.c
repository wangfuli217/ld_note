#include<stdarg.h>
#include<string.h>
#include"assert.h"
#include"mem.h"
#include"bit.h"

#define T bit_t

#define BPW (8*sizeof(unsigned long))

#define nwords(len) ((((len) + BPW - 1) & (~(BPW - 1))) / BPW)

#define nbytes(len) ((((len) + 8 - 1) & (~(8 - 1))) / 8)

#define setop(sequal, snull, tnull, op) \
    if(s == t){assert(s); return sequal;} \
    else if(NULL == s){assert(t); return snull;} \
    else if(NULL == t)return tnull; \
    else{ \
        ssize_t i; T bset; \
        assert(s->length == t->length); \
        bset = bit_new(s->length); \
        for(i = nwords(s->length); --i >= 0;) \
            bset->words[i] = s->words[i] op t->words[i]; \
        return bset;}

struct T{
    ssize_t length;
    unsigned char *bytes;
    unsigned long *words;
};

static unsigned char msbmask[] = {
	0xFF, 0xFE, 0xFC, 0xF8,
	0xF0, 0xE0, 0xC0, 0x80
};
static unsigned char lsbmask[] = {
	0x01, 0x03, 0x07, 0x0F,
	0x1F, 0x3F, 0x7F, 0xFF
};

static 
inline 
int
_bit_in_set(unsigned char *bytes, ssize_t position)
{
    return ((bytes[position / 8] >> (position % 8)) & 1);
}

static 
inline 
T 
_bit_copy(T t)
{
    T bset;

    assert(t);

    bset = bit_new(t->length);
    if(t->length > 0)
        memcpy(bset->bytes, t->bytes, nbytes(t->length));

    return bset;
}

T
bit_new     (ssize_t length)
{
    T bset;

    assert(length >= 0);

    NEW(bset);

    if(length > 0)
        bset->words = CALLOC(nwords(length),
                sizeof(unsigned long));
    else
        bset->words = NULL;

    bset->bytes = (unsigned char *)bset->words;
    bset->length = length;

    return bset;
}


ssize_t
bit_length  (T bset)
{
    assert(bset);
    return bset->length;
}


ssize_t
bit_count   (T bset)
{
    unsigned char c;
    ssize_t length = 0, n;
    static char count[] = {
        0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4};

    assert(bset);

    for(n = nbytes(bset->length); --n >= 0;){
        c = bset->bytes[n];
        length += count[c & 0xF] + count[c >> 4];
    }
    
    return length;
}


void
bit_free    (T *bset)
{
    assert(bset && *bset);
    FREE((*bset)->words);
    FREE(*bset);
}


int
bit_get     (T bset, ssize_t position)
{
    assert(bset);
    assert(0 <= position && position < bset->length);

    return _bit_in_set(bset->bytes, position);
}


int
bit_put     (T bset, ssize_t position, int bit)
{
    int prev;

    assert(bset);
    assert(0 == bit || 1 == bit);
    assert(0 <= position && position < bset->length);
    prev = _bit_in_set(bset->bytes, position);

    if(1 == bit)
        bset->bytes[position / 8] |= 1 << (position % 8);
    else
        bset->bytes[position / 8] &= ~(1 << (position % 8));

    return prev;
}

void
bit_clear   (T bset, ssize_t low, ssize_t high)
{
    ssize_t i;

    assert(bset);
    assert(0 <= low && high < bset->length);
    assert(low <= high);

    if(low / 8 < high / 8){
        
        bset->bytes[low / 8] &= ~msbmask[low % 8];
        for(i = low / 8 + 1; i < high / 8; i++)
            bset->bytes[i] = 0;
        bset->bytes[high / 8]  &= ~lsbmask[high % 8]; 
    }else{
        bset->bytes[low / 8] &= ~(msbmask[low % 8] & lsbmask[high % 8]);
    }
}


void
bit_set     (T bset, ssize_t low, ssize_t high)
{
    ssize_t i;

    assert(bset);
    assert(0 <= low && high < bset->length);
    assert(low <= high);

    if(low / 8 < high / 8){
        bset->bytes[low / 8] |= msbmask[low % 8];  

        for(i = low/8 + 1; i < high / 8; i++)
            bset->bytes[i] = 0xFF;

        bset->bytes[high / 8] |= lsbmask[high % 8];
    }else{
        bset->bytes[low / 8] |= (msbmask[low % 8] & lsbmask[high % 8]);
    }
}


void
bit_not     (T bset, ssize_t low, ssize_t high)
{
    ssize_t i;

    assert(bset);
    assert(0 <= low && high < bset->length);
    assert(low <= high);

    if(low / 8 < high / 8){
        bset->bytes[low / 8] ^= msbmask[low % 8];

        for(i = low / 8 + 1; i < high / 8; i++)
            bset->bytes[i] ^= 0xFF;

        bset->bytes[high / 8] ^= lsbmask[high % 8];
    }else{

        bset->bytes[low / 8] ^= (msbmask[low % 8] & lsbmask[high % 8]);
    }
}


int
bit_lt      (T s, T t)
{
    int i, lt;
    assert(s && t);
    assert(s->length == t->length);

    lt = 0;

    for(i = nwords(s->length); --i >= 0;){
        if((s->words[i] & ~t->words[i]) != 0)
            return 0;
        else if(s->words[i] != t->words[i])
            lt |= 1;
    }
    return lt;
}


int
bit_eq      (T s, T t)
{
    int i;
    assert(s && t);
    assert(s->length == t->length);

    for(i = nwords(s->length); --i >= 0;)
        if(s->words[i] != t->words[i])
            return 0;
    return 1;
}


int
bit_leq     (T s, T t)
{

    int i;
    assert(s && t);
    assert(s->length == t->length);

    for(i = nwords(s->length); --i >= 0;)
        if((s->words[i] & ~t->words[i]) != 0)
            return 0;
    return 1;
}

void
bit_map     (T bset,
                void (*apply)(ssize_t position, int bit, void *cl),
                void *cl)
{
    ssize_t n;

    assert(bset);
    for( n = 0; n < bset->length; n++)
        apply(n, _bit_in_set(bset->bytes, n), cl);
}


T
bit_union   (T s, T t)
{
    setop(_bit_copy(t), _bit_copy(t), _bit_copy(s), |)
}


T
bit_inter   (T s, T t)
{
    setop(_bit_copy(t), bit_new(t->length), bit_new(s->length), &)
}


T
bit_minus   (T s, T t)
{
    setop(bit_new(s->length), bit_new(t->length), _bit_copy(s), & ~)
}


T
bit_diff    (T s, T t)
{
    setop(bit_new(s->length), _bit_copy(t), _bit_copy(s), ^)
}


