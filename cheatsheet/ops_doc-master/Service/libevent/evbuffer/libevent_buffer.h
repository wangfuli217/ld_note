/**
 * 来源：http://libevent.org/ libevent-1.4.14b-stable.tar.gz
 */

#ifndef __LIBEVENT_BUFFER_H
#define __LIBEVENT_BUFFER_H

#include <sys/types.h>

#define EVBUFFER_LENGTH(x)	(x)->off
#define EVBUFFER_DATA(x)	(x)->buffer
#define EVBUFFER_INPUT(x)	(x)->input
#define EVBUFFER_OUTPUT(x)	(x)->output

#define EVBUFFER_MAX_READ	4096

/** Used to tell evbuffer_readln what kind of line-ending to look for.
 */
enum evbuffer_eol_style
{
    /** Any sequence of CR and LF characters is acceptable as an EOL. */
            EVBUFFER_EOL_ANY, // 任意数量连续的\r和\n，比如\r、\n、\r\r、\n\n、\r\n、\n\r等
    /** An EOL is an LF, optionally preceded by a CR.  This style is
     * most useful for implementing text-based internet protocols. */
            EVBUFFER_EOL_CRLF, // \n或者\r\n
    /** An EOL is a CR followed by an LF. */
            EVBUFFER_EOL_CRLF_STRICT, // \r\n
    /** An EOL is a LF. */
            EVBUFFER_EOL_LF // \n
};

///     |<-----------------------totallen------------------------>|
///
///     +-------------------+------------------+------------------+
///     |      misalign     |        off       |                  |
///     |                   |     (CONTENT)    |                  |
///     +-------------------+------------------+------------------+
///    /\                  /\
/// orig_buffer          buffer
///
struct evbuffer
{
    unsigned char *buffer; // 数据起始地址
    unsigned char *orig_buffer; // buffer起始地址

    size_t misalign; // 数据起始地址与buffer起始地址的偏移量
    size_t totallen; // buffer总长度
    size_t off; // 数据长度

    void (*cb)(struct evbuffer *, size_t, size_t, void *); // 回调函数，用于TODO
    void *cbarg; // 传递给回调函数的参数
};

/**
 * 初始状态
 */
///             |<-----------------------totallen------------------------>|
///
///             +-------------------+------------------+------------------+
///             |misalign=0                                               |
///             |off=0                                                    |
///             +-------------------+------------------+------------------+
///            /\
/// orig_buffer buffer
///

/**
 * 添加数据
 */
///             |<-----------------------totallen------------------------>|
///
///             +-------------------+------------------+------------------+
///             |misalign=0         |                                     |
///             |         off       |                                     |
///             |      (CONTENT)    |                                     |
///             +-------------------+------------------+------------------+
///            /\
/// orig_buffer buffer
///

/**
 * 读取数据
 */
///     |<-----------------------totallen------------------------>|
///
///     +-------------------+------------------+------------------+
///     |      misalign     |        off       |                  |
///     |                   |     (CONTENT)    |                  |
///     +-------------------+------------------+------------------+
///    /\                  /\
/// orig_buffer          buffer
///

/**
  Allocate storage for a new evbuffer.

  @return a pointer to a newly allocated evbuffer struct, or NULL if an error
          occurred
 */
struct evbuffer *evbuffer_new(void);

/**
  Deallocate storage for an evbuffer.

  @param pointer to the evbuffer to be freed
 */
void evbuffer_free(struct evbuffer *buffer);

/**
  Expands the available space in an event buffer.

  Expands the available space in the event buffer to at least datlen

  @param buf the event buffer to be expanded
  @param datlen the new minimum length requirement
  @return 0 if successful, or -1 if an error occurred
*/
int evbuffer_expand(struct evbuffer *buf, size_t datlen);

/**
 * 将一个缓冲区中的数据添加到另外一个缓冲区中，并清除原来缓冲区中的数据
 * @param outbuf
 * @param inbuf
 * @return
 */
int evbuffer_add_buffer(struct evbuffer *outbuf, struct evbuffer *inbuf);

/**
 * 清空缓冲区中的数据
 * @param buf
 */
void evbuffer_empty_data(struct evbuffer *buf);

