#ifndef __TEMPLATED_H_
#define __TEMPLATED_H_

#include "template.h"

template <>
class CExample<float>
{
public:
	CExample<float>() {};
	~CExample<float>() {};
	
	void Add(float a, float b);
};


#endif