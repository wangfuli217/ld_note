//
// Copyright Stanislav Seletskiy <s.seletskiy@gmail.com>
//

#define BF_LOG2   0.6931471805599453
#define BF_LOG2_2 0.4804530139182013

#define BF_KEY_BUFFER_SIZE 255
#define BF_DUMP_SIGNATURE 0xb100f11e

#include <stdint.h>

typedef unsigned char    bf_bitmap_t;
typedef uint64_t         bf_index_t;
typedef unsigned char    bf_hash_t;

typedef struct bf_s             bf_t;
typedef struct bf_dump_header_s bf_dump_header_t;

struct bf_s
{
	bf_index_t bits_count;
	bf_index_t bits_used;
	bf_index_t bytes_count;

	double error_rate;

	bf_bitmap_t* bitmap;

	bf_index_t (*hash_func)(char*, uint32_t);
	uint32_t hashes_count;
};

struct bf_dump_header_s
{
	uint32_t signature;
	bf_index_t bits_count;
	bf_index_t bits_used;
	double error_rate;
	uint32_t hashes_count;
};

bf_t* bf_create(
	double error, bf_index_t key_count,
	bf_index_t (*hash)(char*, uint32_t));

bf_t* bf_load(const char* path,
	bf_index_t (*hash)(char*, uint32_t));

void  bf_add(bf_t* filter, const char* key, uint32_t len);
uint32_t  bf_has(bf_t* filter, const char* key, uint32_t len);
uint32_t  bf_destroy(bf_t* filter);
uint32_t  bf_save(bf_t* filter, const char* path);
void  bf_merge(bf_t* filter1, bf_t* filter2);

uint32_t bf_bitmap_set(bf_bitmap_t* bitmap, bf_index_t bit);
uint32_t bf_bitmap_get(bf_bitmap_t* bitmap, bf_index_t bit);

bf_index_t bf_get_index(bf_t* filter, const char* key, uint32_t key_len, uint32_t hash_index);