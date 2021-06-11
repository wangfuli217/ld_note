#include<iostream>
#include<fstream>
#include<cstdlib>
using namespace std;

int fxor(char const *src,char const* dst,unsigned char key)
{
	ifstream ifs(src,ios::binary);
	if(!ifs)
	{
		cout<<"源文件无法打开"<<endl;
		return -1;
	}
	ofstream ofs(dst,ios::binary);
	if(!ofs)
	{
		cout<<"目标文件无法打开"<<endl;
		return -1;
	}
	char buf[1024];
	while(ifs.read(buf,sizeof(buf)))
	{
		for(size_t i=0;i<sizeof(buf);i++)
			buf[i]^=key;
		if(!ofs.write(buf,sizeof(buf)))
		{
			cout<<"写入目标文件失败"<<endl;
			return -1;
		}
	}
	if(!ifs.eof())
	{
		cout<<"读取源文件失败"<<endl;
		return -1;
	}
	for(size_t i=0;i<ifs.gcount();i++)
		buf[i]^=key;
	if(!ofs.write(buf,ifs.gcount()))
	{
		cout<<"写入目标文件失败"<<endl;
		return -1;
	}
}
int enc(char const* pfile,char const* cfile)
{
	srand(time(NULL));
	unsigned char key=rand()%256;
	if(fxor(pfile,cfile,key)==-1)
		return -1;
	cout<<"密钥:"<<(unsigned int)key<<endl;
	return 0;
}
int dec(char const* cfile,char const* pfile,unsigned char key)
{
	return fxor(cfile,pfile,key);
}
int main(int argc,char *argv[])
{
	if(argc<3)
	{
		cout<<"加密:"<<argv[0]<<' '<<"明文"<<' '<<"密文"<<endl;
		cout<<"解密:"<<argv[0]<<' '<<"密文"<<' '<<"明文"<<' '<<"密钥"<<endl;
		return -1;
	}
	if(argc<4)
		return enc(argv[1],argv[2]);
	else
		return dec(argv[1],argv[2],atoi(argv[3]));
	return 0;
}
