#include <string.h>
#include <limits.h>
#include "assert.h"
#include "mem.h"
#include "text.h"

#define T text_t


#define idx(i, len) ((i) < 0 ? (i) + (len) + 1 : (i))

#define convert(s, i, j) do{  \
    assert(s.str && s.len >= 0); \
    i = idx(i, s.len); j = idx(j, s.len); \
    if (i > j){ int t = i; i = j; j = t;} \
    assert(i >= 0 && j <= s.len);}while(0)

#define isatend(s, n) ((s).str+(s).len == _current->avail\
	&& _current->avail + (n) <= _current->limit)

#define equal(s, i, t) \
	(memcmp(&(s).str[i], (t).str, (t).len) == 0)


struct text_save_t {
	struct chunk *current;
	char *avail;
};

static struct chunk {
	struct chunk *link;
	char *avail;
	char *limit;
} _head = { NULL, NULL, NULL }, *_current = &_head;

static char _cset[] =
	"\000\001\002\003\004\005\006\007\010\011\012\013\014\015\016\017"
	"\020\021\022\023\024\025\026\027\030\031\032\033\034\035\036\037"
	"\040\041\042\043\044\045\046\047\050\051\052\053\054\055\056\057"
	"\060\061\062\063\064\065\066\067\070\071\072\073\074\075\076\077"
	"\100\101\102\103\104\105\106\107\110\111\112\113\114\115\116\117"
	"\120\121\122\123\124\125\126\127\130\131\132\133\134\135\136\137"
	"\140\141\142\143\144\145\146\147\150\151\152\153\154\155\156\157"
	"\160\161\162\163\164\165\166\167\170\171\172\173\174\175\176\177"
	"\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217"
	"\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237"
	"\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257"
	"\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277"
	"\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317"
	"\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337"
	"\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357"
	"\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377"
	;
const T text_cset   = {256, _cset};
const T text_ascii  = {127, _cset};
const T text_ucase  = {26,  _cset + 'A'};
const T text_lcase  = {26,  _cset + 'a'};
const T text_digits = {10,  _cset + '0'};
const T text_null   = {0,   _cset};



static char *_alloc(int len) {
	assert(len >= 0);
	if (_current->avail + len > _current->limit) {
		_current = _current->link = 
			ALLOC(sizeof (*_current) + 10*1024 + len);
		_current->avail = (char *)(_current + 1);
		_current->limit = _current->avail + 10*1024 + len;
		_current->link = NULL;
	}
	_current->avail += len;
	return _current->avail - len;
}

ssize_t 
text_pos(T text, ssize_t i)
{
    assert(text.str && text.len >= 0);
    i = idx(i, text.len);
    assert(i >= 0 && i <= text.len);
    return i;
}


T
text_box
(const char *str, ssize_t len){
    T text;
    assert(str);
    assert(len >= 0);

    text.str = str;
    text.len = len;

    return text;
}


T
text_sub
(T text, ssize_t i, ssize_t j)
{
    T ret;
    convert(text, i, j);

    ret.len = j - i;
    ret.str = text.str + i;
    return ret;
}


T
text_put
(const char *str)
{
    T text;

    assert(str);
    text.len = strlen(str);
    text.str = memcpy(_alloc(text.len), str, text.len);

    return text;
}


char *
text_get
(char *str, ssize_t size, T text)
{
    assert(text.len >= 0 && text.str);

    if(NULL == str){
        str = ALLOC(text.len + 1);
    }else{
        assert(size >= text.len + 1);
    }
    memcpy(str, text.str, text.len);
    str[text.len] = '\0';
    return str;
}


T
text_dup
(T text, int n)
{
    assert(text.len >= 0 && text.str);
    assert(n >= 0);
    
    if(0 == n || 0 == text.len){
        return text_null;
    }else if(1 == n){
        return text;
    }

    T ret;
    char *p;
    ret.len = n * text.len;
    if(isatend(text, ret.len - text.len)){
        ret.str = text.str;
        p = _alloc(ret.len - text.len);
        n--;
    }else{
        ret.str = p = _alloc(ret.len);
    }
    for(; n-- > 0; p += text.len){
        memcpy(p, text.str, text.len);
    }
    return ret;
}


T
text_cat
(T text1, T text2)
{
    assert(text1.len >= 0 && text1.str);
    assert(text2.len >= 0 && text1.str);

    if(0 == text1.len){
        return text2;
    }
    if(0 == text2.len){
        return text1;
    }
    if(text1.str + text1.len == text2.str){
        text1.len += text2.len;
        return text1;
    }
    T text;
    text.len = text1.len + text2.len;
    if(isatend(text1, text2.len)){
        text.str = text1.str;
        memcpy(_alloc(text2.len), text2.str, text2.len);
    }else{
        char *p;
        text.str = p = _alloc(  text1.len + text2.len);
        memcpy(p,               text1.str,  text1.len);
        memcpy(p + text1.len,   text2.str,  text2.len);
    }
    return text;
}




T
text_reverse
(T text)
{
    assert(text.len >= 0 && text.str);

    if(0 == text.len){
        return text_null;
    }else if(1 == text.len){
        return text;
    }

    T ret;
    char *p;
    int i = text.len;

    ret.len = text.len;
    ret.str = p = _alloc(text.len);
    while(--i >= 0){
        *p++ = text.str[i];
    }
    return ret;
}


