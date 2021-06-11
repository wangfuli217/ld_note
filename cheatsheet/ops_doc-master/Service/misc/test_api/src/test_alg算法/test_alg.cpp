#include <iostream>
#include <stdio.h>

using namespace std;

int wayCounts(int ladderSize)
{
    if (0 == ladderSize)
        return 1;
    else if (0 > ladderSize)
        return 0;

    return wayCounts(ladderSize-1) + wayCounts(ladderSize-2);
}

int main()
{
    printf("counts: %d\n", wayCounts(4));

	return 0;
}
