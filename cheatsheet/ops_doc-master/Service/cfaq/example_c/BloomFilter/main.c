//
// Copyright Stanislav Seletskiy <s.seletskiy@gmail.com>
//

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>

#include "bloomlib.h"

#define FALSE 0
#define TRUE  1

typedef unsigned int uint;

#define BLOOM_HASH_FUNC murmur


//
// Copyright Austin Appleby
// See: https://sites.google.com/site/murmurhash/
//
bf_index_t murmur(char* key, uint key_len)
{
	uint seed = 1;
	const uint64_t m = 0xc6a4a7935bd1e995LLU;
	const int r = 47;

	uint64_t h = seed ^ (key_len * m);

	const uint64_t * data = (const uint64_t *)key;
	const uint64_t * end = data + (key_len / 8);

	while(data != end)
	{
		uint64_t k = *data++;

		k *= m;
		k ^= k >> r;
		k *= m;

		h ^= k;
		h *= m;
	}

	const unsigned char * data2 = (const unsigned char*)data;

	switch(key_len & 7)
	{
	case 7: h ^= (uint64_t)data2[6] << 48;
	case 6: h ^= (uint64_t)data2[5] << 40;
	case 5: h ^= (uint64_t)data2[4] << 32;
	case 4: h ^= (uint64_t)data2[3] << 24;
	case 3: h ^= (uint64_t)data2[2] << 16;
	case 2: h ^= (uint64_t)data2[1] << 8;
	case 1: h ^= (uint64_t)data2[0];
			h *= m;
	};

	h ^= h >> r;
	h *= m;
	h ^= h >> r;

	return h;
}


uint gets_skip(char* buffer, uint max_len, uint* actual_len)
{
	char* ptr = buffer;
	uint len = 0;

	*actual_len = 0;

	while (TRUE) {
		char c = getchar();

		if (c == EOF) {
			return FALSE;
		}

		if (c == '\n') {
			break;
		}

		*ptr = c;

		ptr++;
		len++;

		if (len >= max_len) {
			while (TRUE) {
				c = getchar();
				if (c == EOF || c == '\n') {
					break;
				}
			}

			break;
		}

		(*actual_len)++;
	}

	*ptr = 0;

	return TRUE;
}


void show_help(char* argv0)
{
	printf("Usage: %s (create|filter|info|merge) [...]\n", argv0);
	printf("\n");

	printf("%s\n",
		"  create[ -p] {file_name} {error_rate} {key_count}\n"
			"    Read keys from stdin, creates bloom filter and stores it\n"
			"    into {file_name} file. Program choose size of filter that\n"
			"    satisfy specified {error_rate} with maximum of {key_count}.\n\n"
			"    With -p writes into stderr progress after every 1M inserted items.\n");

	printf("%s\n",
		"  filter[ -n][ -u] {file_name}\n"
			"    Reads keys from stdin and write to stdout that keys, that\n"
			"    probably set, described by bloom filter in {file_name}.\n\n"
			"    With -n flag write only that keys, that are NOT in set.\n"
			"    With -u flag filter will be updated when new keys are appears in stdin.\n");

	printf("%s\n",
		"  info {file_name}\n"
			"    Show misc statistics for bloom filter from {file_name}.\n");

	printf("%s\n",
		"  merge {target_file_name} {filter1}[ filter2[ filter3[ ...]]]\n"
			"    Merge all specified fiters into one and save under {target_file_name}.\n");
}


int mode_create(int argc, char** argv)
{
	uint argo = 0;
	uint progress = FALSE;
	if (strcmp(argv[2], "-p") == 0) {
		argo++;
		progress = TRUE;
	}

	if (argc - argo < 5) {
		show_help(argv[0]);

		return 1;
	}

	char* bloom_file = argv[2 + argo];
	double error_rate = atof(argv[3 + argo]);
	bf_index_t key_count = atol(argv[4 + argo]);

	bf_t* filter = bf_create(error_rate, key_count, BLOOM_HASH_FUNC);

	char input_buffer[BF_KEY_BUFFER_SIZE] = { 0 };
	bf_index_t key = 0;
	uint actual_length;
	while (gets_skip(input_buffer, BF_KEY_BUFFER_SIZE, &actual_length)) {
		bf_add(filter, (const char*)input_buffer, actual_length);
		key = key + 1;
		if (progress && key % 1000000 == 0) {
			printf("%s: %s <- %ld\n", argv[0], bloom_file, key);
		}
	}

	bf_save(filter, bloom_file);

	bf_destroy(filter);

	return 0;
}


