
#include "person.h"
#include "employee.h"

#include <stdio.h>

int main()
{
	Person* PersonObj = new_Person("Anjali", "Jaiswal");
	Person* EmployeeObj = new_Employee("Gauri", "Jaiswal","HR", "TCS", 40000);
	
	//accessing Person object
	
	//displaying Person info
	PersonObj->Display(PersonObj);
	//writing Person info in the persondata.txt file
	PersonObj->WriteToFile(PersonObj,"persondata.txt");
	//calling destructor
	PersonObj->Delete(PersonObj);
	
	//accessing to employee object
	
	//displaying employee info
	EmployeeObj->Display(EmployeeObj);
	//writing empolyee info in the employeedata.txt file
	EmployeeObj->WriteToFile(EmployeeObj, "employeedata.txt");
	//calling destrutor
	EmployeeObj->Delete(EmployeeObj);
	return 0;
}


