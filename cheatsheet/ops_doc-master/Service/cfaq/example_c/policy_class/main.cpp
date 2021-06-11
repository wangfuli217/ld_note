#include <stdio.h>

template <class T> struct NoChecking {
	static void Check(T*) {}
};

template <class T> struct EnforceNotNull {
	class NullPointerExcetion : public std::exception {};
	static void Check(T* ptr) {
		if (!ptr) throw NullPointerExcetion();
	}
}


template < 
	class T, template <class> class CheckingPolicy,
	template <class> class ThreadingModel
>
class SmartPtr;


int main(int argc, char **argv)
{
	printf("hello world\n");
	return 0;
}
