#include "vector.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <limits.h>
#include <assert.h>

#define YES_OR_NO(value) (value != 0 ? "Yes" : "No")

/**
 * PrintChar
 * ---------
 * Mapping function used to print one character element in a vector.  
 * The file pointer is passed as the client data, so that it can be
 * used to print to any FILE *.
 */

static void PrintChar(void *elem, void *fp)
{
  fprintf((FILE *)fp, "%c", *(char *)elem);
  fflush((FILE *)fp);
}

/**
 * CompareChar
 * -----------
 * Comparator function used to compare two character elements within a vector.
 * Used for both sorting and searching in the array of characters.  Has the same
 * return value semantics as the strcmp library function (negative if A<B, zero if A==B,
 * positive if A>B).
 */

static int CompareChar(const void *elemA, const void *elemB)
{
  return (*(char *)elemA - *(char *)elemB);
}

/**
 * Function: TestAppend
 * --------------------
 * Appends letters of alphabet in order, then appends a few digit chars.
 * Uses vector_Map to print the vector contents before and after.
 */

static void TestAppend(struct vector *alphabet)
{
  char ch;
  int i;
  
  for (ch = 'A'; ch <= 'Z'; ch++)   //  Start with letters of alphabet
    vector_append(alphabet, &ch);
  fprintf(stdout, "First, here is the alphabet: ");
  vector_map(alphabet, PrintChar, stdout);
  
  for (i = 0; i < 10; i++) {	    // Append digit characters
    ch = '0' + i;                   // convert int to ASCII digit character
    vector_append(alphabet, &ch);
  }
  fprintf(stdout, "\nAfter append digits: ");
  vector_map(alphabet, PrintChar, stdout);
}


/**
 * Function: TestSearch
 * --------------------
 * Tests the searching capability of the vector by looking for specific
 * character.  Calls vector_Search twice, once to see if it finds the character
 * using a binary search (given the array is sorted) and once to see if it
 * finds the character using a linear search.  Reports results to stdout.
 */

static void TestSearch(struct vector *v, char ch)
{
  int foundSorted, foundNot;
  
  foundSorted = vector_search(v, &ch, CompareChar, 0, 1); // Test sorted 
  foundNot = vector_search(v, &ch, CompareChar, 0, 0);   // Not sorted 
  fprintf(stdout,"\nFound '%c' in sorted array? %s. How about unsorted? %s.", 
	  ch, YES_OR_NO((foundSorted != -1)), 
	  YES_OR_NO((foundNot != -1)));
}

/**
 * Function: TestSortSearch
 * ------------------------
 * Sorts the vector into alphabetic order and then tests searching
 * capabilities, both the linear and binary search versions.
 */

static void TestSortSearch(struct vector *alphabet)
{
  vector_sort(alphabet, CompareChar);	 // Sort into order again
  fprintf(stdout, "\nAfter sorting: ");
  vector_map(alphabet, PrintChar, stdout);
  TestSearch(alphabet, 'J');	// Test searching capabilities
  TestSearch(alphabet, '$');
}

/**
 * Function: TestAt
 * ----------------
 * Uses vector_Nth to access every other letter and 
 * lowercase it. Prints results using vector_Map.
 */

static void TestAt(struct vector *alphabet)
{
  int i;
  
  for (i = 0; i < vector_length(alphabet); i += 2) { // Lowercase every other
    char *elem = (char *) vector_Nth(alphabet, i);
    *elem = tolower(*elem);
  }
  
  fprintf(stdout, "\nAfter lowercase every other letter: ");
  vector_map(alphabet, PrintChar, stdout);
}

/**
 * Function: TestInsertDelete
 * --------------------------
 * Inserts dashes at regular intervals, then uses delete to remove
 * them.  Makes sure that insert at allows you to insert at end of
 * array and checks no problem with deleting very last element.  It's
 * always a good idea to directly test the borderline cases to make
 * sure you have handled even the unusual scenarios.
 */

static void TestInsertDelete(struct vector *alphabet)
{
  char ch = '-';
  int i;
  
  for (i = 3; i < vector_length(alphabet); i += 4) // Insert dash every 4th char 
    vector_insert(alphabet, &ch, i);
  fprintf(stdout, "\nAfter insert dashes: ");
  vector_map(alphabet, PrintChar, stdout); 
  
  for (i = 3; i < vector_length(alphabet); i += 3) // Delete every 4th char 
    vector_delete(alphabet, i);
  fprintf(stdout, "\nAfter deleting dashes: ");
  vector_map(alphabet, PrintChar, stdout);
    
  ch = '!';
  vector_insert(alphabet, &ch, vector_length(alphabet));
  vector_delete(alphabet, vector_length(alphabet) - 1);
  fprintf(stdout, "\nAfter adding and deleting to very end: ");
  vector_map(alphabet, PrintChar, stdout);
}

