#include <iostream>
using namespace std;
class Singleton {
public:
	static Singleton& getInstance (
		void) {
		if (! s_instance) {
			pthread_mutex_lock (
				&s_mutex);
			if (! s_instance)
				s_instance =
					new Singleton;
			pthread_mutex_unlock (
				&s_mutex);
		}
		return *s_instance;
	}
private:
	Singleton (void) {}
	Singleton (
		Singleton const& that) {}
	static Singleton* s_instance;
	static pthread_mutex_t s_mutex;
};
Singleton* Singleton::s_instance
	= NULL;
pthread_mutex_t Singleton::s_mutex
	= PTHREAD_MUTEX_INITIALIZER;
int main (void) {
//	Singleton singleton;
	Singleton& s1 =
		Singleton::getInstance ();
	cout << &s1 << endl;
	Singleton& s2 =
		Singleton::getInstance ();
	cout << &s2 << endl;
//	Singleton s3 = s2;
	return 0;
}
