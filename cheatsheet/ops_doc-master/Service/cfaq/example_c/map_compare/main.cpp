#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <string>

using namespace std;

typedef struct key_s key_t;
struct key_s {
	int id;
	
	friend inline bool operator < (const key_t& a, const key_t& b);
};

typedef struct value_s value_t;
struct value_s {
	string card;
};

inline bool 
operator < (const key_t& a, const key_t& b)
{
	return a.id - b.id < 0;
}


typedef struct compare_s compare_t;
struct compare_s {
	bool operator () (const key_t& k1, const key_t& k2) { return k1.id - k2.id < 0; } //升序
};

typedef struct compare_int_s compare_int_t;
struct compare_int_s {
	bool operator () (const int& k1, const int& k2) { return k2 < k1;} // 降序
}

#if 1  /* 第一种方式定义函数对象 */
typedef map<key_t, value_t, compare_t> 				my_map_t;
typedef map<key_t, value_t, compare_t>::iterator 	my_map_itr_t;
typedef map<int, int, compare_int_t>				 	my_int_map_t;
typedef my_int_map_t::iterator						my_int_map_itr_t;
#else  /* 第二种方式定义自定义类的 operator < 但必须是第三方友元函数的形式 */
typedef map<key_t, value_t> 			my_map_t;
typedef map<key_t, value_t>::iterator 	my_map_itr_t;
#endif

int 
main(int argc, char **argv)
{
	my_map_t 		temp;
	my_map_itr_t	it;
	
	for (int i = 0; i < 100; i++) {
		key_t 	k;
		value_t v;
		
		k.id = i;
		v.card = "cddddd";
		
		temp[k] = v;
	}
	
	for (it = temp.begin(); it != temp.end(); it++) {
		printf("temp[%d]: %s\n", it->first.id, it->second.card.c_str());
	}
	
	system("pause");
	
	return 0;
}
