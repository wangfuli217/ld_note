/**
 * 来源：来源：http://libevent.org/ libevent-1.4.14b-stable.tar.gz
 */

#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <assert.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>

#include "libevent_buffer.h"

/**
 * 创建evbuffer
 * @return
 */
struct evbuffer *evbuffer_new(void)
{
    struct evbuffer *buffer;

    buffer = calloc(1, sizeof(struct evbuffer));

    return (buffer);
}

/**
 * 释放evbuffer，包括evbuffer本身以及evbuffer中的orig_buffer
 * @param buffer
 */
void evbuffer_free(struct evbuffer *buffer)
{
    if (buffer->orig_buffer != NULL)
    {
        free(buffer->orig_buffer);
    }

    free(buffer);
}

/**
 * 用于交换两个缓冲区
 */
#define SWAP(x,y) do { \
	(x)->buffer = (y)->buffer; \
	(x)->orig_buffer = (y)->orig_buffer; \
	(x)->misalign = (y)->misalign; \
	(x)->totallen = (y)->totallen; \
	(x)->off = (y)->off; \
} while (0)

/**
* 重新排列缓冲区。注意：这是static函数，只供内部使用，不提供给用户使用
* @param buf
*/
static void evbuffer_align(struct evbuffer *buf)
{
    memmove(buf->orig_buffer, buf->buffer, buf->off);
    buf->buffer = buf->orig_buffer;
    buf->misalign = 0;
}

/**
 * 将一个缓冲区中的数据添加到另外一个缓冲区中，并清除原来缓冲区中的数据
 * @param outbuf
 * @param inbuf
 * @return
 */
int evbuffer_add_buffer(struct evbuffer *outbuf, struct evbuffer *inbuf)
{
    int res;

    // 如果要添加数据的缓冲区中没有数据
    if (outbuf->off == 0)
    {
        struct evbuffer tmp;
        size_t oldoff = inbuf->off;

        // 直接交换两个缓冲区，这样可以提高效率
        SWAP(&tmp, outbuf);
        SWAP(outbuf, inbuf);
        SWAP(inbuf, &tmp);

        // 调用回调函数通知缓冲区发生变化了
        if (inbuf->off != oldoff && inbuf->cb != NULL)
        {
            (*inbuf->cb)(inbuf, oldoff, inbuf->off, inbuf->cbarg);
        }
        if (oldoff && outbuf->cb != NULL)
        {
            (*outbuf->cb)(outbuf, 0, oldoff, outbuf->cbarg);
        }

        return (0);
    }

    res = evbuffer_add(outbuf, inbuf->buffer, inbuf->off);
    if (0 == res)
    {
        evbuffer_drain(inbuf, inbuf->off);
    }

    return (res);
}

/**
 * 用于实现evbuffer_add_vprintf()函数
 * @param buf
 * @param buflen
 * @param format
 * @param ap
 * @return
 */
int evbuffer_vsnprintf(char *buf, size_t buflen, const char *format, va_list ap)
{
    int r = vsnprintf(buf, buflen, format, ap); // 注意：vsnprintf()函数的返回值为格式化字符串后的长度，而不是保存到缓冲区中的字符串长度。可将返回值与buflen作比较来判断是否发生截断
    buf[buflen-1] = '\0';
    return r;
}

/**
 * 用于实现evbuffer_add_printf()函数。如果缓冲区无法容纳格式化后的字符串，该函数会自动扩容缓冲区，直到缓冲区可以容纳格式化后的所有字符串，而非进行截断
 * @param buf
 * @param fmt
 * @param ap
 * @return
 */
int evbuffer_add_vprintf(struct evbuffer *buf, const char *fmt, va_list ap) // 该函数不会像vsnprintf()函数那样可能发生截断
{
    char *buffer;
    size_t space;
    size_t oldoff = buf->off;
    int sz;
    va_list aq;

    evbuffer_expand(buf, 64);
    for (;;)
    {
        size_t used = buf->misalign + buf->off;
        buffer = (char *)buf->buffer + buf->off;
        assert(buf->totallen >= used);
        space = buf->totallen - used;

        va_copy(aq, ap);

        sz = evbuffer_vsnprintf(buffer, space, fmt, aq);

        va_end(aq);

        if (sz < 0)
        {
            return (-1);
        }

        // 如果缓冲区中的剩余空间足够存放格式化后的字符串
        if ((size_t)sz < space)
        {
            buf->off += sz;
            if (NULL != buf->cb)
            {
                (*buf->cb)(buf, oldoff, buf->off, buf->cbarg);
            }

            return (sz);
        }

        // 如果缓冲区中的剩余空间不够存放格式化后的字符串，则扩大缓冲区，重新格式化字符串到缓冲区中，直到格式化后的字符串可以存放到缓冲区中
        if (evbuffer_expand(buf, sz + 1) == -1)
        {
            return (-1);
        }
    }
}

