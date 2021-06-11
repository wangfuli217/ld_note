#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "platform.h"
#include "tlv.h"
#include "utils.h"
#include "debug.h"

int pack_value (tlv_t * tlv, void *outbuf, uint32_t * out_sz);

int unpack_value (tlv_type_t type, uint16_t id, void *inbuf, uint16_t length, tlv_t * out_tlv);

int validate_tlv_len (tlv_type_t type, uint32_t length);

int pack_int8 (uint8_t * int8, uint8_t * outbuf, uint32_t * out_sz);

int pack_int16 (uint16_t * int16, uint16_t * outbuf, uint32_t * out_sz);

int unpack_int16 (uint16_t * int16, uint16_t * outbuf, uint32_t * out_sz);

int pack_int32 (uint32_t * int32, uint32_t * outbuf, uint32_t * out_sz);

int unpack_int32 (uint32_t * int32, uint32_t * outbuf, uint32_t * out_sz);

int pack_bytes (void *inbuf, uint32_t in_sz, void *outbuf, int32_t * out_sz);

tlv_t *tlv_new (uint16_t id, tlv_type_t type, uint16_t length, uint8_t * value) {

    tlv_t *tlv = NULL;

    size_t sz = sizeof (*tlv);
    tlv = malloc (sz);
    if (tlv == NULL) {
        ph_log_err ("fata error: malloc(%d): tlv", sz);
    }

    memset (tlv, 0, sz);

    tlv->id = id;
    tlv->type = type;
    tlv->length = length;

    tlv->value = malloc (length);
    if (tlv->value == NULL) {
        ph_log_err ("fata error: malloc(%d): tvl->value", length);
    }
    memcpy (tlv->value, value, length);

    return tlv;
}

void tlv_free (tlv_t * tlv) {
    if (tlv) {
        if (tlv->value) {
            free (tlv->value);
        }
        free (tlv);
    }
}

int tlv_pack (tlv_t * tlv, uint8_t * out, uint32_t out_sz) {
    assert (tlv != NULL);

    uint32_t pack_sz = 0;
    pack_sz = tlv_get_packed_size (tlv);
    if (out_sz < pack_sz) {
        ph_debug ("not enough size, out_sz:%d, pack_sz:%d", out_sz, pack_sz);
        return -1;
    }

    PUT16 (out, htons (tlv->id));
    ADVANCE16P (out);
    PUT16 (out, htons (tlv->type));
    ADVANCE16P (out);
    PUT16 (out, htons (tlv->length));
    ADVANCE16P (out);
    pack_sz -= sizeof (uint16_t) * 3;

    return pack_value (tlv, out, &pack_sz);
}

int tlv_unpack (tlv_t * tlv, uint8_t * packed, uint32_t sz) {
    if (NULL == tlv || NULL == packed || 0 == sz) {
        return -1;
    }

    uint8_t *p = packed;
    uint16_t id = 0, type = 0, length = 0;
    int b = 0;

    id = ntohs (GET16 (p));
    ADVANCE16P (p);
    type = ntohs (GET16 (p));
    ADVANCE16P (p);
    length = ntohs (GET16 (p));
    ADVANCE16P (p);

    if (length > sz) {
        ph_debug ("not enough packed buf, length:%d sz:%d", length, sz);
        return -1;
    }

    b = unpack_value (type, id, p, length, tlv);

    return b;
}

uint32_t tlv_get_packed_size (tlv_t * tlv) {
    uint32_t pack_sz = 0;

    pack_sz = sizeof (tlv_t) - sizeof (uint8_t *);
    pack_sz += tlv->length;

    return pack_sz;
}

int pack_value (tlv_t * tlv, void *outbuf, uint32_t * out_sz) {
    if (NULL == tlv || NULL == outbuf || NULL == out_sz) {
        return -1;
    }

    int b = 0;

    switch (tlv->type) {

    case TLV_TYPE_INT8:
    case TLV_TYPE_UINT8:
        b = pack_int8 ((uint8_t *) (tlv->value), outbuf, out_sz);
        break;

    case TLV_TYPE_INT16:
    case TLV_TYPE_UINT16:
        b = pack_int16 ((uint16_t *) (tlv->value), outbuf, out_sz);
        break;

    case TLV_TYPE_INT32:
    case TLV_TYPE_UINT32:
        b = pack_int32 ((uint32_t *) (tlv->value), outbuf, out_sz);
        break;

    case TLV_TYPE_BYTES:
        b = pack_bytes (tlv->value, tlv->length, outbuf, out_sz);
        break;

    default:
        b = -1;
        break;
    }

    return b;
}

