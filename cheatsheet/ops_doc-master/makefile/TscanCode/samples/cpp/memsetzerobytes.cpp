void Demo()
{
	char* p = new char[100];
	// 0ε100εεδΊ
	memset(p, 100, 0);
	delete [] p;
}