/* *************************************************************** */
/* ****    Generic list class                                 **** */
/* ****                                                       **** */
/* ****    Copyright: Kasper Fauerby, Peroxide 2001           **** */
/* ****               telemachos@peroxide.dk                  **** */
/* ****    Original Author: Stan Melax (melax@cs.ualberta.ca) **** */
/* *************************************************************** */
#ifndef GENERIC_LIST_H
#define GENERIC_LIST_H

#include <assert.h>
#include <stdio.h>

template <class Type> class List
{
public:
  List(int s = 0);
  ~List();
  void	allocate(int s); // Make sure that 'element[s] = x' will go well 
  void	Add(Type);
  void	AddUnique(Type);
  int 	Contains(Type);
  void	Remove(Type);
  void	DelIndex(int i);
  void  Clear() { size = 0; }
  Type* element;
  int	size; // next place to insert. Size of USED part of list
  int	array_size; // size of list
  Type &operator[](int i);
};

template <class Type> List<Type>::List(int s)
{
	size=0;
	array_size = 16;
	element = new Type[array_size];
  
  allocate(s);
}

template <class Type> Type& List<Type>::operator[](int i)
{

  if (i >= size) {
    allocate(i);
    size = i+1;
  }
  return element[i];
}

template <class Type> List<Type>::~List()
{
	delete[] element;
	element = NULL;
	size = 0;
	array_size = 0;
}

template <class Type> void List<Type>::allocate(int s)
{
  if (s < array_size)
    return;
  
	Type *old = element;
	array_size = s*2;
	element = new Type[array_size];
  
  // Copy elements from the old to the new array
	for(int i = 0; i < size; i++){
		element[i] = old[i];
	}
  
  delete[] old;
}

template <class Type> void List<Type>::Add(Type t)
{
	assert(size<=array_size);

  allocate(size + 1);

	element[size++] = t;
}

template <class Type> int List<Type>::Contains(Type t)
{
	int count=0;
	for(int i = 0; i < size; i++) {
    if(element[i] == t) count++;
	}
	return count;
}

template <class Type> void List<Type>::AddUnique(Type t)
{
	if(!Contains(t))
    Add(t);
}

template <class Type> void List<Type>::DelIndex(int i)
{
	assert(i < size);
	size--;
	while (i < size) {
		element[i] = element[i+1];
		i++;
	}
}

template <class Type> void List<Type>::Remove(Type t)
{
	for(int i = 0; i < size; i++) {
		if(element[i] == t) {
      DelIndex(i);
			break;
		}
	}
}

#endif
