#ifndef __DATA_H__
#define __DATA_H__

#include <stdio.h>

#define __ME__ printf("%s\n", __PRETTY_FUNCTION__)

class Data {
public:
	Data(int id):_id(id) {}
	~Data() {}
	
	operator bool() const {
		__ME__;
		return _id ? true : false;
	}
	operator int() const {
		__ME__;
		return _id;
	}
	operator char*() const {
		__ME__;
		return (char*)&_id;
	}
private:
	int _id;
};

#endif
