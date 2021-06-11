#ifndef __RING_QUEUE__
#define __RING_QUEUE__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

union __type {
	char char_val;
	int int_val;
	float float_val;
	long long_val;
	double double_val;
	long long llong_val;
	void* buff;
};

struct __ring_queue {
	
	int __index_start;
	
	int __index_end;
	
	int __ring_size;
	
	union __type* __buff;
	
};

#define __CAS_TRY 3
#define __is_full(ringqueue) \
  (((ringqueue).__index_end + 1) % \
   (ringqueue).__ring_size == (ringqueue).__index_start)

#define __is_empty(ringqueue) \
  ((ringqueue).__index_start == (ringqueue).__index_end)

inline void __ring_queue_init(struct __ring_queue* ringqueue, int size) {

  if(ringqueue == NULL) {

      fprintf(stderr, "ringqueue == NULL\n");

      return;

  }



  ringqueue->__index_start = 0;

  ringqueue->__index_end = 0;

  ringqueue->__ring_size = size + 1;



  ringqueue->__buff = (union __type*)malloc(sizeof(union __type) * ringqueue->__ring_size);

  if(ringqueue->__buff == NULL) {

      perror(strerror(errno));

      ringqueue->__ring_size = 0;

    }

}

inline void __ring_queue_free(struct __ring_queue* ringqueue) {

  if(ringqueue != NULL && ringqueue->__buff != NULL) {

      free(ringqueue->__buff);

      ringqueue->__buff = NULL;

  }

  ringqueue->__index_start = 0;

  ringqueue->__index_end = 0;

  ringqueue->__ring_size = 0;

}

 

inline union __type __ring_queue_pop(struct __ring_queue* ringqueue) 
{

    union __type data = ringqueue->__buff[ringqueue->__index_start];

    ringqueue->__index_start = (ringqueue->__index_start + 1) % ringqueue->__ring_size;

    return data;
}

inline void __ring_queue_push(struct __ring_queue* ringqueue, union __type data) {

  ringqueue->__buff[ringqueue->__index_end] = data;

  ringqueue->__index_end = (ringqueue->__index_end + 1) % ringqueue->__ring_size;

}

inline int ring_queue_push_cas(struct __ring_queue* ringqueue, union __type data) {
	int i = 0;

	while(__is_full(*ringqueue)) 
	{
		if (++i == __CAS_TRY) 
		{
			return 0;
		}
	}

	__ring_queue_push(ringqueue, data);

	return 1;
}

 

inline int ring_queue_pop_cas(struct __ring_queue* ringqueue, union __type* data) {

	int i = 0;

	while(__is_empty(*ringqueue)) {

	if (++i == __CAS_TRY)
	{

          return 0;

    }

  }

  *data = __ring_queue_pop(ringqueue);

  return 1;

}

 

int main(int argc, char** argv) {

    struct __ring_queue ringqueue;

    __ring_queue_init(&ringqueue, 256);

 

    int i;

    union __type data = {0};

    for(i = 0; i < 257; i++) {

        if(__is_full(ringqueue)) {

            printf("%d, is full\n", i);

            break;

        }

 

        printf("%d, is not full\n", i);

        data.int_val = i + 1;

        __ring_queue_push(&ringqueue, data);

    }

 

    for(i = 0; i < 257; i++) {

        if(__is_empty(ringqueue)) {

            printf("%d, is empty\n", i);

            break;

        }

 

        printf("%d, %d\n", i, __ring_queue_pop(&ringqueue).int_val);

    }

 

    __ring_queue_free(&ringqueue);
	
	system("pause");

    return 0;

}

 

#endif
