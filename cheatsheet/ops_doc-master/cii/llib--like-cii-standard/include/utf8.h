
#include <stdint.h>

#include "utils.h"
#include "except.h"

BEGIN_DECLS

extern Except_T     u8_conversion_failed;

/* check that no illegal utf-8 chars, no irregular sequences or isolated surrogates */
extern uint16_t*    u8_to_u16_checked(const char* src);
extern char*        u16_to_u8_checked(const uint16_t* src);

extern uint16_t*    u8_to_u16(const char* src);
extern char*        u16_to_u8(const uint16_t* src);

extern unsigned     u8_charnum(const char *s, unsigned offset);

extern uint32_t     u8_nextchar(const char *s, unsigned *i);
extern void         u8_inc(const char *s, unsigned *i);
extern void         u8_dec(const char *s, unsigned *i);


extern char*        u8_strchr(char *s, uint32_t ch, unsigned *charn);
extern char*        u8_memchr(char *s, uint32_t ch, size_t sz, unsigned *charn); /* doesn't stop at end of string char, but at sz*/

extern unsigned     u8_is_locale_utf8(const char *locale);

extern size_t       u8_strlen_in_chars(const char *s);
extern char*        u8_sub (const char *s, size_t i, size_t j);
extern char*        u8_reverse(const char*s);

extern unsigned     u8_vprintf(const char *fmt, va_list ap); /* fmt can be utf as well*/
extern unsigned     u8_printf(const char *fmt, ...);

extern              size_t u16_strlen(const uint16_t* s);
END_DECLS
