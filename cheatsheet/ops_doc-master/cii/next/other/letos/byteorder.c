#include "byteorder.h"

 

inline int is_host_lsb(void)
{
  const uint8_t n[2] = { 1, 0 };


  return * (uint16_t *)n == 1;
}

inline uint16_t toLSB16(uint16_t a)
{
  return is_host_lsb() ? a : (a << 8) | (a >> 8);
}



 

inline uint16_t fromLSB16(uint16_t a)
{
  return is_host_lsb() ? a : (a << 8) | (a >> 8);
}
