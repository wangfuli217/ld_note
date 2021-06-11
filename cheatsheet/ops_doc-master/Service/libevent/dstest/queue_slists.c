/*
 * A simple program to demonstrate basic usage of the BSD SLIST (Single List) macros and
 * facilities. For info see queue(3).
 *
 * To compile the program do:
 *
 * gcc -g -o slists.exe slists.c && ./slists.exe
 *
 *
 * \author Luca Ferrari - fluca1978 (at) gmail (dot) com 
 */

#include <sys/queue.h>

#include <stdio.h>
#include <stdlib.h>


/*
 * Here we define the data-payload that we want to use. The only thing to
 * add to the application-logic data is a field to handle the pointers
 * to other data entries: this is done specifying a SLIST_ENTRY field of
 * the same type of the structure the application is using.
 *
 * An entry SLIST_ENTRY( car_st ) expands to the following:
 * \begincode
   struct { struct car_st *sle_next; } _cars;
 * \endcode
 * and therefore a field SLIST_ENTRY( car_st ) means that the application-logic
 * structure is added of an inner anonymous structure contained in the field
 * "_cars" which has a single field, named "sle_next", that is a pointer
 * to another application-logic structure "car_st". In other words:
 * +----------- car_st ----------+
 * |      <application data>     |
 * | SLIST_ENTRY( car_st ) _cars |  --- sle_next --->  +----------- car_st ----------+
 * +-----------------------------+  		       |      <application data>     |
 *						       | SLIST_ENTRY( car_st ) _cars |
 *                                                     +-----------------------------+
 */
struct car_st{					       
  char  model[ 20 ];
  int   cc_size;
  SLIST_ENTRY(car_st) _cars;
};



/*
 * An utility function used to dump the content of a car_st pointer
 * and to display the linking pointers.
 *
 * \param car a pointer to the struct car_st to print on the stdout
 */
void
dump_car( struct car_st * car ){
  if( car == NULL ){ printf( "\n--\n" ); }
  else{
    printf( "\nCar model = %s, engine size = %d ",
	    car->model, car->cc_size );
    printf( "\n\t{this element at 0x%x\tnext element at 0x%x}", 
	    car,
	    (car->_cars).sle_next );
  }
}





