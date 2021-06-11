#include <stdio.h>
#include <iostream>
#include "Operator.h"

using namespace std;

int 
main(int argc, char **argv)
{
	COperator op, op2;
	
	cout << "OP: " << op.Show() << endl;
	
	op2 = 20;
	
	op = op2;
	
	COperator* pop = &op;
	
	COperator op3 = op + op2;
	
	op3 = op2;
	
	op++;
	
	COperator& rp = *op;
	
	int size = op->size();
	
	cout << "size: " << size << endl;
	
	cout << "OP: " << op.Show() << endl;
	
	cout << "OP: " << op3.Show() << endl;
	
	cout << "OP: " << (*pop).Show() << endl;
	
	cout << "OP: " << pop->Show() << endl;
	
	cout << "OP: " << op(99) << endl;
	
	cout << "OP: " << (int)op << endl;
	
	op3 << op;
	
	cout << "OP3: " << op3.Show() << endl;
	
	cout << "OP3: " << op3 << endl;
	
	COperator* op4 = new(__FUNCTION__) COperator;
	COperator* op5 = new(std::nothrow) COperator;
	COperator* op6 = new COperator[10];
	
	delete op4;
	delete op5;
	delete[] op6;
	
	COperator op7(99);
	
	cout << "op7[1]: " << op7[1] << endl;

	op7[1] = 'c';
	
	cout << "op7[1]: " << op7[1] << endl;
	
	cout << "op7(): " << op7() << endl;
	
	if (op7) {
		cout << "true" << endl;
	} else {
		cout << "false" << endl;
	}
	
	return 0;
}