int unpack_value (tlv_type_t type, uint16_t id, void *inbuf, uint16_t length, tlv_t * out_tlv) {
    int b = 0;
    uint32_t out_sz = 0;
    void *value = NULL;

    if (NULL == inbuf || NULL == out_tlv) {
        return -1;
    }

    value = malloc (length);
    if (NULL == value) {
        return -1;
    }

    switch (type) {
    case TLV_TYPE_INT8:
    case TLV_TYPE_UINT8:
        b = pack_int8 ((uint8_t *) inbuf, (uint8_t *) value, &out_sz);
        break;

    case TLV_TYPE_INT16:
    case TLV_TYPE_UINT16:
        b = unpack_int16 ((uint16_t *) inbuf, (uint16_t *) value, &out_sz);
        break;

    case TLV_TYPE_INT32:
    case TLV_TYPE_UINT32:
        b = unpack_int32 ((uint32_t *) inbuf, (uint32_t *) value, &out_sz);
        break;

    case TLV_TYPE_BYTES:
        out_sz = length;
        b = pack_bytes (inbuf, length, value, &out_sz);
        break;

    default:
        b = -1;
        break;
    }

    if (b != 0) {
        free (value);
        return -1;
    }

    out_tlv->id = id;
    out_tlv->type = type;
    out_tlv->length = length;
    out_tlv->value = value;

    return b;
}

int validate_tlv_len (tlv_type_t type, uint32_t length) {
    int b = 0;
    switch (type) {
    case TLV_TYPE_INT8:
    case TLV_TYPE_UINT8:
        b = (1 != length);
        break;

    case TLV_TYPE_INT16:
    case TLV_TYPE_UINT16:
        b = (2 != length);
        break;

    case TLV_TYPE_INT32:
    case TLV_TYPE_UINT32:
        b = (4 != length);
        break;

    case TLV_TYPE_BYTES:
        b = 0;
        break;

    default:
        b = -1;
        break;
    }
    return b;
}

int pack_int8 (uint8_t * int8, uint8_t * outbuf, uint32_t * out_sz) {
    if (NULL == int8 || NULL == outbuf || NULL == out_sz) {
        return -1;
    }
    if (1 > *out_sz) {
        return -1;
    }
    *out_sz = 1;
    *outbuf = *int8;
    return 0;
}

int pack_int16 (uint16_t * int16, uint16_t * outbuf, uint32_t * out_sz) {
    if (NULL == int16 || NULL == outbuf || NULL == out_sz) {
        return -1;
    }
    if (2 > *out_sz) {
        return -1;
    }
    *out_sz = 2;
    *outbuf = htons (*int16);
    return 0;
}

int unpack_int16 (uint16_t * int16, uint16_t * outbuf, uint32_t * out_sz) {
    if (NULL == int16 || NULL == outbuf || NULL == out_sz) {
        return -1;
    }
    if (2 > *out_sz) {
        return -1;
    }
    *out_sz = 2;
    *outbuf = ntohs (*int16);
    return 0;
}

int pack_int32 (uint32_t * int32, uint32_t * outbuf, uint32_t * out_sz) {
    if (NULL == int32 || NULL == outbuf || NULL == out_sz) {
        return -1;
    }
    if (4 > *out_sz) {
        return -1;
    }
    *out_sz = 4;
    *outbuf = htonl (*int32);
    return 0;
}

int unpack_int32 (uint32_t * int32, uint32_t * outbuf, uint32_t * out_sz) {
    if (NULL == int32 || NULL == outbuf || NULL == out_sz) {
        return -1;
    }
    if (4 > *out_sz) {
        return -1;
    }
    *out_sz = 4;
    *outbuf = ntohl (*int32);
    return 0;
}

int pack_bytes (void *inbuf, uint32_t in_sz, void *outbuf, int32_t * out_sz) {
    if (NULL == inbuf || NULL == outbuf || out_sz == NULL) {
        return -1;
    }
    if (in_sz > *out_sz) {
        return -1;
    }
    *out_sz = in_sz;
    memcpy (outbuf, inbuf, in_sz);
    return 0;
}