int mode_info(int argc, char** argv)
{
	char* bloom_file = argv[2];

	bf_t* filter = bf_load(bloom_file, BLOOM_HASH_FUNC);

	if (!filter) {
		printf("File %s has wrong format or doesn't exist.\n", bloom_file);

		return 2;
	}

	printf("capacity:   %ld\n", filter->bits_count);
	printf("used:       %ld\n", filter->bits_used);
	printf("error rate: %.3f%%\n", exp(- filter->bits_count / (float)filter->bits_used * BF_LOG2_2));
	printf("hash/item:  %d\n", filter->hashes_count);

	bf_destroy(filter);
}


int mode_filter(int argc, char** argv)
{
	uint argo = 0;

	uint negative = FALSE;
	if (strcmp(argv[2 + argo], "-n") == 0) {
		negative = TRUE;
		argo++;
	}

	uint update = FALSE;
	if (strcmp(argv[2 + argo], "-u") == 0) {
		update = TRUE;
		argo++;
	}

	char* bloom_file = argv[2 + argo];
	bf_t* filter = bf_load(bloom_file, BLOOM_HASH_FUNC);
	if (!filter) {
		printf("File %s has wrong format or doesn't exist.\n", bloom_file);

		return 2;
	}


	char input_buffer[BF_KEY_BUFFER_SIZE] = { 0 };
	uint actual_length = 0;
	while (gets_skip(input_buffer, BF_KEY_BUFFER_SIZE, &actual_length)) {
		uint has = bf_has(filter, (const char*)input_buffer, actual_length);
		if (negative) {
			if (!has) {
				printf("%s\n", input_buffer);
				fflush(stdout);
				if (update) {
					bf_add(filter, input_buffer, actual_length);
				}
			}
		} else {
			if (has) {
				printf("%s\n", input_buffer);
				fflush(stdout);
			} else {
				if (update) {
					bf_add(filter, input_buffer, actual_length);
				}
			}
		}
	}

	if (update) {
		bf_save(filter, bloom_file);
	}

	bf_destroy(filter);

	return 0;
}


int mode_merge(int argc, char** argv)
{
	if (argc < 4) {
		show_help(argv[0]);

		return 1;
	}

	char* bloom_file = argv[3];

	bf_t* filter = bf_load(bloom_file, BLOOM_HASH_FUNC);
	if (!filter) {
		printf("File %s has wrong format or doesn't exist.\n", bloom_file);

		return 2;
	}

	bf_t* merge_with;
	uint  file_index;
	for (file_index = 4; file_index < argc; file_index++) {
		merge_with = bf_load(argv[file_index], BLOOM_HASH_FUNC);
		if (!merge_with) {
			printf("File %s has wrong format or doesn't exist.\n", argv[file_index]);

			return 2;
		}

		bf_merge(filter, merge_with);
		bf_destroy(merge_with);
	}

	char* merged_bloom_file = argv[2];
	bf_save(filter, merged_bloom_file);

	return 0;
}


int main(int argc, char** argv)
{
	if (argc < 3) {
		show_help(argv[0]);

		return 1;
	}

	int result = 2;
	char* mode = argv[1];

	if        (strcmp(mode, "create") == 0) {
		result = mode_create(argc, argv);
	} else if (strcmp(mode, "info") == 0) {
		result = mode_info(argc, argv);
	} else if (strcmp(mode, "filter") == 0) {
		result = mode_filter(argc, argv);
	} else if (strcmp(mode, "merge") == 0) {
		result = mode_merge(argc, argv);
	}
	
#ifdef __WIN32
	system("pause");
#endif

	return 0;
}