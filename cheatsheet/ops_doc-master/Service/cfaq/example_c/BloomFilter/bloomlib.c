//
// Copyright Stanislav Seletskiy <s.seletskiy@gmail.com>
//

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <inttypes.h>
#include <math.h>
#include <assert.h>

#include "bloomlib.h"

#define FALSE 0
#define TRUE  1

typedef unsigned int     uint;

bf_t* bf_create(
	double error, bf_index_t est_key_count,
	bf_index_t (*hash_func)(char*, uint))
{
	bf_t* filter = (bf_t*)malloc(sizeof(bf_t));
	assert(filter != NULL);

	filter->bits_count = (bf_index_t)ceil(- (double)est_key_count * log(error) / BF_LOG2_2);

	filter->bytes_count = (bf_index_t)ceil(filter->bits_count / 8.);
	filter->bitmap = (bf_bitmap_t*)malloc(sizeof(bf_bitmap_t) * filter->bytes_count);
	memset(filter->bitmap, 0, filter->bytes_count);
	filter->hash_func = hash_func;
	filter->hashes_count = (bf_index_t)ceil(filter->bits_count / est_key_count * BF_LOG2);
	filter->error_rate = error;
	filter->bits_used = 0;

	assert(filter->bitmap != NULL);
	assert(filter->hash_func != NULL);

	return filter;
}


bf_index_t bf_get_index(
	bf_t* filter,
	const char* key, uint key_len, uint hash_index)
{
	char buffer[BF_KEY_BUFFER_SIZE] = { 0 };

	memcpy(buffer, key, key_len);
	sprintf(buffer + key_len, "%03d", hash_index);

	bf_index_t index = filter->hash_func(buffer, key_len + 3);

	return index % filter->bits_count;
}


void bf_add(bf_t* filter, const char* key, uint key_len)
{
	int hash_index = 0;

	assert(key_len + filter->hashes_count / 10 + 1 < BF_KEY_BUFFER_SIZE);

	if (key_len == 0) {
		return;
	}

	for (hash_index = 0; hash_index < filter->hashes_count; hash_index++) {
		uint changed = bf_bitmap_set(filter->bitmap,
			bf_get_index(filter, key, key_len, hash_index));

		filter->bits_used += changed;
	}
}


uint bf_has(bf_t* filter, const char* key, uint key_len)
{
	uint result = TRUE;
	uint hash_index = 0;

	assert(key_len + filter->hashes_count / 10 + 1 < BF_KEY_BUFFER_SIZE);

	for (hash_index = 0; hash_index < filter->hashes_count; hash_index++) {
		result = result && bf_bitmap_get(filter->bitmap,
			bf_get_index(filter, key, key_len, hash_index));
	}

	return result;
}


uint bf_save(bf_t* filter, const char* path)
{
	FILE* fd = fopen(path, "w");

	bf_dump_header_t header = {
		0xb100f11e,
		filter->bits_count,
		filter->bits_used,
		filter->error_rate,
		filter->hashes_count
	};

	if (!fd) {
		return FALSE;
	}

	fwrite(&header, sizeof(bf_dump_header_t), 1, fd);
	fwrite(filter->bitmap, sizeof(bf_bitmap_t), filter->bytes_count, fd);

	fclose(fd);

	return TRUE;
}


bf_t* bf_load(const char* path,
	bf_index_t (*hash_func)(char*, uint))
{
	FILE* fd = fopen(path, "r");

	if (!fd) {
		return 0;
	}

	bf_dump_header_t header;
	size_t read = fread(&header, sizeof(bf_dump_header_t), 1, fd);

	if (read < 1) {
		return 0;
	}

	if (header.signature != BF_DUMP_SIGNATURE) {
		return 0;
	}

	bf_t* filter = (bf_t*)malloc(sizeof(bf_t));

	filter->bits_count = header.bits_count;
	filter->bits_used = header.bits_used;
	filter->bytes_count = (bf_index_t)ceil(filter->bits_count / 8.);
	filter->error_rate = header.error_rate;
	filter->hashes_count = header.hashes_count;
	filter->bitmap = (bf_bitmap_t*)malloc(sizeof(bf_bitmap_t) * filter->bytes_count);
	filter->hash_func = hash_func;

	read = fread(filter->bitmap, sizeof(bf_bitmap_t), filter->bytes_count, fd);
	if (read < filter->bytes_count) {
		return 0;
	}

	fclose(fd);

	return filter;
}


void bf_merge(bf_t* filter1, bf_t* filter2)
{
	uint index = 0;

	assert(filter1->bits_count == filter2->bits_count);

	filter1->bits_used += filter2->bits_used;

	for (index = 0; index < filter1->bytes_count; index++) {
		filter1->bitmap[index] |= filter2->bitmap[index];
	}
}


uint bf_bitmap_set(bf_bitmap_t* bitmap, bf_index_t bit)
{
	uint cell_size = sizeof(bf_bitmap_t) * 8;

	bf_index_t byte = bit / cell_size;
	char bit_pos = bit - byte * cell_size;

	char old_byte = bitmap[byte];
	bitmap[byte] |= (1 << (cell_size - bit_pos - 1));

	return bitmap[byte] != old_byte;
}


uint bf_bitmap_get(bf_bitmap_t* bitmap, bf_index_t bit)
{
	uint cell_size = sizeof(bf_bitmap_t) * 8;

	bf_index_t byte = bit / cell_size;
	char bit_pos = bit - byte * cell_size;

	return bitmap[byte] & (1 << (cell_size - bit_pos - 1));
}


uint bf_destroy(bf_t* filter)
{
	assert(filter != NULL);
	assert(filter->bitmap != NULL);

	free(filter->bitmap);
	free(filter);
}