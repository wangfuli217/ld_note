#include<iostream>
#include<fstream>
using namespace std;

int main(void)
{
	fstream fs("seek.txt",ios::in|ios::out);
	if(!fs)
	{
		perror("fstream");
		return -1;
	}
	fs<<"0123456789";
	cout<<fs.tellp()<<endl;       //10
	fs.seekp(1,ios::beg);
	fs<<"ABC";
	fs.seekg(-3,ios::end);
	int i;
	fs>>i;
	cout<<i<<endl;
	return 0;
}