/**
 * Function: TestReplace
 * ---------------------
 * Uses repeated searches to find all occurrences of a particular
 * character and then uses replace it to overwrite value.
 */

static void TestReplace(struct vector *alphabet)
{
  int found = 0;
  char toFind = 's', toReplace = '*';
  
  while (found < vector_length(alphabet)) {
    found = vector_search(alphabet, &toFind, CompareChar, found, 0);
    if (found == -1) break;
    vector_replace(alphabet, &toReplace, found);
  }
  
  fprintf(stdout, "\nAfter changing all %c to %c: ", toFind, toReplace);
  vector_map(alphabet, PrintChar, stdout);
}

/** 
 * Function: SimpleTest
 * --------------------
 * Exercises the vector when it stores characters.
 * Because characaters are small and don't have any
 * complicated memory requirements, this test is a
 * good starting point to see whether or not your vector
 * even has a prayer of passing more rigorous tests.
 *
 * See the documentation for each of the helper functions
 * to gain a sense as to how SimpleTest works.  The intent
 * it certainly to try out all of the vector operations so
 * that everything gets exercised.
 */

static void SimpleTest()
{
  fprintf(stdout, " ------------------------- Starting the basic test...\n");
  struct vector alphabet;
  vector_new(&alphabet, sizeof(char), NULL, 4);
  TestAppend(&alphabet);
  TestSortSearch(&alphabet);
  TestAt(&alphabet);
  TestInsertDelete(&alphabet);
  TestReplace(&alphabet);
  vector_dispose(&alphabet);
}

/** 
 * Function: InsertPermutationOfNumebrs
 * ------------------------------------
 * Uses a little bit of number theory to populate the
 * presumably empty numbers vector with some permutation
 * of the integers between 0 and d - 1, inclusive.  
 * By design, each number introduced to the vector should
 * be introduces once and exactly once.  This happens
 * provided n < d and that both n and d are prime numbers.
 */

static void InsertPermutationOfNumbers(struct vector *numbers, long n, long d)
{
  long k;
  long residue;
  fprintf(stdout, "Generating all of the numbers between 0 and %ld (using some number theory). ", d - 1);
  fflush(stdout); // force echo to the screen... 

  for (k = 0; k < d; k++) {
    residue = (long) (((long long)k * (long long) n) % d);
    vector_append(numbers, &residue);
  }
  
  assert(vector_length(numbers) == d);
  fprintf(stdout, "[All done]\n");
  fflush(stdout);
}

/**
 * Function: LongCompare
 * ---------------------
 * Called when searching or sorting a vector known to
 * be storing long integer data types.
 */

static int LongCompare(const void *vp1, const void *vp2)
{
  return (*(const long *)vp1) - (*(const long *)vp2);
}

/**
 * Function: SortPermutation
 * -------------------------
 * Sorts the (very, very large) vectorToSort, and confirms
 * that the sort worked.  This is slightly more strenous
 * that the TestSort routine above simply because the vector
 * is much, much bigger.
 */

static void SortPermutation(struct vector *vectorToSort)
{
  long residue, embeddedLong;
  struct vector *sortedvector;
  fprintf(stdout, "Sorting all of those numbers. ");
  fflush(stdout);
  vector_sort(vectorToSort, LongCompare);
  fprintf(stdout, "[Done]\n");
  fflush(stdout);
  fprintf(stdout, "Confirming everything was properly sorted. ");
  fflush(stdout);
  sortedvector = vectorToSort; // need better name now that it's sorted... 
  for (residue = 0; residue < vector_length(sortedvector); residue++) {
    embeddedLong = *(const long *) vector_Nth(sortedvector, residue);
    assert(embeddedLong == residue);
  }
  fprintf(stdout, "[Yep, it's sorted]\n");
  fflush(stdout);
}

/**
 * Function: DeleteEverythingVerySlowly
 * ------------------------------------
 * Empties out the vector in such a way that vector_Delete
 * is exercised to the hilt.  By repeatedly deleting from
 * within the vector, we ensure that the shifting over of
 * bytes is working properly.
 */

