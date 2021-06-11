#include <stdio.h>
#include <stdint.h>
/**
 * Copy 16 bytes from one location to another using optimised SSE
 * instructions. The locations should not overlap.
 *
 * @param s1
 *   Pointer to the destination of the data.
 * @param s2
 *   Pointer to the source data.
 */
static inline void
mov16(uint8_t *dst, const uint8_t *src)
{
    asm volatile ("movdqu (%[src]), %%xmm0\n\t"
              "movdqu %%xmm0, (%[dst])\n\t"
              :
              : [src] "r" (src),
            [dst] "r"(dst)
              : "xmm0", "memory");
}
 
/**
 * Copy 32 bytes from one location to another using optimised SSE
 * instructions. The locations should not overlap.
 *
 * @param s1
 *   Pointer to the destination of the data.
 * @param s2
 *   Pointer to the source data.
 */
static inline void
mov32(uint8_t *dst, const uint8_t *src)
{
    asm volatile ("movdqu (%[src]), %%xmm0\n\t"
              "movdqu 16(%[src]), %%xmm1\n\t"
              "movdqu %%xmm0, (%[dst])\n\t"
              "movdqu %%xmm1, 16(%[dst])"
              :
              : [src] "r" (src),
            [dst] "r"(dst)
              : "xmm0", "xmm1", "memory");
}
 
/**
 * Copy 48 bytes from one location to another using optimised SSE
 * instructions. The locations should not overlap.
 *
 * @param s1
 *   Pointer to the destination of the data.
 * @param s2
 *   Pointer to the source data.
 */
static inline void
mov48(uint8_t *dst, const uint8_t *src)
{
    asm volatile ("movdqu (%[src]), %%xmm0\n\t"
              "movdqu 16(%[src]), %%xmm1\n\t"
              "movdqu 32(%[src]), %%xmm2\n\t"
              "movdqu %%xmm0, (%[dst])\n\t"
              "movdqu %%xmm1, 16(%[dst])"
              "movdqu %%xmm2, 32(%[dst])"
              :
              : [src] "r" (src),
            [dst] "r"(dst)
              : "xmm0", "xmm1", "memory");
}
 
/**
 * Copy 64 bytes from one location to another using optimised SSE
 * instructions. The locations should not overlap.
 *
 * @param s1
 *   Pointer to the destination of the data.
 * @param s2
 *   Pointer to the source data.
 */
static inline void
mov64(uint8_t *dst, const uint8_t *src)
{
    asm volatile ("movdqu (%[src]), %%xmm0\n\t"
              "movdqu 16(%[src]), %%xmm1\n\t"
              "movdqu 32(%[src]), %%xmm2\n\t"
              "movdqu 48(%[src]), %%xmm3\n\t"
              "movdqu %%xmm0, (%[dst])\n\t"
              "movdqu %%xmm1, 16(%[dst])\n\t"
              "movdqu %%xmm2, 32(%[dst])\n\t"
              "movdqu %%xmm3, 48(%[dst])"
              :
              : [src] "r" (src),
            [dst] "r"(dst)
              : "xmm0", "xmm1", "xmm2", "xmm3","memory");
}
 
/**
 * Copy 128 bytes from one location to another using optimised SSE
 * instructions. The locations should not overlap.
 *
 * @param s1
 *   Pointer to the destination of the data.
 * @param s2
 *   Pointer to the source data.
 */
static inline void
mov128(uint8_t *dst, const uint8_t *src)
{
    asm volatile ("movdqu (%[src]), %%xmm0\n\t"
              "movdqu 16(%[src]), %%xmm1\n\t"
              "movdqu 32(%[src]), %%xmm2\n\t"
              "movdqu 48(%[src]), %%xmm3\n\t"
              "movdqu 64(%[src]), %%xmm4\n\t"
              "movdqu 80(%[src]), %%xmm5\n\t"
              "movdqu 96(%[src]), %%xmm6\n\t"
              "movdqu 112(%[src]), %%xmm7\n\t"
              "movdqu %%xmm0, (%[dst])\n\t"
              "movdqu %%xmm1, 16(%[dst])\n\t"
              "movdqu %%xmm2, 32(%[dst])\n\t"
              "movdqu %%xmm3, 48(%[dst])\n\t"
              "movdqu %%xmm4, 64(%[dst])\n\t"
              "movdqu %%xmm5, 80(%[dst])\n\t"
              "movdqu %%xmm6, 96(%[dst])\n\t"
              "movdqu %%xmm7, 112(%[dst])"
              :
              : [src] "r" (src),
            [dst] "r"(dst)
              : "xmm0", "xmm1", "xmm2", "xmm3",
            "xmm4", "xmm5", "xmm6", "xmm7", "memory");
}
 
