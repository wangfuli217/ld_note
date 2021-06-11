/*****************************************************************************
A hash table implementation using templates.

Version: 1.3

Changes in 1.3:
- Bug in remove fixed.

Changes in 1.2:
- remove() has been implemented.
- New constructor makes a copy of an existing hash table.
- getKeys() and getElements() methods now return an enumeration of the table
  keys or elements respectively.
- Added GROWTH_FACTOR and PREFERRED_FILL_RATE constants.

Changes in 1.1:
- Hash function must return an unsigned integer.

Coded by: Mads Olesen (email: madman@daimi.au.dk).
*****************************************************************************/

#ifndef HASH_MAP_H
#define HASH_MAP_H

// --** Includes: **---------------------------------------------------
//#include "basicTypes.h"
#include <string>
#include <assert.h>
#include "Logger.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// --** Types: **------------------------------------------------------
typedef unsigned int uint;

template<class Tkey> class DefaultEqual
{
public:
  bool operator()(const Tkey& k1, const Tkey& k2) const { return k1 == k2; }
};

template<class Tkey> class DefaultHashFunction
{
public:
  uint operator()(const Tkey& k) const { return uint(k); }
};


template<> class DefaultHashFunction<string> 
{
public:
  uint operator()(const string& s) const 
  {
    assert(s != "");
    char* iterator = (char*)s.c_str();
    uint hash = 0;
    while (*iterator) hash = (hash << 1) + *iterator++;
    return hash;
  }
};


template<class Tkey, class Telm, 
         class ThashFunction = DefaultHashFunction<Tkey>,
         class Tequal = DefaultEqual<Tkey> > class HashMap
{
 private:
  // --** Internal classes: **--
  class HashElement
  {
    public:
    HashElement(Tkey key, Telm element) : key(key), element(element), next (NULL)
    {}

    Tkey key;
    Telm element;
    HashElement* next;
  };

  static const int GROWTH_FACTOR = 3;       // The factor with which the hash table array will be grown. Must be >1.
  static const int PREFERRED_FILL_RATE = 2; // The hash table array will be grown when it has PREFERRED_FILL_RATE elements per array index.
  
  // --** Internal data: **--
  int size;
  HashElement **table;
  
  int count;
  ThashFunction hashFunction;
  Tequal equal;
  
  // Internal functionality:
  void grow() {
    // Temporarily store old data:
    int oldSize = size;
    HashElement **oldTable = table;
    
    // Extend the table:
    size = int(GROWTH_FACTOR*size);
    table = new HashElement*[size];
    memset(table, 0, size*sizeof(HashElement*));
    
    // Re-hash:
    for (int i=0; i<oldSize; i++) {
      HashElement *current = oldTable[i];
      while (current != NULL) {
        // Store next:
        HashElement *next = current->next;
        
        // Put element in the new table:
        uint hash = hashFunction(current->key) % size;
        
        current->next = table[hash];
        table[hash] = current;
        
        // Next:
        current = next;
      }
    }
    
    // Delete old space:
    delete oldTable;
  }
  
 public:
  class Enum;

  // Public interface:
   HashMap(int size = 101) : size(size) {
    assert(size > 0);
    table = new HashElement*[size];
    memset(table, 0, size*sizeof(HashElement*));
    count = 0;
  }

  int elementCount() const {
    assert(table);
    return count;
  }
  
  bool put(Tkey key, Telm element) {
    // Grow if necessary:
    if (count > PREFERRED_FILL_RATE*size)
      grow();
    
    // Get hash value:
    uint hash = hashFunction(key) % size;
    
    // Check if it's already there:
    HashElement *current = table[hash];
    while (current != NULL) {
      if (equal(key, current->key))
        return false;
      current = current->next;
    }
    
    // Insert the element:
    HashElement *temp = new HashElement(key, element);
    
    temp->next = table[hash];
    table[hash] = temp;
    count++;
    
    return true;
  }
  
  bool get(Tkey key, Telm* result) const {
    // Get hash value:
    uint hash = hashFunction(key) % size;
    
    // Traverse the linked list:
    HashElement *current = table[hash];
    while (current != NULL) {
      if (equal(key, current->key)) {
        *result = current->element;
        return true;
      }
      current = current->next;
    }
    
    // Not found:
    return false;
  }
  

  // BIIIIG TODO!!!
  bool getVECTOR(Tkey key, Telm* result) const {
    // Get hash value:
    uint hash = hashFunction(key) % size;
    
    // Traverse the linked list:
    HashElement *current = table[hash];
    while (current != NULL) {
      if (key == current->key) { 
        *result = current->element;
        return true;
      }
      current = current->next;
    }
    
    // Not found:
    return false;
  }

