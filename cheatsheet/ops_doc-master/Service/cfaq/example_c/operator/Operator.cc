#include "Operator.h"



COperator operator +(const COperator& lh, const COperator& rh)
{
	return COperator(lh.i + rh.i);
}

COperator operator -(const COperator& lh, const COperator& rh)
{
	return COperator(lh.i - rh.i);
}


COperator::COperator()
	:i(0),
	s("")
{
}

COperator::~COperator()
{
	
}

COperator&
COperator::operator =(const COperator& rh)
{
	this->i = rh.i;
	
	return *this;
}


COperator&
COperator::operator =(const int& value)
{
	this->i = value;
	
	return *this;
}

//COperator&
//COperator::operator *()
//{
	//return *this;
//}