#include<iostream>
#include<map>
using namespace std;

class Candidate
{
	public:
		Candidate(string const& name=""):m_name(name),m_votes(0){}
		string const& name(void) const
		{
			return m_name;
		}
		size_t votes(void) const
		{
			return m_votes;
		}
		void vote(void)
		{
			++m_votes;
		}
	private:
		string m_name;
		size_t m_votes;
};
int main(void)
{
	map<char,Candidate> mcc;
	mcc.insert(pair<char,Candidate>('A',Candidate("曹操")));
	mcc.insert(make_pair('B',Candidate("刘备")));
	mcc['C']=Candidate("关羽");
	mcc['D']=Candidate("张飞");
	mcc['E']=Candidate("赵云");
	typedef map<char,Candidate>::iterator IT;
	for(size_t i=0;i<10;i++)
	{
		for(IT it=mcc.begin();it!=mcc.end();it++)
			cout<<'('<<it->first<<')'<<it->second.name()<<' ';
		cout<<endl<<"请投票:"<<flush;
		char key;
		cin>>key;
		IT it=mcc.find(key);
		if(it==mcc.end())
		{
			cout<<"废票!"<<endl;
			continue;
		}
		it->second.vote();
	}
	IT win=mcc.begin();
	for(IT it=mcc.begin();it!=mcc.end();it++)
	{
		cout<<it->second.name()<<"获得"<<it->second.votes()<<"票"<<endl;
		if(it->second.votes()>win->second.votes())
			win=it;
	}
	cout<<"热烈祝贺"<<win->second.name()<<"同学当选!"<<endl;
	return 0;
}