int
main( int argc, char** argv ){
  
  /*
   * Declaration and initilization of the list head.
   * The 'head' variable is defined as a structure of name 'CAR_SLIST'
   * that contains a single pointer to the type 'struct car_st'
   * and is initialized to NULL.
   *
   * In other words, the 'head' is expanded to the following piece of
   * code:
   * \begincode
     struct CAR_SLIST { struct car_st *slh_first; } head = { ((void *)0) };
   * \endcode
   */
  SLIST_HEAD( CAR_SLIST, car_st ) head  = SLIST_HEAD_INITIALIZER( head ); 
  int i;

  struct car_st *_cars;
  struct car_st *current  = NULL, *previous = NULL;
 


  for( i = 0; i < 10; i++ ){
    current = (struct car_st *) malloc( 1 * sizeof( struct car_st ) );
    snprintf( current->model, sizeof( current->model ), "Model %d", i );
    current->cc_size = 1000 + ( i + 1 ) * 500;

    /*
     * SLIST_EMPTY expands to the following piece of code:
     * \begincode
       ((&head)->slh_first == ((void *)0))
     * \endcode
     * and therefore tests if the first pointer (i.e., the pointer contained in the 'head')
     * is empty (i.e., NULL).
     *
     * The SLIST_INSERT_HEAD macro expands to the following:
     * \begincode
       do { (((current))->_cars.sle_next) = (((&head))->slh_first); (((&head))->slh_first) = (current); } while (0);
     * \endcode
     * in other words the 'current' element is placed as the head, and the head is shifted
     * as the next element of the current one.
     *
     * The macro SLIST_INSERT_AFTER expands to:
     * \begincode
        do { (((current))->_cars.sle_next) = (((previous))->_cars.sle_next); (((previous))->_cars.sle_next) = (current); } while (0);
     * \endcode
     * and therefore gets the 'previous' next element and places it as next element of
     * 'current' and makes 'current' the next one of the 'previous' element.
     */
    if( SLIST_EMPTY( &head ) )
      SLIST_INSERT_HEAD( &head, current, _cars );
    else
      SLIST_INSERT_AFTER( previous, current, _cars );
    

    previous = current;
  }



  printf( "\nTraversing the list using a foreach loop" );
  /*
   * The SLIST_FOREACH macro expands to:
   * \begincode
      for ((current) = (((&head))->slh_first); 
           (current); 
	   (current) = (((current))->_cars.sle_next))
   * \endcode
   * and therefore initializes the 'current' element to the first pointed by the 'head'
   * and then tests that it is not NULL and increments it every loop using the 'sle_next'
   * attribute of the 'current' node.
   */
  SLIST_FOREACH( current, &head, _cars ){
    dump_car( current );
  }


  printf( "\nTraversing the list using a next-based loop" );
  /*
   * The macro SLIST_FIRST expands to the following:
   * \begincode
     ((&head)->slh_first);
   * \endcode
   * that is the first element pointed by the head variable.
   *
   * The SLIST_NEXT macro expands to:
   * \begincode
     current = ((current)->_cars.sle_next);
   * \endcode
   * that is the 'sle_next' element of the 'cars' special attribute of the 'current'
   * structure.
   */
  current = SLIST_FIRST( &head );
  while( current != NULL ){
    dump_car( current );
    current = SLIST_NEXT( current, _cars );
  }



  printf( "\nTraversing the list and removing elements\n" );
  current = previous = NULL;
  /*
   * The SLIST_FOREACH_SAFE macro expands to the following:
   * \begincode
      for ((current) = (((&head))->slh_first); 
          (current) && ((previous) = (((current))->_cars.sle_next), 1); 
	  (current) = (previous))
   * \endcode
   * that assigns to 'current' the first element pointed by the list and to 'previous' the
   * next element (or NULL) and tests that 'current' is not NULL and 'previous' is not NULL
   * (and if the latter is NULL the always true '1' is evaluated to avoid finishing the
   * loop). The 'current' is incremented by pointing 'previous', that already was set to
   * the "next thing after current".
   *
   * The SLIST_REMOVE macro is expanded to the following:
   * \begincode
      do { ; 
          if ((((&head))->slh_first) == (current)) { 
	     do { ((((&head)))->slh_first) = ((((((&head)))->slh_first))->_cars.sle_next); } 
	     while (0); } 
          else { 
	         struct car_st *curelm = (((&head))->slh_first); 
                 while (((curelm)->_cars.sle_next) != (current)) 
                      curelm = ((curelm)->_cars.sle_next); 
		 do { 
		     ((curelm)->_cars.sle_next) 
                        = ((((curelm)->_cars.sle_next))->_cars.sle_next); } 
                 while (0); 
          } ; } while (0);
   * \endcode
   * that can be divided into two main branches:
   * - the first one deletes the first element (that is the one pointed by the
   * 'head' substituting it with the second one (i.e., first's next element)
   * - the second moves forward the list searching for an element that is the same as
   * the 'current' one (the one that is going to be deleted) and when found sets the
   * 'curelm' (the one before 'current') next element to the current-next element so
   * to exclude 'current' from the chain.
   */
  /*
  SLIST_FOREACH_SAFE( current, &head, _cars, previous ){
    if( (current->cc_size / 500) % 2 == 1 ){
      printf( "\n\tRemoving the car..." );
      SLIST_REMOVE( &head, current, car_st, _cars );
      free( current );
    }
  }
  


  printf( "\nTraversing the list using a foreach loop" );
  SLIST_FOREACH( current, &head, _cars ){
    dump_car( current );
  }
*/


  printf( "\nBye\n" );
  exit( 0 );
}