T
text_map
(T text, const T *from, const T *to)
{
    static char map[256];
    static int inited = 0;

    assert(text.len >= 0 && text.str);
    if(from && to){
        /**
         * rebuild map
         */
        assert(from->len == to->len);
        int k;
        int map_len = (int)sizeof map;
        for(k = 0; k < map_len; k++){
            map[k] = k;
        }
        for(k = 0; k < from->len; k++){
            map[(unsigned char)from->str[k]] = to->str[k];
        }
        inited = 1;
    }else{
        assert(NULL == from && NULL == to);
        assert(inited);
    }

    if(0 == text.len){
        return text_null;
    }

    T ret;
    int i;
    char *p;
    ret.len = text.len;
    ret.str = p = _alloc(text.len);
    for(i = 0; i < text.len; i++){
        *p++ = map[(unsigned char)text.str[i]];
    }
    return ret;
}


int
text_cmp
(T text1, T text2)
{
    assert(text1.len >= 0 && text1.str);
    assert(text2.len >= 0 && text2.str);

    if(text1.str == text2.str){
        return text1.len - text2.len;
    }else if(text1.len < text2.len){
        int cond = memcmp(text1.str, text2.str, text1.len);
        return 0 == cond ? -1 : cond;
    }else if(text1.len > text2.len){
        int cond = memcmp(text1.str, text2.str, text2.len);
        return 0 == cond ? 1 : cond;
    }else 
        return memcmp(text1.str, text2.str, text1.len);
}


ssize_t 
text_chr
(T text, ssize_t i, ssize_t j, int c)
{
    convert(text, i, j);
    for(; i < j; i++){
        if(text.str[i] == c){
            return i;
        }
    }
    return -1;
}


ssize_t
text_rchr
(T text, ssize_t i, ssize_t j, int c)
{
    convert(text, i, j);
    while(j > i){
        if(text.str[--j] == c){
            return j;
        }
    }
    return -1;
}


ssize_t
text_upto
(T text, ssize_t i, ssize_t j, T set)
{
    assert(set.len >= 0 && set.str);
    convert(text, i, j);

    for(; i < j; i++){
        if(memchr(set.str, text.str[i], set.len)){
            return i;
        }
    }
    return -1;
}


ssize_t
text_rupto
(T text, ssize_t i, ssize_t j, T set)
{
    assert(set.len >= 0 && set.str);
    convert(text, i, j);

    while(j > i){
        if(memchr(set.str, text.str[--j], set.len))
            return j;
    }
    return -1;
}


ssize_t
text_find
(T text, ssize_t i, ssize_t j, T str)
{
    assert(str.len >= 0 && str.str);
    convert(text, i, j);

    if(0 == str.len){
        return i;
    }else if(1 == str.len){
        for(; i < j; i++){
            if(text.str[i] == *str.str){
                return i;
            }
        }
    }else{
        for(; i + str.len <= j; i++){
            if(equal(text, i, str))
                return i;
        }
    }
    return -1;
}


ssize_t
text_rfind
(T text, ssize_t i, ssize_t j, T str)
{
    assert(str.len >= 0 && str.str);
    convert(text, i, j);

    if(0 == str.len){
        return i;
    }else if(1 == str.len){
        while(j > i){
            if(text.str[--j] == *str.str){
                return j;
            }
        }
    }else{
        for(; j - str.len >= i; j--){
            if(equal(text, j - str.len, str))
                return j - str.len;
        }
    }
    return -1;
}


ssize_t
text_any
(T text, ssize_t i, T set)
{
    assert(text.len >= 0 && text.str);
    assert(set.len >= 0 && set.str);
    i = idx(i, text.len);
    assert(i >= 0 && i <= text.len);

    if(i < text.len && memchr(set.str, text.str[i], set.len)){
        return i + 1;
    }
    return -1;
}


ssize_t
text_many
(T text, ssize_t i, ssize_t j, T set)
{
    assert(set.len >= 0 && set.str);
    convert(text, i, j);
    if(i < j && memchr(set.str, text.str[i], set.len)){
        do{
            i++;
        }while(i < j &&
                memchr(set.str, text.str[i], set.len));
        return i;
    }
    return -1;
}


ssize_t
text_rmany
(T text, ssize_t i, ssize_t j, T set)
{
    assert(set.len >= 0 && set.str);
    convert(text, i, j);
    if(j > i && memchr(set.str, text.str[j-1], set.len)){
        do{
            --j;
        }while(j >= i &&
                memchr(set.str, text.str[j], set.len));
        return j;
    }
    return -1;
}




ssize_t
text_match
(T text, ssize_t i, ssize_t j, T str)
{
    assert(str.len >= 0 && str.str);
    convert(text, i, j);

    if(0 == str.len){
        return i;
    }else if(1 == str.len){
        if(i < j && text.str[i] == *str.str){
            return i + 1;
        }
    }else if(i + str.len <= j && equal(text, i, str)){
        return i + str.len;
    }
    return -1;
}


ssize_t
text_rmatch
(T text, ssize_t i, ssize_t j, T str)
{
    assert(str.len >= 0 && str.str);
    convert(text, i, j);

    if(0 == str.len){
        return j;
    }else if(1 == str.len){
        if(j > i && text.str[j-1] == *str.str){
            return j;
        }
    }else if(j - str.len >= i &&
            equal(text, j - str.len, str)){
        return j - str.len;
    }
    return -1;
}


text_save_t
text_save()
{
    text_save_t save;
    NEW(save);

    save->current   = _current;
    save->avail     = _current->avail;

    /**
     * make a hole in the char space
     * to makesure call isatend on 
     * these text_t object created before 
     * the hole will be failed
     */
    _alloc(1);

    return save;
}


void
text_restore(text_save_t *save)
{
    struct chunk *p, *q;

    assert(save && *save);
    _current = (*save)->current;
    _current->avail = (*save)->avail;
    
    FREE(*save);
    for(p = _current->link; p; p = q){
        q = p->link;
        FREE(p);
    }
    _current->link = NULL;
}
