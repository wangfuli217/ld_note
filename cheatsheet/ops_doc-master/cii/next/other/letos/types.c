/** @file types.c
	@brief The detailed implementation of the types.

	@author Qing Charles Cao (cao@utk.edu)
*/

#include "types.h"
#ifdef PLATFORM_AVR
#include "../hardware/avrhardware.h"
#endif
inline result_t rcombine(result_t r1, result_t r2)
{
    return r1 == FAIL ? FAIL : r2;
}

//-------------------------------------------------------------------------
uint16_t hex2value(uint8_t hex)
{
    char a = (char)hex;
    uint16_t high;

    if ((a >= '0') && (a <= '9'))
    {
        high = a - '0';
    }
    else
    {
        high = a - 'A' + 10;
    }

    return high;
}

//-------------------------------------------------------------------------
char dec2asciichar(uint8_t value)
{
    if ( /*( value >= 0 ) && */ (value <= 9))
    {
        return (char)(value + 0x30);
    }
    else
    {
        return 0;
    }
}

//-------------------------------------------------------------------------
_atomic_t _atomic_start(void)
{
#ifdef PLATFORM_AVR
    _atomic_t result = _atomic_start_avr();
#endif
    return result;
}

//-------------------------------------------------------------------------
void _atomic_end(_atomic_t oldSreg)
{
#ifdef PLATFORM_AVR
    _atomic_end_avr(oldSreg);
#endif
}

//-------------------------------------------------------------------------
inline void *nmemset(void *to, int val, size_t n)
{
    char *cto = to;

    while (n--)
    {
        *cto++ = val;
    }

    return to;
}
