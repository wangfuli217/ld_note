#include "person.h"

Person* 
new_Person(const char* pFName, const char* pLName)
{
	Person* pObj = NULL;
	//allocating memory
	pObj = (Person*)malloc(sizeof(Person));
	if (pObj == NULL)
	{
		return NULL;
	}
	pObj->pDerivedObj = pObj; //pointing to itself
	pObj->pFirstName = malloc(sizeof(char)*(strlen(pFName)+1));
	strcpy(pObj->pFirstName, pFName);
	pObj->pLastName = malloc(sizeof(char)*(strlen(pLName)+1));
	strcpy(pObj->pLastName, pLName);

	//Initializing interface for access to functions
	pObj->Delete = delete_Person;			//destructor pointing to destrutor of itself
	pObj->Display = Person_DisplayInfo;
	pObj->WriteToFile = Person_WriteToFile;

	return pObj;
}


void delete_Person(Person* const pPersonObj)
{
	if (pPersonObj!= NULL)
	{
		free(pPersonObj->pFirstName);
		free(pPersonObj->pLastName);
		free(pPersonObj);
	}
}




void Person_DisplayInfo(Person* const pPersonObj)
{
	printf("FirstName: %s\n", pPersonObj->pFirstName);
	printf("LastName: %s\n", pPersonObj->pLastName);
}





void Person_WriteToFile(Person* const pPersonObj, const char* pFileName)
{
	// code for writing Person information to file
}
