#include <iostream>
using namespace std;
/*
double g_rate = 0.001; // 利率
*/
double g = 0;
// 银行账户
class Account {
public:
	Account (string const& name,
		string const& passwd,
		int id, double balance) :
		m_name (name),
		m_passwd (passwd), m_id (id),
		m_balance (balance) {}
	void save (double money) {
		m_balance += money;
	}
	bool draw (double money,
		string const& passwd) {
		if (passwd != m_passwd)
			return false;
		if (money > m_balance)
			return false;
		m_balance -= money;
		return true;
	}
	double query (
		string const& passwd) const {
		if (passwd != m_passwd)
			return -1;
		return m_balance;
	}
	void settle (void) {
		cout << this << ' '
			<< &m_rate << endl;
		m_balance *= (1 + m_rate);
	}
	static void setRate (
		double rate) /*const*/ {
		m_rate = rate;
//		cout << m_balance << endl;
	}
private:
	string m_name;    // 户名
	string m_passwd;  // 密码
	int    m_id;      // 账号
	double m_balance; // 余额
	/*
	double m_rate;    // 利率
	*/
public:
	static double m_rate; // 利率
};
double Account::m_rate = 0.001;
int main (void) {
	cout << &g << ' '
		<< &Account::m_rate << endl;
	Account acc1 ("张飞", "000000",
		1000, 10);
	Account acc2 ("赵云", "666666",
		1001, 10000);
	acc1.save (90);
	acc2.draw (5000, "666666");
	cout << acc1.query ("000000")
		<< endl; // 100
	cout << acc2.query ("666666")
		<< endl; // 5000
//	acc1.setRate (0.01);
//	acc2.setRate (0.01);
	Account::setRate (0.01);
//	acc1.m_rate = 0.01;
//	acc2.m_rate = 0.01;
//	Account::m_rate = 0.01;
	acc1.settle ();
	acc2.settle ();
	cout << acc1.query ("000000")
		<< endl; // 100->100.1
	cout << acc2.query ("666666")
		<< endl; // 5000->5005
	cout << sizeof (Account) << endl;
	// 20，不包含m_rate
	return 0;
}
