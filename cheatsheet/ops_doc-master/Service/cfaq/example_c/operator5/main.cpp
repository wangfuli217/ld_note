#include <stdio.h>
#include <stdlib.h>
#include <string>

using std::string;

template <typename T>
class wrap {
public:
    T* operator->()    { return &t; }
    T& operator--(int) {  return t; }

private:
    T t;
};


int main(int argc, char **argv)
{
	wrap<wrap<wrap<std::string> > > wp;
    printf("%d\n", wp----->length());
	
	return 0;
}