/**
 * 格式化字符串到缓冲区中
 * @param buf
 * @param fmt
 * @param ...
 * @return
 */
int evbuffer_add_printf(struct evbuffer *buf, const char *fmt, ...)
{
    int res = -1;
    va_list ap;

    va_start(ap, fmt);
    res = evbuffer_add_vprintf(buf, fmt, ap);
    va_end(ap);

    return (res);
}

/**
 * 从缓冲区中读走datlen长度数据
 * @param buf
 * @param data
 * @param datlen
 * @return
 */
int evbuffer_remove(struct evbuffer *buf, void *data, size_t datlen)
{
    size_t nread = datlen;

    if (nread >= buf->off)
    {
        nread = buf->off;
    }

    memcpy(data, buf->buffer, nread);
    evbuffer_drain(buf, nread);

    return (nread);
}

/**
 * 读走缓冲区中以\r、\n、\r\n、\n\r为结尾的一行数据。注意：返回的缓冲区要使用free()函数释放空间
 * @param buffer
 * @return
 */
char *evbuffer_readline(struct evbuffer *buffer)
{
    u_char *data = EVBUFFER_DATA(buffer);
    size_t len = EVBUFFER_LENGTH(buffer);
    char *line;
    unsigned int i;

    for (i = 0; i < len; i++)
    {
        if ('\r' == data[i] || '\n' == data[i])
        {
            break;
        }
    }

    // 没有找到\r或者\n
    if (i == len)
    {
        return (NULL);
    }

    if (NULL == (line = malloc(i + 1)))
    {
        fprintf(stderr, "%s: out of memory\n", __func__);
        return (NULL);
    }

    memcpy(line, data, i);
    line[i] = '\0';

    // 判断\r或者\n后一个字符是否是\n或者\r，因为有的协议是以\r\n为结尾的
    if (i < len - 1)
    {
        char fch = data[i], sch = data[i+1];

        // 如果fch为\r，且sch为\n，或者fch为\n，且sch为\r，则将i后移一位
        if (('\r' == sch || '\n' == sch) && sch != fch )
        {
            i += 1;
        }
    }

    evbuffer_drain(buffer, i + 1);

    return (line);
}

/**
 * 以eol_style为行结尾符，读走一行数据。注意：行结尾符既不会拷贝到堆中并返回给客户，也不会留在缓冲区中，会直接丢弃
 * @param buffer
 * @param n_read_out：读走数据的长度
 * @param eol_style
 * @return：存有一行数据的堆空间地址，用户使用完毕后必须使用free()函数释放，即使该函数返回NULL，用户也可以使用free()函数释放
 */
char *evbuffer_readln(struct evbuffer *buffer, size_t *n_read_out,
                enum evbuffer_eol_style eol_style)
{
    unsigned char *data = EVBUFFER_DATA(buffer);
    unsigned char *start_of_eol, *end_of_eol;
    size_t len = EVBUFFER_LENGTH(buffer);
    char *line;
    unsigned int i, n_to_copy, n_to_drain;

    // 如果n_read_out不为0的话，必须将其置为0，因为在将n_read_out赋值之前，函数可能会提前退出，但保存在n_read_out的值并不是真正的读走的数据长度
    if (n_read_out)
    {
        *n_read_out = 0;
    }

