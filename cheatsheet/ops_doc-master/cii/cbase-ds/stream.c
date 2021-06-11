/**
 * File: stream.c
 * Author: ZhuXindi
 * Date: 2014-04-22
 */

#include <stream.h>
#include <buffer.h>
#include <log.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

static inline struct buffer *stream_get_rdbuf(struct stream *stream)
{
	struct buffer *b;

	/* search in the read queue try to find a buffer with free space */
	if (!list_empty(&stream->read_queue)) {
		b = list_last_entry(&stream->read_queue, struct buffer, list);
		if (b->tail != b->end)
			return b;
	}

	/* no free buffer in the queue then allocate a new one */
	b = buffer_create(stream->rdbuf_size, stream->pool);
	if (b)
		list_add_tail(&b->list, &stream->read_queue);
	return b;
}

static void stream_read_queue(struct stream *stream)
{
	size_t total = 0; /* total read bytes during current calling */

	while (1) {
		struct buffer *b;
		ssize_t rc;

		/* get a free buffer */
		b = stream_get_rdbuf(stream);
		if (!b)
			break;

		/* read data from fd */
		rc = read(stream->fd, b->tail, b->end - b->tail);
		if (rc == -1) {
			/* error occured */
			if (errno != EWOULDBLOCK) {
				log_error("read() error: %s", strerror(errno));
				stream->error = 1;
			/* no more data */
			} else
				stream->readable = 0;
			break;

		/* got eof */
		} else if (rc == 0) {
			log_debug("stream %p read eof", stream);
			stream->closed = 1;
			break;
		}

		/* adjust next read position */
		b->tail += rc;
		total += rc;
	}

	if (total)
		log_debug("stream %p totally read %lu bytes", stream, total);
}

static void stream_write_queue(struct stream *stream)
{
	size_t total = 0; /* total written bytes during current calling */
	struct buffer *b, *n;

	list_for_each_entry_safe(b, n, &stream->write_queue, list) {
		ssize_t rc;

		if (b->tail > b->data) {
			/* write data to fd */
			rc = write(stream->fd, b->data, b->tail - b->data);
			if (rc == -1) {
				/* error occured */
				if (errno != EWOULDBLOCK) {
					log_error("write() error: %s",
						  strerror(errno));
					stream->error = 1;
				/* no more data */
				} else
					stream->writable = 0;
				break;
			}

			/* adjust next write position */
			b->data += rc;
			total += rc;
		}

		/* if no more data in the buffer than free it */
		if (b->data == b->tail)
			buffer_release(b);
	}

	if (total)
		log_debug("stream %p totally wrote %lu bytes", stream, total);
}

static void stream_read_handler(struct stream *stream)
{
	/* check stream status */
	if (stream->error || stream->closed)
		return;

	log_debug("stream %p is readable", stream);

	/* read data to the queue */
	stream->readable = 1;
	stream_read_queue(stream);
}

static void stream_write_handler(struct stream *stream)
{
	/* check stream status */
	if (stream->error)
		return;

	log_debug("stream %p is writable", stream);

	/* write data from the queue */
	stream->writable = 1;
	stream_write_queue(stream);
}

void stream_init(struct stream *stream, int type, size_t rdbuf_size,
		 struct pool *pool)
{
	log_debug("init stream %p rdbuf_size %lu", stream, rdbuf_size);

	/* set status */
	stream->fd = -1;
	stream->type = type;
	stream->error = 0;
	stream->closed = 0;
	stream->readable = 0;
	stream->writable = 0;
	stream->rdbuf_size = rdbuf_size;
	stream->pool = pool;

	/* init read event */
	memset(&stream->rev, 0, sizeof(stream->rev));
	stream->rev.fd = -1;
	stream->rev.type = EVENT_T_READ;
	stream->rev.handler = (event_handler)stream_read_handler;
	stream->rev.data = stream;
	stream->rev.buddy = &stream->wev;

	/* init write event */
	memset(&stream->wev, 0, sizeof(stream->wev));
	stream->wev.fd = -1;
	stream->wev.type = EVENT_T_WRITE;
	stream->wev.handler = (event_handler)stream_write_handler;
	stream->wev.data = stream;
	stream->wev.buddy = &stream->rev;

	/* init two queues */
	INIT_LIST_HEAD(&stream->read_queue);
	INIT_LIST_HEAD(&stream->write_queue);
}

int stream_attach_fd(struct stream *stream, int fd)
{
	if (stream->fd == -1) {
		log_debug("attach fd %d to stream %p", fd, stream);
		stream->fd = fd;

		/* add read event */
		if (stream->type & STREAM_T_RD) {
			stream->rev.fd = fd;
			event_add(&stream->rev);
		}

		/* add write event */
		if (stream->type & STREAM_T_WR) {
			stream->wev.fd = fd;
			event_add(&stream->wev);
		}

		return 0;
	}

	log_error("stream %p already attached fd %d", stream, stream->fd);
	return -1;
}

void stream_detach(struct stream *stream)
{
	if (stream->fd != -1) {
		log_debug("detach stream %p", stream);

		/* delete events */
		event_del(&stream->rev);
		event_del(&stream->wev);
		stream->rev.fd = stream->wev.fd = stream->fd = -1;

		/* clear status */
		stream->error = 0;
		stream->closed = 0;
		stream->readable = 0;
		stream->writable = 0;

		/* clear data in the two queues */
		buffer_release_chain(&stream->read_queue);
		buffer_release_chain(&stream->write_queue);
	}
}

int stream_write(struct stream *stream, struct list_head *head)
{
	/* check stream status */
	if (stream->error) {
		log_error("stream %p has error", stream);
		return -1;
	}

	/* join head to the write queue */
	list_splice_tail_init(head, &stream->write_queue);

	/* if the stream is writable then write at once */
	if (stream->writable)
		stream_write_queue(stream);
	return 0;
}

int stream_read(struct stream *stream, struct list_head *head)
{
	/* check stream status */
	if (stream->error || stream->closed) {
		if (stream->error)
			log_error("stream %p has error", stream);
		return -1;
	}

	/* if the stream is readable then read at once */
	if (stream->readable)
		stream_read_queue(stream);

	/* join the read queue to head */
	list_splice_tail_init(&stream->read_queue, head);
	return 0;
}
