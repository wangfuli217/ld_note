#include <stdio.h>

class A 
{
public:
	A():age(10)
	{}
	~A() {}

public:
	static inline void Name();
	
	void Self(); // 定义的时候添加 inline
	
	inline void func();  // 这里声明的时候添加 inline 定义时候不用 inline
private:
	int age;
};

inline void 
A::Name()
{
	printf("Name: A\n");
}

inline void
A::Self()
{
	printf("Age: %d\n", age);
}

void
A::func()
{
	
}

int main(int argc, char **argv)
{
	printf("hello world\n");
	return 0;
}
