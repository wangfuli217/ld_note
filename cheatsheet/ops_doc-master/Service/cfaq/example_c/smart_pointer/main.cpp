#include <stdio.h>

template <typename T>
class SmartPointer {
public:
	//构造函数
	SmartPointer(T* p=0): _ptr(p), _reference_count(new size_t){
		if(p)
			*_reference_count = 1; 
		else
			*_reference_count = 0; 
	}
	//拷贝构造函数
	SmartPointer(const SmartPointer& src) {
		if(this!=&src) {
			_ptr = src._ptr;
			_reference_count = src._reference_count;
			(*_reference_count)++;
		}
	}
	//重载赋值操作符
	SmartPointer& operator=(const SmartPointer& src) {
		if(_ptr==src._ptr) {
			return *this;
		}
		releaseCount();
		_ptr = src._ptr;
		_reference_count = src._reference_count;
		(*_reference_count)++;
		return *this;
	}
 
	//重载操作符
	T& operator*() {
		if(_ptr) {
			return *_ptr;
		}
		//throw exception
	}
	//重载操作符
	T* operator->() {
		if(_ptr) {
			return _ptr;
		}
		//throw exception
	}
	//析构函数
	~SmartPointer() {
		if (--(*_reference_count) == 0) {
            delete _ptr;
            delete _reference_count;
        }
	}
private:
	T *_ptr;
        size_t *_reference_count;
        void releaseCount() {
		if(_ptr) {
			(*_reference_count)--;
    			if((*_reference_count)==0) {
    				delete _ptr;
    				delete _reference_count;
    			}
		}
    	}
};
 
int main() 
{
    SmartPointer<char> cp1(new char('a'));
    SmartPointer<char> cp2(cp1);
    SmartPointer<char> cp3;
    cp3 = cp2;
    cp3 = cp1;
    cp3 = cp3;
    SmartPointer<char> cp4(new char('b'));
    cp3 = cp4;
}

