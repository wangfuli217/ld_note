#include <stdio.h>

#define __MB__ 	1048576
#define __KB__	1024

template <typename T, unsigned int size = 1 * __KB__ >
class B {
public:
	B();
	~B();
	unsigned int getSize();
	unsigned int getSize(T t);
private:
	unsigned int _size;
};

template <typename T, unsigned int size>
B<T, size>::B():_size(size)
{
	
}

template <typename T, unsigned int size> 
unsigned int 
B<T, size>::getSize()
{
	return _size;
}

template <typename T, unsigned int size>
B<T, size>::~B()
{
}

template <>
unsigned int
B<int, 4 * __KB__>::getSize()
{
	printf("is part spec | ");
	return _size;
}

template <>
unsigned int
B<long, 4 * __KB__>::getSize()
{
	printf("is part spec | ");
	return _size;
}

template<>
unsigned int
B<long, 4 * __KB__>::getSize(long l) // overload
{
	return _size;
}

int 
main(int argc, char **argv)
{
	B<int, 2 * __KB__> b;
	B<int> b1;
	B<int, 4 * __KB__> b2;
	
	printf("Size: %u\n", b.getSize());
	printf("Size: %u\n", b1.getSize());
	printf("Size: %u\n", b2.getSize());
	return 0;
}