    switch (eol_style)
    {
        case EVBUFFER_EOL_ANY:
            for (i = 0; i < len; i++)
            {
                if ('\r' == data[i]|| '\n' == data[i])
                {
                    break;
                }
            }
            if (i == len)
            {
                return (NULL);
            }

            start_of_eol = data+i;
            ++i;
            for ( ; i < len; i++)
            {
                if (data[i] != '\r' && data[i] != '\n')
                {
                    break;
                }
            }
            end_of_eol = data+i;
            break;
        case EVBUFFER_EOL_CRLF:
            end_of_eol = memchr(data, '\n', len);
            if (!end_of_eol)
            {
                return (NULL);
            }

            // \r\n
            if (end_of_eol > data && '\r' == *(end_of_eol-1))
            {
                start_of_eol = end_of_eol - 1;
            }
            // \n
            else
            {
                start_of_eol = end_of_eol;
            }
            end_of_eol++; /*point to one after the LF. */
            break;
        case EVBUFFER_EOL_CRLF_STRICT:
        {
            unsigned char *cp = data;
            // 查找第一个出现的\r\n
            while ((cp = memchr(cp, '\r', len-(cp-data))))
            {
                if (cp < data+len-1 && '\n' == *(cp+1))
                {
                    break;
                }

                if (++cp >= data+len)
                {
                    cp = NULL;
                    break;
                }
            }
            if (!cp)
            {
                return (NULL);
            }

            start_of_eol = cp;
            end_of_eol = cp+2;
            break;
        }
        case EVBUFFER_EOL_LF:
            start_of_eol = memchr(data, '\n', len);
            if (!start_of_eol)
            {
                return (NULL);
            }
            end_of_eol = start_of_eol + 1;
            break;
        default:
            return (NULL);
    }

    n_to_copy = start_of_eol - data;
    n_to_drain = end_of_eol - data;

    // 会多分配一个字节用于在结尾追加\0
    if (NULL == (line = malloc(n_to_copy+1)))
    {
        fprintf(stderr, "%s: out of memory\n", __func__);
        return (NULL);
    }

    memcpy(line, data, n_to_copy);
    line[n_to_copy] = '\0';

    evbuffer_drain(buffer, n_to_drain);
    if (n_read_out)
    {
        *n_read_out = (size_t)n_to_copy;
    }

    return (line);
}

/**
 * 添加数据
 * @param buf
 * @param data
 * @param datlen
 * @return
 */
int evbuffer_add(struct evbuffer *buf, const void *data, size_t datlen)
{
    size_t need = buf->misalign + buf->off + datlen;
    size_t oldoff = buf->off;

    if (buf->totallen < need)
    {
        if (evbuffer_expand(buf, datlen) == -1)
        {
            return (-1);
        }
    }

    // 执行到这里，说明缓冲区中off后面的剩余空间足够
    memcpy(buf->buffer + buf->off, data, datlen);
    buf->off += datlen;

    // 调用回调函数，用于通知缓冲区发生变化了
    if (datlen && buf->cb != NULL)
    {
        (*buf->cb)(buf, oldoff, buf->off, buf->cbarg);
    }

    return (0);
}

/**
 * 用于更新缓冲区的各个属性：buffer、misalign、off、prig_buffer等，一般在读走缓冲区数据后调用
 * @param buf
 * @param len
 */
void evbuffer_drain(struct evbuffer *buf, size_t len)
{
    size_t oldoff = buf->off;

    // 如果要读取的数据长度大于缓冲区中的数据长度
    if (len >= buf->off)
    {
        buf->off = 0;
        buf->buffer = buf->orig_buffer;
        buf->misalign = 0;
        goto done;
    }

    buf->buffer += len;
    buf->misalign += len;

    buf->off -= len;

    done:
    if (buf->off != oldoff && buf->cb != NULL)
    {
        (*buf->cb)(buf, oldoff, buf->off, buf->cbarg);
    }

}

/**
 * 清空缓冲区中的数据
 * @param buf
 */
void evbuffer_empty_data(struct evbuffer *buf)
{
    evbuffer_drain(buf, EVBUFFER_LENGTH(buf));
}

/**
 * 按需扩大缓冲区，即只有在需要的时候才会扩大缓冲区。如果需要扩大缓冲区的话，缓冲区大小至少为256个字节大小
 * @param buf
 * @param datlen
 * @return
 */
int evbuffer_expand(struct evbuffer *buf, size_t datlen)
{
    size_t need = buf->misalign + buf->off + datlen;

    // 如果不需要扩大缓冲区即可存放下新增数据，则直接返回0
    if (buf->totallen >= need)
    {
        return (0);
    }

    // 如果偏移量大于新增数据的长度，就重新排列缓冲区，这样缓冲区的剩余空间就有足够的空间存放新增数据了
    if (buf->misalign >= datlen)
    {
        evbuffer_align(buf);
    }
    else
    {
        void *newbuf;
        size_t length = buf->totallen;

        if (length < 256)
        {
            length = 256;
        }

        // 将length不断扩大2倍，直到不小于need
        while (length < need)
        {
            length <<= 1;
        }

        // 先重新排列缓冲区
        if (buf->orig_buffer != buf->buffer)
        {
            evbuffer_align(buf);
        }

        // 重新分配空间
        if ((newbuf = realloc(buf->buffer, length)) == NULL)
        {
            return (-1);
        }

        // 下面这条语句必不可少，因为如果在buf->buffer后面没有足够的空闲空间的话，realloc()函数会重新找一块足够大的空闲空间分配空间
        buf->orig_buffer = buf->buffer = newbuf;
        buf->totallen = length;
    }

    return (0);
}

