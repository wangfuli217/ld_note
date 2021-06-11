#ifndef _PERSON_H
#define _PERSON_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct _Person Person;


typedef void	(*fptrDisplayInfo)(Person*);
typedef void    (*fptrWriteToFile)(Person*, const char*);
typedef void	(*fptrDelete)(Person*) ;

typedef struct _Person
{
	void* pDerivedObj;
	char* pFirstName;
	char* pLastName;
	//interface to access member functions
	fptrDisplayInfo Display;
	fptrWriteToFile WriteToFile;
	fptrDelete		Delete;
}Person;

Person* new_Person(const char* pFName, const char* pLName);	//constructor
void delete_Person(Person* const pPersonObj);	//destructor

void Person_DisplayInfo(Person* const pPersonObj);
void Person_WriteToFile(Person* const pPersonObj, const char* pFileName);





#endif