  bool defined(Tkey key) const {
    // Get hash value:
    uint hash = hashFunction(key) % size;
    
    // Fetch the element:
    HashElement *current = table[hash];
    while (current != NULL) {
      if (equal(key, current->key))
        return true;
      current = current->next;
    }
    
    // Not found:
    return false;
  }
  
  bool remove(Tkey key) {
    // Get hash value:
    uint hash = hashFunction(key) % size;
    
    // Traverse the linked list:
    HashElement** pointerTo = &(table[hash]);
    HashElement* current = table[hash];
    
    while (current != NULL) {
      if (equal(key, current->key)) {
        // Put aside the element (data):
        Telm element = current->element;
        
        // Remove element:
        *pointerTo = current->next;
        delete current;
        count--;
        
        // Return:
        return true;
      }
      
      pointerTo = &(current->next);
      current = current->next;
    }
    
    // Not found:
    return false;
  }
  
  Enum getEnum()
  {
    return Enum(this);
  }
  
  /*
  void printDispersionGraph(int width, int height) {
    // Check input:
    if (width < 1 || height < 1)
      printf("Error: Invalid input for dispersio graph printing (%d,%d).\n", width, height);
    
    // Simple statistics:
    printf("Table size: %d\n", size);
    printf("Element count: %d\n", count);
    printf("Table entries per column: %.2f\n", float(size)/float(width));
    
    // Create dispersion table:
    dword *dispersion = new dword[width];
    memset(dispersion, 0, sizeof(dword)*width);
    
    // Fill dispersion table:
    for (int i=0; i<size; i++) {
      HashElement *current = table[i];
      while (current != NULL) {
        dispersion[i*width/size]++;
        current = current->next;
      }
    }
    
    // Check data integrity:
    int c = 0;
    for (int i=0; i<width; i++)
      c += dispersion[i];
    
    if (c != count)
      printf("Error: Corrupt data. Invalid count in hash table.\n");
    
    // Find max dispersion:
    int max = 0;
    for (int i=0; i<width; i++)
      if (dispersion[i] > max)
        max = dispersion[i];
    
    // Convert dispersion table to graph heights:
    for (int i=0; i<width; i++)
      dispersion[i] = dispersion[i]*height/max;
    
    // Make the graph:
    for (int y=height; y>=1; y--) {
      // The left axis:
      if (y == height)
        printf("^");
      else
        printf("|");
      
      // *'s:
      for (int x=0; x<width; x++) {
        if (y <= dispersion[x])
          printf("*");
        else
          printf(" ");
      }
      
      // Newline:
      printf("\n");
    }
    
    // Bottom axis: (width+1 to account for the left axis)
    for (int i=0; i<width+1; i++) {
      if (i == width)
        printf(">");
      else
        printf("-");
    }
    printf("\n");
    
    // Print unit:
    printf("* ~= %.2f elements.\n", float(max)/float(height));
  }
*/

  class Enum {
  private:
    HashMap* owner;
    uint currentTableIndex;
    HashElement* currentElement;
    
  public:
    Enum(HashMap* owner) : owner(owner), currentTableIndex(0), currentElement(NULL)
    {
      while ((currentElement == NULL) && (currentTableIndex < owner->size)){
        currentElement = owner->table[currentTableIndex];
        currentTableIndex++;
      }
    }

    bool hasMore() const
    {
      // return true if a nextElement() call wil work
      if (currentElement) {
        return true;
      }
      return false;
    }
    
    void next()
    {
      // Assume that (hasMore == true), i.e. currentElement != NULL
      if (currentElement->next) {
        currentElement = currentElement->next;
      }
      else {
        bool foundNextElement = false;
        currentTableIndex++;
        while (currentTableIndex < owner->size) {
          if (owner->table[currentTableIndex] != NULL) {
            currentElement = owner->table[currentTableIndex];
            foundNextElement = true;
            break;
          }
          currentTableIndex++;
        }
        // Check if we have reached the end
        if (!foundNextElement) {
          currentElement = NULL;
        }
      }
    }

    Telm getElement()
    {
      return currentElement->element;
    }

    Tkey getKey()
    {
      return currentElement->key;
    }
  };

/*
  class iterator {
    HashMap* owner;
    uint currentHashIndex;
    HashElement* currentElement;
    
    iterator(HashMap* owner) : owner(owner)
    {

    }

    iterator& operator++()
    {
      if (currentElement->next) {
        currentElement = currentElement->next;
      }
      else {

      }
    }

    Telm& operator*()
    {
      return currentElement->element;
    }
  };
*/
};



#endif
