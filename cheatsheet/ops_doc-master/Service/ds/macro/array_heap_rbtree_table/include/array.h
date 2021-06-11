/*
 * array.h - Variable length arrays
 *
 * Copyright 2017 Eric Chai <electromatter@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef ARR_H
#define ARR_H

#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define ARR_MIN_COUNT			(8)
#define ARR_GROWTH(used)		((used) * 2)

#define ARR_DEF(name, elem_t)						\
struct name {								\
	elem_t *base, *left, *right, *end;				\
}

#define ARR_INITIALIZER		{NULL, NULL, NULL, NULL}

#define ARR_INIT(arr)							\
	do {								\
		(arr)->base = NULL;					\
		(arr)->left = NULL;					\
		(arr)->right = NULL;					\
		(arr)->end = NULL;					\
	} while(0)

#define ARR_CLEAR(arr)							\
	do {								\
		free(arr->base);					\
		ARR_INIT(arr);						\
	} while (0)

#define ARR_LEFT(arr)		((arr)->left)
#define ARR_RIGHT(arr)		((arr)->right)

#define ARR_LENGTH(arr)		(ARR_RIGHT((arr)) - ARR_LEFT((arr)))

#define ARR_SPACE_LEFT(arr)	((arr)->left - (arr)->base)
#define ARR_SPACE_RIGHT(arr)	((arr)->end - (arr)->right)

static inline int arr_do_expand(
		void **base, void **left, void **right, void **end,
		size_t count,
		size_t reserve_left, size_t reserve_right, size_t elem_size)
{
	size_t min_count, new_count, offset;
	char *new_base, *new_left;

	min_count = ARR_GROWTH(reserve_left + count + reserve_right);
	new_count = ARR_MIN_COUNT;
	while (new_count < min_count)
		new_count *= 2;

	new_base = malloc(new_count * elem_size);
	if (!new_base)
		return 1;

	offset = (new_count - count) / 2;
	new_left = new_base + reserve_left + offset * elem_size;
	memcpy(new_left, *left, count * elem_size);
	free(*base);

	*base = new_base;
	*left = new_left;
	*right = new_left + count * elem_size;
	*end = new_base + new_count * elem_size;
	return 0;
}

#define ARR_EXPAND(arr, reserve_left, reserve_right)			\
	(ARR_SPACE_LEFT((arr)) >= (reserve_left) &&			\
			ARR_SPACE_RIGHT((arr)) >= (reserve_right) ?	\
		0 : arr_do_expand(					\
				(void **)&(arr)->base,			\
				(void **)&(arr)->left,			\
				(void **)&(arr)->right,			\
				(void **)&(arr)->end,			\
				ARR_LENGTH((arr)),			\
				(reserve_left),				\
				(reserve_right),			\
				sizeof(*(arr)->base)))

#define ARR_RESERVE_LEFT(arr, count)					\
	(ARR_EXPAND((arr), (count), 0) ? NULL : ARR_LEFT((arr)))
#define ARR_RESERVE_RIGHT(arr, count)					\
	(ARR_EXPAND((arr), 0, (count)) ? NULL : ARR_RIGHT((arr)))

#define ARR_CONSUME_LEFT(arr, count)					\
	do {								\
		assert(ARR_LENGTH((arr)) >= (count));			\
		(arr)->left += (count);					\
	} while (0)

#define ARR_CONSUME_RIGHT(arr)						\
	do {								\
		assert(ARR_LENGTH((arr)) >= (count));			\
		(arr)->right -= (count);				\
	} while (0)

#define ARR_PRODUCE_LEFT(arr, count)					\
	do {								\
		assert(ARR_SPACE_LEFT((arr) >= (count));		\
		(arr)->left -= (count);					\
	} while (0)

#define ARR_PRODUCE_RIGHT(arr, count)					\
	do {								\
		assert(ARR_SPACE_RIGHT((arr)) >= (count));		\
		(arr)->right += (count);				\
	} while (0)

#define ARR_SLICE(arr, left, right)					\
	do {								\
		if (ARR_LENGTH((arr)) >= (right))			\
			(arr)->right = (arr)->left + (right);		\
		if (ARR_LENGTH((arr)) < left) {				\
			(arr)->left += (left);				\
		} else {						\
			clear((arr);					\
		}							\
	} while (0)

#define ARR_SUB(arr, off, len)	(ARR_SLICE((arr), (left), (left) + (right)))

#endif