/**
 * 设置回调函数和回调函数所需要的参数
 * @param buffer
 * @param cb
 * @param cbarg
 */
void evbuffer_setcb(struct evbuffer *buffer,
                    void (*cb)(struct evbuffer *, size_t, size_t, void *),
                    void *cbarg)
{
    buffer->cb = cb;
    buffer->cbarg = cbarg;
}

/**
 * 从文件描述符fd中读取数据并保存到缓冲区中
 * @param buf
 * @param fd
 * @param howmuch：可以为负数，当为负数时，evbuffer_read()函数自己决定读多少字节数据
 * @return
 */
int evbuffer_read(struct evbuffer *buf, int fd, int howmuch)
{
    unsigned char *p;
    size_t oldoff = buf->off;
    int n = EVBUFFER_MAX_READ;

    // 获取fd中可读取数据的字节数，并保存在变量n中
	if (-1 == ioctl(fd, FIONREAD, &n) || n <= 0)
	{
		n = EVBUFFER_MAX_READ;
	}
	// 下面代码用于，当howmuch为负数(即用户没有告诉要读多少字节数据)，且fd中有大量数据可读时(大于EVBUFFER_MAX_READ)，将要读取的数据长度截断为max(EVBUFFER_MAX_READ, (buf->totallen << 2))
	else if (n > EVBUFFER_MAX_READ && n > howmuch)
    {
	    // 如果可读取的数据长度大于缓冲区整个长度的4倍
		if ((size_t)n > (buf->totallen << 2))
        {
            n = (buf->totallen << 2);
        }

		// 如果可读取的数据长度大于缓冲区整个长度的4倍，但缓冲区整个长度的4倍小于EVBUFFER_MAX_READ
		if (n < EVBUFFER_MAX_READ)
        {
            n = EVBUFFER_MAX_READ;
        }
	}

    if (howmuch < 0 || howmuch > n)
    {
        howmuch = n;
    }

    if (-1 == evbuffer_expand(buf, howmuch))
    {
        return (-1);
    }

    p = buf->buffer + buf->off;

    n = read(fd, p, howmuch);

    if (-1 == n)
    {
        return (-1);
    }

    if (0 == n)
    {
        return (0);
    }

    buf->off += n;


    if (buf->off != oldoff && NULL != buf->cb)
    {
        (*buf->cb)(buf, oldoff, buf->off, buf->cbarg);
    }

    return (n);
}

/**
 * 将缓冲区中的数据读走并写入文件描述符fd中
 * @param buffer
 * @param fd
 * @return
 */
int evbuffer_write(struct evbuffer *buffer, int fd)
{
    int n;

    n = write(fd, buffer->buffer, buffer->off);

    if (-1 == n)
    {
        return (-1);
    }

    if (0 == n)
    {
        return (0);
    }

    evbuffer_drain(buffer, n);

    return (n);
}

/**
 * 从缓冲区中查找以what为起始地址，长度为len的数据
 * @param buffer
 * @param what
 * @param len
 * @return
 */
unsigned char *evbuffer_find(struct evbuffer *buffer, const unsigned char *what, size_t len)
{
    unsigned char *search = buffer->buffer, *end = search + buffer->off;
    unsigned char *p;

    // 从search所指内存区域的前end-search个字节中查找第一次出现*what的位置
    while (search < end &&
           NULL != (p = memchr(search, *what, end - search))) // 这里使用的是memchr，而不是strchr，是因为存放在缓冲区中的数据并不一定是字符串(strchr在遇到\0会停止，而memchr则不会)，即该缓冲区是二进制安全的
    {
        if (p + len > end)
        {
            break;
        }

        if (0 == memcmp(p, what, len))
        {
            return (p);
        }

        search = p + 1;
    }

    return (NULL);
}

#if 0
#define LIBEVENT_BUFFER_TEST_MAIN
#endif

