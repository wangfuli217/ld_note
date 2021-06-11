
#ifndef __BASE64_H__
#define __BASE64_H__

/*
 * This is not-quite-MIME-spec compliant, as I don't
 * insert a \r\n for every 76th character.
 */

/* 
 * Estimated buffer size needed to decode a base64 string
 * of length 'len'.
 */
static inline size_t base64_size (size_t len) {
    return (len * 3 + 3) / 4;
}

/*
 * Estimated length for base64 encoding of a buffer.
 */
static inline size_t base64_length (size_t size) {
    return (size * 4 + 2) / 3;
}

struct evbuffer;

/*
 * Decode a base64 (\0 terminated) string into buf.
 * Returns actual size of encoded data (may be != size).
 */
size_t base64_decode (const char *str, unsigned char *buf, size_t size);

/*
 * Encode binary data into a libeven buffer.
 */
int base64_encode_evbuf (struct evbuffer *evbuf, const unsigned char *s, size_t length);

#endif
