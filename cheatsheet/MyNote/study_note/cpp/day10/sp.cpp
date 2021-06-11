#include<iostream>
using namespace std;

class Player
{
	public:
		Player(string const &media):m_media(media){}
		void play(string const &clip)
		{
			cout<<m_media<<"播放器播放"<<clip<<endl;
		}
	private:
		string m_media;
};
class Computer
{
	public:
		Computer(string const &os):m_os(os){}
		void run(string const &prog)
		{
			cout<<"在"<<m_os<<"上"<<"运行"<<prog<<endl;
		}
	private:
		string m_os;
};
class Phone
{
	public:
		Phone(string const &number):m_number(number){}
		void call(string const & number)
		{
			cout<<m_number<<"呼叫"<<number<<endl;
		}
	private:
		string m_number;
};
class SmartPhone:public Phone,public Player,public Computer
{
	public:
		SmartPhone(string const& number,string const &media,string const &os):Phone(number),Player(media),Computer(os){}
};
int main(void)
{
	SmartPhone sp ("13910110072","MP4","安桌");
	sp.call("01062332018");
	sp.play("侏罗纪世界");
	sp.run("滴滴打车");
	return 0;
}
