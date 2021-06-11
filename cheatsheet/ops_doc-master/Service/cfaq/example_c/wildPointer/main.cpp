#include <stdio.h>
#include <stdlib.h>

class SmartPointer
{
public:
	SmartPointer():m_Age(100) {}
	
	unsigned short tag;
public:
	bool IsEnabled() { return tag == 9999 ? true : false;}
	
	int Add(const int& a, const int& b) { return a + b; }
	unsigned short GetAge() const { return m_Age; }
private:
	unsigned short m_Age;
};


int main(int argc, char **argv)
{
	for (unsigned int i = 0; i < 50000; i++)
	{
	
		SmartPointer* p = new SmartPointer;
		
		SmartPointer* pp = p;
		
		p->tag = 9999;
		
		delete p;
		p = NULL;
		
		for (unsigned int j = 0; j<1000; j++)
		{
			int* ppp = new int;
			delete ppp;
		}
		
		#if 1
		//if (pp->tag == 9999)
		if(pp->IsEnabled())
		{
			printf("Pointer vaild.\n");
		}
		else
		{
			printf("wild Pointer.\n");
		}
		#endif
		
		printf("Result: %d\n",pp->GetAge());
		
	}
	system("pause");
	
	return 0;
}