static void DeleteEverythingVerySlowly(struct vector *numbers)
{
  long largestOriginalNumber;
  fprintf(stdout, "Erasing everything in the vector by repeatedly deleting the 100th-to-last remaining element (be patient).\n");
  fflush(stdout);
  largestOriginalNumber = *(long *)vector_Nth(numbers, vector_length(numbers) - 1);
  while (vector_length(numbers) >= 100) {
    vector_delete(numbers, vector_length(numbers) - 100);
    assert(largestOriginalNumber == *(long *)vector_Nth(numbers, vector_length(numbers) -1));
  }
  fprintf(stdout, "\t[Okay, almost done... deleting the last 100 elements... ");
  fflush(stdout);
  while (vector_length(numbers) > 0) vector_delete(numbers, 0);
  fprintf(stdout, "and we're all done... whew!]\n");
  fflush(stdout);
}

/**
 * Function: ChallengingTest
 * -------------------------
 * Uses a little bit of number theory to generate a very large vector
 * of four-byte values.  Some permutation of the numbers [0, 3021367)
 * is generated, and in the process the vector grows in such a way that
 * several realloc calls are likely made.  This will catch any errors
 * with the reallocation, particulatly those where the implementation
 * fails to catch realloc's return value.  The test then goes on the
 * sort the array, confirm that the sort succeeded, and then finally
 * delete all of the elements one by one.
 */

static const long kLargePrime = 1398269;
static const long kEvenLargerPrime = 3021377;
static void ChallengingTest()
{
  struct vector lotsOfNumbers;
  fprintf(stdout, "\n\n------------------------- Starting the more advanced tests...\n");  
  vector_new(&lotsOfNumbers, sizeof(long), NULL, 4);
  InsertPermutationOfNumbers(&lotsOfNumbers, kLargePrime, kEvenLargerPrime);
  SortPermutation(&lotsOfNumbers);
  DeleteEverythingVerySlowly(&lotsOfNumbers);
  vector_dispose(&lotsOfNumbers);
}

/** 
 * Function: FreeString
 * --------------------
 * Understands how to free a C-string.  This
 * function should be used by all vectors that
 * store char *'s (but only when those char *s
 * point to dynamically allocated memory, as
 * they do with strings.)
 */

static void FreeString(void *elemAddr)
{
  char *s = *(char **) elemAddr;
  free(s); 
}

/** 
 * Function: PrintString
 * ---------------------
 * Understands how to print a C-string stored
 * inside a vector.  The target FILE * should
 * be passed in via the auxData parameter.
 */

static void PrintString(void *elemAddr, void *auxData)
{
  char *word = *(char **)elemAddr;
  FILE *fp = (FILE *) auxData;
  fprintf(fp, "\t%s\n", word);
}

/**
 * Function: MemoryTest
 * --------------------
 * MemoryTest exercises the vector functionality by
 * populating one with pointers to dynamically allocated
 * memory.  The insertion process marks the transfer of
 * of responsibility from the client to the vector, so
 * we now need to specify a non-NULL vector_FreeFunction so
 * the a vector can apply it to the elements it inherits
 * from the client.  Make sure you understand why the
 * casts within the two functions above (FreeString, PrintString)
 * are char ** casts and not char *.  If you truly understand,
 * they you've learned what is probably the most difficult-to-
 * learn concept taught in CS107.
 */

static void MemoryTest()
{
  int i;
  const char * const kQuestionWords[] = {"who", "what", "where", "how", "why"};
  const int kNumQuestionWords = sizeof(kQuestionWords) / sizeof(kQuestionWords[0]);
  struct vector questionWords;
  char *questionWord;
  
  fprintf(stdout, "\n\n------------------------- Starting the memory tests...\n");
  fprintf(stdout, "Creating a vector designed to store dynamically allocated C-strings.\n");
  vector_new(&questionWords, sizeof(char *), FreeString, kNumQuestionWords);
  fprintf(stdout, "Populating the char * vector with the question words.\n");
  for (i = 0; i < kNumQuestionWords; i++) {
    questionWord = malloc(strlen(kQuestionWords[i]) + 1);
    strcpy(questionWord, kQuestionWords[i]);
    vector_insert(&questionWords, &questionWord, 0);  // why the ampersand? isn't questionWord already a pointer?
  }
  
  fprintf(stdout, "Mapping over the char * vector (ask yourself: why are char **'s passed to PrintString?!!)\n");
  vector_map(&questionWords, PrintString, stdout);
  fprintf(stdout, "Finally, destroying the char * vector.\n");
  vector_dispose(&questionWords);
}

/**
 * Function: main
 * --------------
 * The enrty point into the test application.  The
 * first test is easy, the second one is medium, and
 8 the final test is hard.
 */

int main(int ignored, char **alsoIgnored) 
{
  SimpleTest();
  ChallengingTest();
  MemoryTest();
  return 0;
}
