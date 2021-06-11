/*
 * Copyright (c) 2000-2007 Niels Provos <provos@citi.umich.edu>
 * Copyright (c) 2007-2012 Niels Provos and Nick Mathewson
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#ifndef EVENT2_BUFFEREVENT_STRUCT_H_INCLUDED_
#define EVENT2_BUFFEREVENT_STRUCT_H_INCLUDED_

/** @file event2/bufferevent_struct.h

  Data structures for bufferevents.  Using these structures may hurt forward
  compatibility with later versions of Libevent: be careful!

  @deprecated Use of bufferevent_struct.h is completely deprecated; these
    structures are only exposed for backward compatibility with programs
    written before Libevent 2.0 that used them.
 */

#ifdef __cplusplus
extern "C" {
#endif

#include <event2/event-config.h>
#ifdef EVENT__HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#ifdef EVENT__HAVE_SYS_TIME_H
#include <sys/time.h>
#endif

/* For int types. */
#include <event2/util.h>
/* For struct event */
#include <event2/event_struct.h>

// 水位标志
struct event_watermark {
	size_t low;
	size_t high;
};

/**
  Shared implementation of a bufferevent.

  This type is exposed only because it was exposed in previous versions,
  and some people's code may rely on manipulating it.  Otherwise, you
  should really not rely on the layout, size, or contents of this structure:
  it is fairly volatile, and WILL change in future versions of the code.
**/
/*
* 数据缓冲bufferevent 在读取或者写入了足够量的数据之后调用用户提供的回调.
* bufferevent提供输入和输出缓冲区，可自动填充和排出.
* bufferevent的用户不再直接处理I / O，而是从输入读取并写入输出缓冲区.
* 启用读取时，bufferevent将自动尝试从文件描述符读取其输入缓冲区，并调用读取回调.
* 当启用写入时，bufferevent将自动尝试在输出缓冲区具有足够数据时将数据写入其文件描述符，
* 并在输出缓冲区充分耗尽时调用写入回调.
* 可查看bufferevent_sock.c中的：
*    bufferevent_socket_new() , bufferevent_readcb() ， bufferevent_writecb()
*/
struct bufferevent {
	/** Event base for which this bufferevent was created. */
	struct event_base *ev_base;
	/** Pointer to a table of function pointers to set up how this
	    bufferevent behaves. */
    // 操作结构体，成员是一些函数指针
	const struct bufferevent_ops *be_ops;

	/** A read event that triggers when a timeout has happened or a socket
	    is ready to read data.  Only used by some subtypes of
	    bufferevent. */
    // 监听同一个fd的可读事件
	struct event ev_read;
	/** A write event that triggers when a timeout has happened or a socket
	    is ready to write data.  Only used by some subtypes of
	    bufferevent. */
    // 监听同一个fd的可写事件
	struct event ev_write;

	/** An input buffer. Only the bufferevent is allowed to add data to
	    this buffer, though the user is allowed to drain it. */
    // 读缓冲区
	struct evbuffer *input;

	/** An input buffer. Only the bufferevent is allowed to drain data
	    from this buffer, though the user is allowed to add it. */
    // 写缓冲区
	struct evbuffer *output;

    /*
     *   读取低水位:读取操作使得输入缓冲区的数据量在此级别或者更高时,读取回调将被调用,
     *       默认值为0,所以每个读取操作都会导致读取回调被调用.
     *   读取高水位:输入缓冲区中的数据量达到此级别后, bufferevent 将停止读取,直到输
     *       入缓冲区中足够量的数据被抽取,使得数据量低于此级别。默认值是无限,所以永远不
     *       会因为输入缓冲区的大小而停止读取
     *   写入低水位:写入操作使得输出缓冲区的数据量达到或者低于此级别时,写入回调将被调用。
     *       默认值是0,所以只有输出缓冲区空的时候才会调用写入回调
     *   写入高水位:bufferevent 没有直接使用这个水位。它在 bufferevent 用作另外一个
     *       bufferevent 的底层传输端口时有特殊意义
    */
	struct event_watermark wm_read;
	struct event_watermark wm_write;

    // 可读、可写、错误发生时的回调函数指针
	bufferevent_data_cb readcb;
	bufferevent_data_cb writecb;
	/* This should be called 'eventcb', but renaming it would break
	 * backward compatibility */
	bufferevent_event_cb errorcb;
	void *cbarg;

    // 读、写事件event的超时值
	struct timeval timeout_read;
	struct timeval timeout_write;

	/** Events that are currently enabled: currently EV_READ and EV_WRITE
	    are supported. */
    // EV_READ 、EV_WRITE(默认）
	short enabled;
};

#ifdef __cplusplus
}
#endif

#endif /* EVENT2_BUFFEREVENT_STRUCT_H_INCLUDED_ */
