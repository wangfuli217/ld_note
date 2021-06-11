// Copyright Idaho O Edokpayi 2008
// Code is governed by Code Project Open License 
// QueueUnitTest.cpp : Defines the entry point for the console application.

#include "LockFreeQ.h"


using namespace std;

int main(int argc, char* argv[])
{
	MSQueue< int > Q;

	for(int i = 0; i < 10; i++)
	{
		Q.enqueue(i);
	}

	cout << "Contents of queue." << endl;

	for(int j = 0; j < 11; j++)
	{
		int n;
		if(Q.dequeue(n))
		{
			cout << n << endl;	
		}
	}
	return 0;
}