static void test_evbuffer(void)
{
    struct evbuffer *evb = evbuffer_new();

    evbuffer_add_printf(evb, "%s/%d", "hello", 1);

    assert(7 == EVBUFFER_LENGTH(evb));
    printf("evb->totlen = %d\n", evb->totallen); // 256
    assert(0 == strcmp(EVBUFFER_DATA(evb), "hello/1"));

    evbuffer_free(evb);
}

static void test_evbuffer_readln(void)
{
    struct evbuffer *evb = evbuffer_new();
    struct evbuffer *evb_tmp = evbuffer_new();
    const char *s;
    char *cp = NULL;
    size_t sz;

#define tt_line_eq(content) \
    do \
    { \
        if (!cp || strlen(content) != sz || strcmp(cp, content)) \
        { \
            fprintf(stdout, "FAILED\n"); \
            exit(1); \
        } \
    } while(0)

    // Test EOL ANY
    fprintf(stdout, "Testing evbuffer_readln EOF_ANY: ");

    s = "complex silly newline\r\n\n\r\n\n\rmore\0\n";
    evbuffer_add(evb, s, strlen(s) + 2); // +2的原因是，strlen()函数只会计算到\0，会忽略结尾的\0和\n
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_ANY);
    tt_line_eq("complex silly newline");
    free(cp); // 注意：使用完毕后必须使用free()函数释放

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_ANY);
    if (!cp || 5 != sz || memcmp(cp, "more\0\0", 6)) // 注意：因为cp中包含\0(不是字符串结尾的\0)，这里使用的是memcmp，而不是strcmp
    {
        fprintf(stdout, "FAILED\n");
        exit(1);
    }
    if (0 == evb->totallen)
    {
        fprintf(stdout, "FAILED\n");
        exit(1);
    }
    printf("evb->totalen = %d\n", evb->totallen); // 256
    s = "\nno newline";
    evbuffer_add(evb, s, strlen(s));
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_ANY);
    tt_line_eq("");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_ANY); // cp为NULL
    assert(!cp);
    evbuffer_drain(evb, EVBUFFER_LENGTH(evb)); // 清空缓冲区中的数据
    assert(0 == EVBUFFER_LENGTH(evb));

    fprintf(stdout, "OK\n");

    /* Test EOL_CRLF */
    fprintf(stdout, "Testing evbuffer_readln EOL_CRLF: ");

    s = "Line with\rin the middle\nLine with good crlf\r\n\nfinal\n";
    evbuffer_add(evb, s, strlen(s));
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF);
    tt_line_eq("Line with\rin the middle");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF);
    tt_line_eq("Line with good crlf");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF);
    tt_line_eq("");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF);
    tt_line_eq("final");
    s = "x";
    evbuffer_add(evb, s, 1);
    free(cp);
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF);
    assert(!cp);
    // 注意：这里没有free(cp);

    fprintf(stdout, "OK\n");

    /* Test CRLF_STRICT */
    fprintf(stdout, "Testing evbuffer_readln CRLF_STRICT: ");

    s = " and a bad crlf\nand a good one\r\n\r\nMore\r";
    evbuffer_add(evb, s, strlen(s));
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    tt_line_eq("x and a bad crlf\nand a good one");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    tt_line_eq("");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    assert(!cp);

    evbuffer_add(evb, "\n", 1);
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    tt_line_eq("More");
    free(cp);
    assert(0 == EVBUFFER_LENGTH(evb));

    s = "An internal CR\r is not an eol\r\nNor is a lack of one";
    evbuffer_add(evb, s, strlen(s));
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    tt_line_eq("An internal CR\r is not an eol");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    assert(!cp);

    evbuffer_add(evb, "\r\n", 2);
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    tt_line_eq("Nor is a lack of one");
    free(cp);
    assert(0 == EVBUFFER_LENGTH(evb));

    fprintf(stdout, "OK\n");

    /* Test LF */
    fprintf(stdout, "Testing evbuffer_readln LF: ");

    s = "An\rand a nl\n\nText";
    evbuffer_add(evb, s, strlen(s));

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_LF);
    tt_line_eq("An\rand a nl");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_LF);
    tt_line_eq("");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_LF);
    assert(!cp);
    free(cp);

    evbuffer_add(evb, "\n", 1);
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_LF);
    tt_line_eq("Text");
    free(cp);

    fprintf(stdout, "OK\n");

    /* Test CRLF_STRICT - across boundaries */
    fprintf(stdout, "Testing evbuffer_readln CRLF_STRICT across boundaries: ");

    s = " and a bad crlf\nand a good one\r";
    evbuffer_add(evb_tmp, s, strlen(s));
    evbuffer_add_buffer(evb, evb_tmp);
    s = "\n\r";
    evbuffer_add(evb_tmp, s, strlen(s));
    evbuffer_add_buffer(evb, evb_tmp);
    s = "\nMore\r";
    evbuffer_add(evb_tmp, s, strlen(s));
    evbuffer_add_buffer(evb, evb_tmp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    tt_line_eq(" and a bad crlf\nand a good one");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    tt_line_eq("");
    free(cp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    assert(!cp);
    free(cp); // free(NULL);不会有问题

    evbuffer_add(evb, "\n", 1);
    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_CRLF_STRICT);
    tt_line_eq("More");
    free(cp);
    cp = NULL;

    if (0 != EVBUFFER_LENGTH(evb))
    {
        fprintf(stdout, "FAILED\n");
        exit(1);
    }

    fprintf(stdout, "OK\n");

    /* Test memory problem */
    fprintf(stdout, "Testing evbuffer_readln memory problem: ");

    s = "one line\ntwo line\nblue line";
    evbuffer_add(evb_tmp, s, strlen(s));
    evbuffer_add_buffer(evb, evb_tmp);

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_LF);
    tt_line_eq("one line");
    free(cp);
    cp = NULL;

    cp = evbuffer_readln(evb, &sz, EVBUFFER_EOL_LF);
    tt_line_eq("two line");
    free(cp);
    cp = NULL;

    printf("evb->totlen = %d, evb_tmp = %d\n", evb->totallen, evb_tmp->off); // 256 0
    fprintf(stdout, "OK\n");

    evbuffer_free(evb);
    evbuffer_free(evb_tmp);
}

