#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>

struct A {
	unsigned char a:1;
	unsigned char b:1;
	unsigned char c:1;
	unsigned char d:1;
	unsigned char e:1;
	unsigned char f:1;
	unsigned char g:1;
	unsigned char h:1;
};


struct B {
	uint32_t a:16;
	uint32_t b:16;
	uint32_t  :16; /* 匿名段 */
	uint32_t c:16;
};

/* 这里必须按照int的类型对齐，所以大小为4 */
struct C {
	int a:8;
	int b:2;
	int c:6;
	int :0; /* 空域 */
};


struct {
      /* field 4 bits wide */
      unsigned field1 :4;
      /*
       * unnamed 3 bit field
       * unnamed fields allow for padding
       */
      unsigned        :3;
      /*
       * one-bit field
       * can only be 0 or -1 in two's complement!
       */
      signed field2   :1;
      /* align next field on a storage unit */
      unsigned        :0;
      unsigned field3 :6;
} full_of_fields;

struct E {
	unsigned char a:1;
	unsigned char :0;
};

struct F {
	unsigned int :0; // c++ 这里是一个字节
};

struct G {
	unsigned int a:1,
				 b:7;
};

int main(int argc, char **argv)
{
	struct A a = {0};
	
	a.a = 1;
	a.b = 1;
	a.a = 2;
	
	printf("sizeof A: %zu\n", sizeof a);
	printf("A:a: %d\n", a.a);
	printf("A:b: %d\n", a.b);
	
	struct B b = {0};
	
	printf("sizeof B: %zu\n", sizeof b);
	printf("A:a: %d\n", b.a);
	printf("A:b: %d\n", b.b);
	printf("A:b: %d\n", b.c);
	
	struct C c = {0};
	
	printf("sizeof C: %d\n", sizeof c);
	
	printf("sizeof D: %d\n", sizeof(full_of_fields));
	printf("sizeof E: %d\n", sizeof(struct E));
	printf("sizeof F: %d\n", sizeof(struct F));
	
	return 0;
}
