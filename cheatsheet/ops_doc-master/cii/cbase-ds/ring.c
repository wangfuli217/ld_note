/**
 * File: ring.c
 * Author: ZhuXindi
 * Date: 2017-12-22
 */

#include <ring.h>
#include <log.h>
#include <string.h>

struct ring *ring_create(struct ring *ring, size_t size)
{
	char *buf = malloc(size);

	if (!buf) {
		log_error("alloc ring space failed");
		return NULL;
	}

	ring->read = ring->write = ring->begin = buf;
	ring->end = buf + size;

	log_debug("create ring %p size=%lu begin/read/write=%p end=%p",
		  ring, size, ring->begin, ring->end);
	return ring;
}

void ring_destroy(struct ring *ring)
{
	log_debug("destroy ring %p", ring);
	free(ring->begin);
}

static inline void ring_push_data(struct ring *ring, char *dst,
				  const char *src, size_t len)
{
	memcpy(dst, src, len);
	log_debug("copy %lu bytes into ring %p @%s=%p",
		  len, ring, dst == ring->write ? "write" : "begin", dst);
}

size_t ring_push(struct ring *ring, const char *ptr, size_t len)
{
	if (len > ring_usable(ring))
		len = ring_usable(ring);

	if (ring->read <= ring->write) {
		size_t n = (size_t)(ring->end - ring->write);
		if (n >= len) {
			ring_push_data(ring, ring->write, ptr, len);
			ring->write += len;
		} else {
			ring_push_data(ring, ring->write, ptr, n);
			ring_push_data(ring, ring->begin, ptr + n, len - n);
			ring->write = ring->begin + len - n;
		}
	} else {
		ring_push_data(ring, ring->write, ptr, len);
		ring->write += len;
	}

	log_debug("ring %p new write=%p", ring, ring->write);
	return len;
}

static inline void ring_pop_data(struct ring *ring, char *dst,
				 const char *src, size_t len)
{
	memcpy(dst, src, len);
	log_debug("copy %lu bytes from ring %p @%s=%p",
		  len, ring, src == ring->read ? "read" : "begin", src);
}

size_t ring_pop(struct ring *ring, char *ptr, size_t len)
{
	if (len > ring_used(ring))
		len = ring_used(ring);

	if (ring->read >= ring->write) {
		size_t n = (size_t)(ring->end - ring->read);
		if (n >= len) {
			ring_pop_data(ring, ptr, ring->read, len);
			ring->read += len;
		} else {
			ring_pop_data(ring, ptr, ring->read, n);
			ring_pop_data(ring, ptr + n, ring->begin, len - n);
			ring->read = ring->begin + len - n;
		}
	} else {
		ring_pop_data(ring, ptr, ring->read, len);
		ring->read += len;
	}

	log_debug("ring %p new read=%p", ring, ring->read);
	if (ring->read == ring->write) {
		ring->read = ring->write = ring->begin;
		log_debug("all data poped from ring %p, reset read/write to begin=%p",
			  ring, ring->begin);
	}
	return len;
}