/**
  Append a va_list formatted string to the end of an evbuffer.

  @param buf the evbuffer that will be appended to
  @param fmt a format string
  @param ap a varargs va_list argument array that will be passed to vprintf(3)
  @return The number of bytes added if successful, or -1 if an error occurred.
 */
int evbuffer_add_vprintf(struct evbuffer *buf, const char *fmt, va_list ap);

/**
  Append a formatted string to the end of an evbuffer.

  @param buf the evbuffer that will be appended to
  @param fmt a format string
  @param ... arguments that will be passed to printf(3)
  @return The number of bytes added if successful, or -1 if an error occurred.
 */
int evbuffer_add_printf(struct evbuffer *buf, const char *fmt, ...);

/**
  Read data from an event buffer and drain the bytes read.

  @param buf the event buffer to be read from
  @param data the destination buffer to store the result
  @param datlen the maximum size of the destination buffer
  @return the number of bytes read
 */
int evbuffer_remove(struct evbuffer *buf, void *data, size_t datlen);

/**
 * Read a single line from an event buffer.
 *
 * Reads a line terminated by either '\r\n', '\n\r' or '\r' or '\n'.
 * The returned buffer needs to be freed by the caller.
 *
 * @param buffer the evbuffer to read from
 * @return pointer to a single line, or NULL if an error occurred
 */
char *evbuffer_readline(struct evbuffer *buffer);

/**
 * Read a single line from an event buffer.
 *
 * Reads a line terminated by an EOL as determined by the evbuffer_eol_style
 * argument.  Returns a newly allocated nul-terminated string; the caller must
 * free the returned value.  The EOL is not included in the returned string.
 *
 * @param buffer the evbuffer to read from
 * @param n_read_out if non-NULL, points to a size_t that is set to the
 *       number of characters in the returned string.  This is useful for
 *       strings that can contain NUL characters.
 * @param eol_style the style of line-ending to use.
 * @return pointer to a single line, or NULL if an error occurred
 */
char *evbuffer_readln(struct evbuffer *buffer, size_t *n_read_out,
                      enum evbuffer_eol_style eol_style);

/**
  Append data to the end of an evbuffer.

  @param buf the event buffer to be appended to
  @param data pointer to the beginning of the data buffer
  @param datlen the number of bytes to be copied from the data buffer
 */
int evbuffer_add(struct evbuffer *buf, const void *data, size_t datlen);

/**
  Remove a specified number of bytes data from the beginning of an evbuffer.

  @param buf the evbuffer to be drained
  @param len the number of bytes to drain from the beginning of the buffer
 */
void evbuffer_drain(struct evbuffer *buf, size_t len);

/**
  Set a callback to invoke when the evbuffer is modified.

  @param buffer the evbuffer to be monitored
  @param cb the callback function to invoke when the evbuffer is modified
  @param cbarg an argument to be provided to the callback function
 */
void evbuffer_setcb(struct evbuffer *buffer,
                    void (*cb)(struct evbuffer *, size_t, size_t, void *),
                    void *cbarg);

/**
  Read from a file descriptor and store the result in an evbuffer.

  @param buf the evbuffer to store the result
  @param fd the file descriptor to read from
  @param howmuch the number of bytes to be read
  @return the number of bytes read, or -1 if an error occurred
  @see evbuffer_write()
 */
int evbuffer_read(struct evbuffer *buf, int fd, int howmuch);

/**
  Write the contents of an evbuffer to a file descriptor.

  The evbuffer will be drained after the bytes have been successfully written.

  @param buffer the evbuffer to be written and drained
  @param fd the file descriptor to be written to
  @return the number of bytes written, or -1 if an error occurred
  @see evbuffer_read()
 */
int evbuffer_write(struct evbuffer *buffer, int fd);

/**
  Find a string within an evbuffer.

  @param buffer the evbuffer to be searched
  @param what the string to be searched for
  @param len the length of the search string
  @return a pointer to the beginning of the search string, or NULL if the search failed.
 */
unsigned char *evbuffer_find(struct evbuffer *buffer, const unsigned char *what, size_t len);

#endif // __LIBEVENT_BUFFER_H
