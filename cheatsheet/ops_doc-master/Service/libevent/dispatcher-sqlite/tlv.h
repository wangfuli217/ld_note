#ifndef __TLV_H__
#define __TLV_H__

#include <stdint.h>

#define S(s)       #s
#define STR(s)     S(s)
#define UINT8P(p)  ((uint8_t*)(p))
#define UINT16P(p) ((uint16_t*)(p))
#define UINT32P(p) ((uint32_t*)(p))

#define PACKED __attribute__((packed))

#define PUT8(p, c)  (*UINT8P(p) = (uint8_t)(c))
#define PUT16(p, s) (*UINT16P(p) = (uint16_t)(s))
#define PUT32(p, l) (*UINT32P(p) = (uint32_t)(l))

#define GET8(p)  (*UINT8P(p))
#define GET16(p) (*UINT16P(p))
#define GET32(p) (*UINT32P(p))

#define ADVANCE8P(p)  p = (UINT8P(UINT8P(p) + 1))
#define ADVANCE16P(p) p = (UINT8P(UINT16P(p) + 1))
#define ADVANCE32P(p) p = (UINT8P(UINT32P(p) + 1))

typedef struct {
    uint16_t id;
    uint16_t type;
    uint16_t length;
    uint8_t *value;
} PACKED tlv_t;

typedef enum {
    TLV_TYPE_INT8 = 1,
    TLV_TYPE_UINT8,
    TLV_TYPE_INT16,
    TLV_TYPE_UINT16,
    TLV_TYPE_INT32,
    TLV_TYPE_UINT32,
    TLV_TYPE_BYTES
} tlv_type_t;

tlv_t *tlv_new (uint16_t id, tlv_type_t type, uint16_t length, uint8_t * value);
int tlv_pack (tlv_t * tlv, uint8_t * out, uint32_t sz);
int tlv_unpack (tlv_t * tlv, uint8_t * packed, uint32_t sz);
uint32_t tlv_get_packed_size (tlv_t * tlv);
void tlv_free (tlv_t * tlv);

#endif
