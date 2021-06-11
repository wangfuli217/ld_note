
#ifndef __ZUNKFS_BYTEORDER_H__
#define __ZUNKFS_BYTEORDER_H__

#include <stdint.h>
#include <netinet/in.h>         // for BYTE_ORDER

#ifndef BYTE_ORDER
#error BYTE_ORDER not defined!
#endif

static inline uint16_t bswap16 (uint16_t x) {
    return ((x << 8) & 0xff00) | ((x >> 8) & 0x00ff);
}

static inline uint32_t bswap32 (uint32_t x) {
    return ((x << 24) & 0xff000000) | ((x << 8) & 0x00ff0000) | ((x >> 8) & 0x0000ff00) | ((x >> 24) & 0x000000ff);
}

static inline uint64_t bswap64 (uint64_t x) {
    return ((x << 56) & 0xff00000000000000ULL) |
        ((x << 40) & 0x00ff000000000000ULL) |
        ((x << 24) & 0x0000ff0000000000ULL) |
        ((x << 8) & 0x000000ff00000000ULL) | ((x >> 8) & 0x00000000ff000000ULL) | ((x >> 24) & 0x0000000000ff0000ULL) | ((x >> 40) & 0x000000000000ff00ULL) | ((x >> 56) & 0x00000000000000ffULL);
}

/* 
 * Type-safe byteorder definitions.
 */
typedef struct {
    uint16_t v;
} le16_t;
typedef struct {
    uint16_t v;
} be16_t;
typedef struct {
    uint32_t v;
} le32_t;
typedef struct {
    uint32_t v;
} be32_t;
typedef struct {
    uint64_t v;
} le64_t;
typedef struct {
    uint64_t v;
} be64_t;

/*
 * Newer Linux and BSD may already define htole* and htobe* as macros.
 */
#undef htole16
#undef htole32
#undef htole64
#undef htobe16
#undef htobe32
#undef htobe64
#undef le16toh
#undef le32toh
#undef le64toh
#undef be16toh
#undef be32toh
#undef be64toh

/*
 * BSD style, but type-safe, conversions... 
 */
#if BYTE_ORDER == LITTLE_ENDIAN
static inline le16_t htole16 (uint16_t x) {
    return (le16_t) {
    x};
}
static inline be16_t htobe16 (uint16_t x) {
    return (be16_t) {
    bswap16 (x)};
}
static inline le32_t htole32 (uint32_t x) {
    return (le32_t) {
    x};
}
static inline be32_t htobe32 (uint32_t x) {
    return (be32_t) {
    bswap32 (x)};
}
static inline le64_t htole64 (uint64_t x) {
    return (le64_t) {
    x};
}
static inline be64_t htobe64 (uint64_t x) {
    return (be64_t) {
    bswap64 (x)};
}
static inline uint16_t le16toh (le16_t x) {
    return x.v;
}
static inline uint16_t be16toh (be16_t x) {
    return bswap16 (x.v);
}
static inline uint32_t le32toh (le32_t x) {
    return x.v;
}
static inline uint32_t be32toh (be32_t x) {
    return bswap32 (x.v);
}
static inline uint64_t le64toh (le64_t x) {
    return x.v;
}
static inline uint64_t be64toh (be64_t x) {
    return bswap64 (x.v);
}
#else
static inline le16_t htole16 (uint16_t x) {
    return (le16_t) {
    bswap16 (x)};
}
static inline be16_t htobe16 (uint16_t x) {
    return (be16_t) {
    x};
}
static inline le32_t htole32 (uint32_t x) {
    return (le32_t) {
    bswap32 (x)};
}
static inline be32_t htobe32 (uint32_t x) {
    return (be32_t) {
    x};
}
static inline le64_t htole64 (uint64_t x) {
    return (le64_t) {
    bswap64 (x)};
}
static inline be64_t htobe64 (uint64_t x) {
    return (be64_t) {
    x};
}
static inline uint16_t le16toh (le16_t x) {
    return bswap16 (x.v);
}
static inline uint16_t be16toh (be16_t x) {
    return x.v;
}
static inline uint32_t le32toh (le32_t x) {
    return bswap32 (x.v);
}
static inline uint32_t be32toh (be32_t x) {
    return x.v;
}
static inline uint64_t le64toh (le64_t x) {
    return bswap64 (x.v);
}
static inline uint64_t be64toh (be64_t x) {
    return x.v;
}
#endif

#endif
