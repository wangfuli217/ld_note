#include <stdint.h>
#include <iostream>
#include <stdlib.h>

using namespace std;

struct tt
{
	uint64_t	a;
	uint64_t	b;
};

tt& GetWeeklyHours()
{
	tt h = {11, 22};
	
	tt& hours = h;
	
	return hours;
}

tt& GetWeeklyHours2()
{
	tt h = {33, 44};
	
	tt& hours = h;
	
	return hours;
}

int
main()
{
	tt& hours = GetWeeklyHours();
	
	GetWeeklyHours2();
	
	cout << "Weekly Hours: " << hours.a << hours.b << endl;
	
	return 0;
}