static void test_evbuffer_find(void)
{
    unsigned char *p;
    const char* test1 = "1234567890\r\n";
    const char* test2 = "1234567890\r";
#define EVBUFFER_INITIAL_LENGTH 256
    char test3[EVBUFFER_INITIAL_LENGTH];
    unsigned int i;
    struct evbuffer *buf = evbuffer_new();

    /* make sure evbuffer_find doesn't match past the end of the buffer */
    fprintf(stdout, "Testing evbuffer_find 1: ");

    evbuffer_add(buf, (unsigned char*)test1, strlen(test1)); // 注意：这里之所以将test1强制类型转换为unsigned char*，是因为缓冲区中保存的是二进制安全的数据，并非只能保存字符串
    evbuffer_drain(buf, strlen(test1));
    evbuffer_add(buf, (unsigned char*)test2, strlen(test2));
    p = evbuffer_find(buf, (unsigned char*)"\r\n", 2);
    if (NULL == p)
    {
        fprintf(stdout, "OK\n");
    }
    else
    {
        fprintf(stdout, "FAILED\n");
        exit(1);
    }

    /*
	 * drain the buffer and do another find; in r309 this would
	 * read past the allocated buffer causing a valgrind error.
	 */
    fprintf(stdout, "Testing evbuffer_find 2: ");

    evbuffer_drain(buf, strlen(test2));
    for (i = 0; i < EVBUFFER_INITIAL_LENGTH; ++i)
    {
        test3[i] = 'a';
    }
    test3[EVBUFFER_INITIAL_LENGTH - 1] = 'x';
    evbuffer_add(buf, (unsigned char*)test3, EVBUFFER_INITIAL_LENGTH);
    p = evbuffer_find(buf, (unsigned char*)test3, EVBUFFER_INITIAL_LENGTH);
    p = evbuffer_find(buf, (unsigned char*)"xy", 2);
    if (NULL == p)
    {
        printf("OK\n");
    }
    else
    {
        fprintf(stdout, "FIALED\n");
        exit(1);
    }

    /* simple test for match at end of allocated buffer */
    fprintf(stdout, "Testing evbuffer_find 3: ");

    p = evbuffer_find(buf, (unsigned char*)"ax", 2);
    if (NULL != p && 0 == strncmp((char*)p, "ax", 2))
    {
        printf("OK\n");
    }
    else
    {
        fprintf(stdout, "FAILED\n");
        exit(1);
    }

    evbuffer_free(buf);
}

int main()
{
//    test_evbuffer();
//    test_evbuffer_readln();
    test_evbuffer_find();
    return 0;
}