/**
 * Copy 256 bytes from one location to another using optimised SSE
 * instructions. The locations should not overlap.
 *
 * @param s1
 *   Pointer to the destination of the data.
 * @param s2
 *   Pointer to the source data.
 */
static inline void
mov256(uint8_t *dst, const uint8_t *src)
{
    /*
     * There are 16XMM registers, but this function does not use
     * them all so that it can still be compiled as 32bit
     * code. The performance increase was neglible if all 16
     * registers were used.
     */
    mov128(dst, src);
    mov128(dst + 128, src + 128);
}
 
 
/**
 * Copy bytes from one location to another. The locations should not overlap.
 *
 * @param s1
 *   Pointer to the destination of the data.
 * @param s2
 *   Pointer to the source data.
 * @param n
 *   Number of bytes to copy.
 * @return
 *   s1
 */
void *
fast_memcpy(void *s1, const void *s2, size_t n)
{
    uint8_t *dst = (uint8_t *)s1;
    const uint8_t *src = (const uint8_t *)s2;
 
    /* We can't copy < 16 bytes using XMM registers so do it manually. */
    if (n < 16) {
        if (n & 0x01) {
            *dst = *src;
            dst += 1;
            src += 1;
        }
        if (n & 0x02) {
            *(uint16_t *)dst = *(const uint16_t *)src;
            dst += 2;
            src += 2;
        }
        if (n & 0x04) {
            *(uint32_t *)dst = *(const uint32_t *)src;
            dst += 4;
            src += 4;
        }
        if (n & 0x08) {
            *(uint64_t *)dst = *(const uint64_t *)src;
        }
        return dst;
    }
 
    /* Special fast cases for <= 128 bytes */
    if (n <= 32) {
        mov16(dst, src);
        mov16(dst - 16 + n, src - 16 + n);
        return s1;
    }
    if (n <= 64) {
        mov32(dst, src);
        mov32(dst - 32 + n, src - 32 + n);
        return s1;
    }
    if (n <= 128) {
        mov64(dst, src);
        mov64(dst - 64 + n, src - 64 + n);
        return s1;
    }
 
    /*
     * For large copies > 128 bytes. This combination of 256, 64 and 16 byte
     * copies was found to be faster than doing 128 and 32 byte copies as
     * well.
     */
    for (; n >= 256; n -= 256, dst += 256, src += 256) {
        mov256(dst, src);
    }
 
    /*
     * We split the remaining bytes (which will be less than 256) into
     * 64byte (2^6) chunks.
     * Using incrementing integers in the case labels of a switch statement
     * enourages the compiler to use a jump table. To get incrementing
     * integers, we shift the 2 relevant bits to the LSB position to first
     * get decrementing integers, and then subtract.
     */
    switch (3 - (n >> 6)) {
    case 0x00:
        mov64(dst, src);
        n -= 64;
        dst += 64;
        src += 64;       /* fallthrough */
    case 0x01:
        mov64(dst, src);
        n -= 64;
        dst += 64;
        src += 64;       /* fallthrough */
    case 0x02:
        mov64(dst, src);
        n -= 64;
        dst += 64;
        src += 64;       /* fallthrough */
    default:
        ;
    }
 
    /*
     * We split the remaining bytes (which will be less than 64) into
     * 16byte (2^4) chunks, using the same switch structure as above.
     */
    switch (3 - (n >> 4)) {
    case 0x00:
        mov16(dst, src);
        n -= 16;
        dst += 16;
        src += 16;       /* fallthrough */
    case 0x01:
        mov16(dst, src);
        n -= 16;
        dst += 16;
        src += 16;       /* fallthrough */
    case 0x02:
        mov16(dst, src);
        n -= 16;
        dst += 16;
        src += 16;       /* fallthrough */
    default:
        ;
    }
 
    /* Copy any remaining bytes, without going beyond end of buffers */
    if (n != 0) {
        mov16(dst - 16 + n, src - 16 + n);
    }
    return s1;
}
 
uint8_t src[1024] = {0};
uint8_t dst[1024] = {0};
 
int main(int argc, char **argv)
{
    fast_memcpy(dst, src, 1024);
    return 0;
}
