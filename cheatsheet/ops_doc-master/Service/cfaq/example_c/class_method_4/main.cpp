#include <stdio.h>


class Father {
public:
	void Connect() { CreateA(); CreateB(); }
	virtual bool CreateA() = 0;
	virtual bool CreateB() = 0;
	virtual int version(int i) = 0;
	virtual void version() = 0;
};

class Son : public Father {
public:
	virtual bool CreateA() { return true; }
	virtual bool CreateB() { return true; }
	
	int version(int i) { return i; }
	void version() {} 
};

int 
main(int argc, char **argv)
{
	Son son;
	
	Father *pf = new Son;
	
	son.Connect();
	
	pf->Connect();
	
	
	return 0;
}
