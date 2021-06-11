/*
 * T = uint32_t, 32-bit GNU/Linux OS, -O0
 *
 * max   | len   | cap   | load  | coll  | ncoll | eff   | bytes | value
 * ------+-------+-------+-------+-------+-------+-------+-------+------
 * 0.20  | 102   | 512   | 0.20  | 0.06  | 0.06  | 0.165 | 72.51 | 0.466
 * 0.30  | 153   | 512   | 0.30  | 0.12  | 0.11  | 0.229 | 52.42 | 0.472
 * 0.50  | 256   | 512   | 0.50  | 0.27  | 0.23  | 0.330 | 36.34 | 0.481
 * 0.70  | 358   | 512   | 0.70  | 0.32  | 0.26  | 0.407 | 29.47 | 0.631
 * 0.85  | 435   | 512   | 0.85  | 0.41  | 0.31  | 0.452 | 26.57 | 0.647
 * 1.00  | 512   | 512   | 1.00  | 0.47  | 0.35  | 0.484 | 24.78 | 0.671
 * 1.15  | 588   | 512   | 1.15  | 0.55  | 0.39  | 0.512 | 23.44 | 0.670
 * 1.30  | 665   | 512   | 1.30  | 0.64  | 0.43  | 0.532 | 22.54 | 0.659
 * 1.50  | 768   | 512   | 1.50  | 0.75  | 0.47  | 0.559 | 21.47 | 0.659
 * 1.75  | 896   | 512   | 1.75  | 0.87  | 0.53  | 0.583 | 20.58 | 0.643
 * 2.00  | 1024  | 512   | 2.00  | 1.00  | 0.57  | 0.603 | 19.90 | 0.637
 * 2.50  | 1280  | 512   | 2.50  | 1.25  | 0.63  | 0.625 | 19.21 | 0.616
 * 3.00  | 1536  | 512   | 3.00  | 1.50  | 0.68  | 0.638 | 18.82 | 0.597
 * 4.00  | 2048  | 512   | 4.00  | 1.98  | 0.75  | 0.656 | 18.29 | 0.571
 * 6.00  | 3072  | 512   | 6.00  | 3.00  | 0.83  | 0.667 | 18.00 | 0.533
 * 9.00  | 4608  | 512   | 9.00  | 4.53  | 0.89  | 0.679 | 17.66 | 0.519
 * 12.00 | 6144  | 512   | 12.00 | 6.03  | 0.92  | 0.693 | 17.32 | 0.523
 * 15.00 | 7680  | 512   | 15.00 | 7.52  | 0.93  | 0.681 | 17.62 | 0.497
 * 20.00 | 10240 | 512   | 20.00 | 10.00 | 0.95  | 0.683 | 17.57 | 0.491
 *
 * max: load threshold before map cap growth
 * len: number of map entries
 * cap: number of buckets
 * load: len/cap
 * coll: average number of comparisons to resolve collision for each element
 * ncoll: how many of entries are collisions
 * eff: used space / total space
 * bytes: bytes/entry
 * value: eff*eff/ncoll; TODO: improve formula?
 */

#include <stdio.h>
#include "hmap.h"
#include "alist.h"

#define T uint32_t /* key and value type */
#define N 5 /* number of growths */

typedef struct stats {
	int len;
	int cap;
	int map;
	int used;
	int unused;
	int collisions;
	int num_coll;
	double max_load;
} stats;

T randt(void);
int cmp(T a, T b);
uint32_t hash(T n);

HMAP_PROTO(int, int, map);
HMAP(int, int, map, cmp, hash);
ALIST_PROTO(stats, stat_list);
ALIST(stats, stat_list);

int cmp(T a, T b)
{
	return a - b;
}

uint32_t hash(T n)
{
	return n;
}

T randt(void)
{
	T t;
	uint32_t *p;
	int i;

	p = (uint32_t *)&t;
	for (i=0; i<sizeof(T)/sizeof(uint32_t); ++i) {
		*p = rand();
		++p;
	}

	return t;
}

stats map_stats(const map *m)
{
	stats s;
	map_bucket *b;
	int i, j;

	s.len = m->len;
	s.cap = m->cap;
	s.map = 0;
	s.used = 0;
	s.unused = 0;
	s.collisions = 0;
	s.num_coll = 0;
	s.max_load = m->max_load;

	s.map += sizeof(struct map);
	for (i=0; i<m->cap; ++i) {
		b = &m->buckets[i];
		s.map += sizeof(struct map_bucket);
		s.used += b->len * sizeof(struct map_entry);
		s.unused += (b->cap-b->len) * sizeof(struct map_entry);
		for (j=0; j<b->len; ++j) {
			s.collisions += j;
		}
		if (b->len > 1) s.num_coll += b->len-1;
	}

	return s;
}

void print_header(void)
{
	printf("%-5s | %-5s | %-5s | %-5s | %-5s | %-5s | %-5s | %-5s | %-5s\n", "max", "len", "cap", "load", "coll", "ncoll", "eff", "bytes", "value");
}

void print_hr(void)
{
	printf("------+-------+-------+-------+-------+-------+-------+-------+------\n");
}

void print_stats(stats s)
{
	double eff, coll, value;
	eff = s.used * 1.0 / (s.used + s.unused + s.map);
	coll = s.collisions * 1.0 / s.len;
	value = eff*eff / s.num_coll * s.len;
	printf("%-5.2f | %-5d | %-5d | %-5.2f | %-5.2f | %-5.2f | %.3f | %-5.2f | %.3f\n", s.max_load, s.len, s.cap, s.len*1.0/s.cap, coll, s.num_coll*1.0/s.len, eff, (s.map+s.used+s.unused)*1.0/s.len, value);
}

int main(void)
{
	int i;
	map *m;
	int lastcap;
	stats s;
	stat_list *l1, *l2;
	stat_list_iterator iter;
	double _max_load[] = {0.2, 0.3, 0.5, 0.7, 0.85, 1.0, 1.15, 1.3, 1.5, 1.75, 2.0, 2.5, 3.0, 4.0, 6.0, 9.0, 12.0, 15.0, 20.0, 0.0};
	double *max_load = _max_load;

	l1 = stat_list_new();
	l2 = stat_list_new();
	while (*max_load > 0) {
		m = map_new();
		m->max_load = *max_load;
		++max_load;
		lastcap = m->cap;
		s = map_stats(m);
		srand(0);
		for (i=0; i<=N; ++i) {
			while (m->cap == lastcap) {
				if ((m->len+1.0)/m->cap > m->max_load) {
					s = map_stats(m);
				}
				map_set(m, randt(), randt());
			}
			lastcap = m->cap;
		}
		stat_list_insert(l1, s, -1);
		stat_list_insert(l2, map_stats(m), -1);
		map_free(m);
	}

	print_header();
	print_hr();
	for (iter=stat_list_iterate(l1); stat_list_next(l1, &iter); ) {
		print_stats(stat_list_get_at(l1, iter));
	}
	print_hr();
	print_header();
	print_hr();
	for (iter=stat_list_iterate(l2); stat_list_next(l2, &iter); ) {
		print_stats(stat_list_get_at(l2, iter));
	}

	stat_list_free(l1);
	stat_list_free(l2);

	return 0;
}
