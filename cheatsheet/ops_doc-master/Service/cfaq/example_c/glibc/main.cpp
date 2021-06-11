#include <iostream>
#include <cstdlib>

using namespace std;

int
main()
{
        int* p;

        double* d;

        for(int i = 0; i < 5000; i++)
        {
                p = new int(i);

                cout << "P: " << p << " *: " << *p  <<endl;

                
				#if 0
				delete p;
				#endif
				
                p = NULL;

                d = new double(i);

                cout << "d: " << d << " *: " << *d  <<endl;

				#if 0
                delete d;
				#endif
                d = NULL;
				
        }
		
		system("pause");

        return 0;
}